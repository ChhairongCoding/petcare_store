import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:petcare_store/src/features/cart/controller/cart_controller.dart';

enum PaymentMethod { khqr, cashOnDelivery, abaPay }

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class PaymentController extends GetxController {
  final _supabase = Supabase.instance.client;

  // ─── Observables ───────────────────────────────────────────
  final selectedPaymentMethod = Rxn<PaymentMethod>();
  final orderStatus = Rx<OrderStatus>(OrderStatus.pending);
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final currentOrderId = ''.obs;

  /// Becomes true when KHQR payment is confirmed (status → processing)
  final paymentConfirmed = false.obs;

  StreamSubscription? _statusSubscription;

  // ─── Payment Method ────────────────────────────────────────
  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
  }

  String get paymentMethodLabel {
    switch (selectedPaymentMethod.value) {
      case PaymentMethod.khqr:
        return 'KHQR';
      case PaymentMethod.cashOnDelivery:
        return 'Cash on Delivery';
      case PaymentMethod.abaPay:
        return 'ABA Pay';
      default:
        return 'Not selected';
    }
  }

  bool get isPaymentMethodSelected => selectedPaymentMethod.value != null;

  // ─── Place Order ───────────────────────────────────────────
  Future<bool> placeOrder({
    required CartController cartController,
    required String userId,
    required String addressId,
    required double totalPrice,
  }) async {
    if (!isPaymentMethodSelected) {
      errorMessage.value = 'Please select a payment method.';
      return false;
    }
    if (addressId.isEmpty) {
      errorMessage.value = 'Please select a delivery address.';
      return false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 1. Build order items payload
      final List<Map<String, dynamic>> orderItems = cartController.cartItems
          .map(
            (item) => {
              'product_id': item.product.id,
              'product_name': item.product.name,
              'quantity': item.quantity,
              'unit_price': item.product.price,
              'subtotal': item.product.price * item.quantity,
            },
          )
          .toList();

      // 2. Insert order into Supabase
      // ✅ FIXED
      final response = await _supabase
          .from('orders')
          .insert({
            'user_id': userId, // ← app uses this
            'buyer':
                userId, // ← RLS policy was checking this (now fixed to user_id, but keep for consistency)
            'address_id': addressId,
            'payment_method': selectedPaymentMethod.value!.name,
            'status': OrderStatus.pending.name,
            'total_price': totalPrice,
            'items': orderItems,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select('id')
          .single();

      currentOrderId.value = response['id'].toString();
      orderStatus.value = OrderStatus.pending;
      paymentConfirmed.value = false;

      // 3. Clear the cart
      cartController.removeAllItem();

      return true;
    } on PostgrestException catch (e) {
      errorMessage.value = 'Database error: ${e.message}';
      return false;
    } catch (e) {
      errorMessage.value = 'Unexpected error: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Track Order ───────────────────────────────────────────
  Future<void> fetchOrderStatus(String orderId) async {
    try {
      isLoading.value = true;

      final response = await _supabase
          .from('orders')
          .select('status')
          .eq('id', orderId)
          .single();

      final status = OrderStatus.values.firstWhere(
        (e) => e.name == response['status'],
        orElse: () => OrderStatus.pending,
      );
      orderStatus.value = status;
      if (status == OrderStatus.processing) {
        paymentConfirmed.value = true;
      }
    } on PostgrestException catch (e) {
      errorMessage.value = 'Failed to fetch order: ${e.message}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Subscribe to real-time order status changes.
  /// Sets [paymentConfirmed] to true when status reaches [processing].
  void subscribeToOrderStatus(String orderId) {
    _statusSubscription?.cancel();
    _statusSubscription = _supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('id', orderId)
        .listen((data) {
          if (data.isNotEmpty) {
            final status = OrderStatus.values.firstWhere(
              (e) => e.name == data.first['status'],
              orElse: () => OrderStatus.pending,
            );
            orderStatus.value = status;
            if (status == OrderStatus.processing) {
              paymentConfirmed.value = true;
            }
          }
        });
  }

  void cancelSubscription() {
    _statusSubscription?.cancel();
    _statusSubscription = null;
  }

  String get orderStatusLabel {
    switch (orderStatus.value) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  // ─── Reset ─────────────────────────────────────────────────
  void reset() {
    selectedPaymentMethod.value = null;
    orderStatus.value = OrderStatus.pending;
    currentOrderId.value = '';
    errorMessage.value = '';
    paymentConfirmed.value = false;
    cancelSubscription();
  }

  @override
  void onClose() {
    cancelSubscription();
    super.onClose();
  }
}

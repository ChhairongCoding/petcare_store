import 'package:get/get.dart';
import 'package:petcare_store/features/my_orders/controller/order_controller.dart';
import 'package:petcare_store/features/my_orders/models/order_model.dart';
import 'package:petcare_store/src/features/cart/controller/cart_controller.dart';
import 'package:petcare_store/src/features/cart/models/cart_item_model.dart';
import 'package:uuid/uuid.dart';

class CheckoutController extends GetxController {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();

  RxString selectedPaymentMethod = 'Cash on Delivery'.obs;
  RxString shippingAddress = ''.obs;
  RxBool isProcessing = false.obs;

  final List<String> paymentMethods = [
    'Cash on Delivery',
    'Credit Card',
    'PayPal',
    'Bank Transfer',
  ];

  double get subtotal => cartController.totalPrice.value;
  double get shippingFee => subtotal > 50 ? 0.0 : 5.0; // Free shipping over $50
  double get total => subtotal + shippingFee;

  void updatePaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void updateShippingAddress(String address) {
    shippingAddress.value = address;
  }

  Future<bool> processCheckout() async {
    if (cartController.cartItems.isEmpty) {
      Get.defaultDialog(
        title: 'Error',
        middleText: 'Cart is empty',
        textConfirm: 'OK',
        onConfirm: () => Get.back(),
      );
      return false;
    }

    if (shippingAddress.isEmpty) {
      Get.defaultDialog(
        title: 'Error',
        middleText: 'Please enter shipping address',
        textConfirm: 'OK',
        onConfirm: () => Get.back(),
      );
      return false;
    }

    isProcessing(true);

    try {
      // Create order
      final orderId = const Uuid().v4();
      final order = OrderModel(
        id: orderId,
        items: List<CartItemModel>.from(cartController.cartItems),
        totalAmount: total,
        shippingAddress: shippingAddress.value,
        paymentMethod: selectedPaymentMethod.value,
      );

      // Add order to order controller
      await orderController.addOrder(order);

      // Clear cart
      cartController.clearCart();

      // Navigate to order success or my orders
      Get.offNamed('/myorders');

      Get.defaultDialog(
        title: 'Success',
        middleText: 'Order placed successfully!',
        textConfirm: 'OK',
        onConfirm: () => Get.back(),
      );
      return true;
    } catch (e) {
      Get.defaultDialog(
        title: 'Error',
        middleText: 'Failed to process order: $e',
        textConfirm: 'OK',
        onConfirm: () => Get.back(),
      );
      return false;
    } finally {
      isProcessing(false);
    }
  }
}

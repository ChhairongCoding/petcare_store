import 'dart:convert';

import 'package:get/get.dart';
import 'package:petcare_store/features/my_orders/models/order_model.dart';

class LocalService {
  final Map<String, String> _storage = {};

  Future<void> saveData(String key, String value) async {
    _storage[key] = value;
  }

  Future<String?> getData(String key) async {
    return _storage[key];
  }
}

class OrderController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final LocalService _localService = LocalService();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading(true);
    try {
      final ordersJsonString = await _localService.getData('orders');
      if (ordersJsonString != null) {
        final ordersData = jsonDecode(ordersJsonString) as List<dynamic>;
        orders.value = ordersData
            .map<OrderModel>((orderJson) => OrderModel.fromJson(orderJson))
            .toList();
      }
    } catch (e) {
      print('Error loading orders: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addOrder(OrderModel order) async {
    orders.add(order);
    await _saveOrdersToLocal();
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final orderIndex = orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final updatedOrder = OrderModel(
        id: orders[orderIndex].id,
        items: orders[orderIndex].items,
        totalAmount: orders[orderIndex].totalAmount,
        status: status,
        orderDate: orders[orderIndex].orderDate,
        shippingAddress: orders[orderIndex].shippingAddress,
        paymentMethod: orders[orderIndex].paymentMethod,
      );
      orders[orderIndex] = updatedOrder;
      await _saveOrdersToLocal();
    }
  }

  Future<void> _saveOrdersToLocal() async {
    final ordersJson = orders.map((order) => order.toJson()).toList();
    final ordersJsonString = jsonEncode(ordersJson);
    await _localService.saveData('orders', ordersJsonString);
  }

  OrderModel? getOrderById(String orderId) {
    return orders.firstWhereOrNull((order) => order.id == orderId);
  }

  List<OrderModel> getOrdersByStatus(OrderStatus status) {
    return orders.where((order) => order.status == status).toList();
  }
}

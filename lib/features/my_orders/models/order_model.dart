
import 'package:petcare_store/src/features/cart/models/cart_item_model.dart';

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime orderDate;
  final String? shippingAddress;
  final String? paymentMethod;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    this.status = OrderStatus.pending,
    DateTime? orderDate,
    this.shippingAddress,
    this.paymentMethod,
  }) : orderDate = orderDate ?? DateTime.now();

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status.name,
      'orderDate': orderDate.toIso8601String(),
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromJson(item))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
          : DateTime.now(),
      shippingAddress: json['shippingAddress'],
      paymentMethod: json['paymentMethod'],
    );
  }
}

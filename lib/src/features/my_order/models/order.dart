import 'package:petcare_store/src/features/my_order/models/order_item.dart';

class Order {
  final String id;
  final String buyer;
  final double totalPrice;
  final DateTime createdAt;
  final String status;
  final String userId;
  final String addressId;
  final String paymentMethod;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.buyer,
    required this.totalPrice,
    required this.createdAt,
    required this.status,
    required this.userId,
    required this.addressId,
    required this.paymentMethod,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      buyer: json['buyer'],
      totalPrice: double.parse(json['total_price'].toString()),
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'],
      userId: json['user_id'],
      addressId: json['address_id'],
      paymentMethod: json['payment_method'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer': buyer,
      'total_price': totalPrice,
      'created_at': createdAt.toIso8601String(),
      'status': status,
      'user_id': userId,
      'address_id': addressId,
      'payment_method': paymentMethod,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

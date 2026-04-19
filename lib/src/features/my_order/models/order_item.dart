class OrderItem {
  final int quantity;
  final double subtotal;
  final String productId;
  final double unitPrice;
  final String productName;
  final String? variantId;

  OrderItem({
    required this.quantity,
    required this.subtotal,
    required this.productId,
    required this.unitPrice,
    required this.productName,
    this.variantId,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      quantity: json['quantity'],
      subtotal: double.parse(json['subtotal'].toString()),
      productId: json['product_id'],
      unitPrice: double.parse(json['unit_price'].toString()),
      productName: json['product_name'],
      variantId: json['variant_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'subtotal': subtotal,
      'product_id': productId,
      'unit_price': unitPrice,
      'product_name': productName,
      'variant_id': variantId,
    };
  }
}

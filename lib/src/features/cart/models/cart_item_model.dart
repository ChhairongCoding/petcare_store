import 'package:petcare_store/src/features/products/model/product_model.dart';
import 'package:petcare_store/src/features/products/model/product_variant_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;
  final String? variantId;
  final ProductVariantModel? variant;

  CartItemModel({
    required this.product,
    this.quantity = 1,
    this.variantId,
    this.variant,
  });

  double get totalPrice => (variant?.price ?? product.price) * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'variantId': variantId,
      // Variant might be complex to serialize/deserialize without a full fromJson/toJson there
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
      variantId: json['variantId'],
    );
  }
}

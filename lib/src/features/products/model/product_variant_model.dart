class ProductVariantModel {
  final String id;
  final String productId;
  final String? animalType;
  final String? flavor;
  final String? weightLabel;
  final double? weightKg;
  final String? sku;
  final double price;
  final int stockQty;
  final bool isActive;

  ProductVariantModel({
    required this.id,
    required this.productId,
    this.animalType,
    this.flavor,
    this.weightLabel,
    this.weightKg,
    this.sku,
    required this.price,
    required this.stockQty,
    required this.isActive,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      animalType: json['animal_types']?['name'],
      flavor: json['flavors']?['name'],
      weightLabel: json['weight_options']?['label'],
      weightKg: (json['weight_options']?['weight_kg'] as num?)?.toDouble(),
      sku: json['sku'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stockQty: (json['stock_qty'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }
}

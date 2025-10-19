class ProductModel {
  final String id;
  final String name;
  final double price;
  final String imagePath;
  final String? description;
  final int? rating;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    this.description,
    this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imagePath: json['image_path'] ?? '',
      description: json['description'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image_url': imagePath,
      'description': description,
      'rating': rating,
    };
  }
}

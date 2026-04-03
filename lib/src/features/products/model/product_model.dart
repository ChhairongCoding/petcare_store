import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  final bucketUrl = dotenv.env['bucketUrl']??'';
  final rawPath = json['image_path'] ?? '';

  return ProductModel(
    id: json['id']?.toString() ?? '',
    name: json['name'] ?? 'Unknown',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
   imagePath: rawPath.startsWith('http') ? rawPath : '$bucketUrl$rawPath',
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

  factory ProductModel.fake() {
    return ProductModel(
      id: 'fake',
      name: 'Loading product...',
      price: 0,
      imagePath: '',
      description: '',
      rating: 0,
    );
  }
}

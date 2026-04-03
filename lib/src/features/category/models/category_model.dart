class CategoryModel {
  final String image;
  final String name;

  CategoryModel({required this.image, required this.name});

  // From Map (useful if fetching from API or DB)
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      image: json['image'] ?? '',
      name: json['name'] ?? '',
    );
  }

  // To Map (useful if saving to DB or API)
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
    };
  }
}

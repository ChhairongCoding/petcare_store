class Package {
  final String id;
  final String name;
  final DateTime createdAt;
  final double? price;

  Package({
    required this.id,
    required this.name,
    required this.createdAt,
    this.price,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      price: json['price'] == null
          ? null
          : double.parse(json['price'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'price': price,
    };
  }
}

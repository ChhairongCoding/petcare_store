class ShippingModel {
  final String? id;
  final String name;
  final String addressDetail;
  final String lat;
  final String lng;
  final bool isDefault;

  ShippingModel({
    this.id,
    required this.name,
    required this.addressDetail,
    required this.lat,
    required this.lng,
    required this.isDefault
  });

  factory ShippingModel.fromJson(Map<String, dynamic> json) {
    return ShippingModel(
      id: json["id"] ?? "",
      name: json["name"] ??"",
      addressDetail: json["address_detail"]??"",
      lat: json["lat"]??'',
      lng: json["lng"]??'',
      isDefault :  json["default"] ?? false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address_detail': addressDetail,
      'lat': lat,
      'lng': lng,
      'default' : isDefault
    };
  }
  // Add to ShippingModel
ShippingModel copyWith({
  String? id,
  String? name,
  String? addressDetail,
  String? lat,
  String? lng,
  bool? isDefault,
}) {
  return ShippingModel(
    id: id ?? this.id,
    name: name ?? this.name,
    addressDetail: addressDetail ?? this.addressDetail,
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
    isDefault: isDefault ?? this.isDefault,
  );
}
}

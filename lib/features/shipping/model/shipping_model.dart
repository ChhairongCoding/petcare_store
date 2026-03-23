class ShippingModel {
  final String? id;
  final String name;
  final String addressDetail;
  final String lat;
  final String lng;

  ShippingModel({
    this.id,
    required this.name,
    required this.addressDetail,
    required this.lat,
    required this.lng,
  });

  factory ShippingModel.fromJson(Map<String, dynamic> json) {
    return ShippingModel(
      id: json["id"] ?? "",
      name: json["name"] ??"",
      addressDetail: json["address_detail"]??"",
      lat: json["lat"]??'',
      lng: json["lng"]??'',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address_detail': addressDetail,
      'lat': lat,
      'lng': lng,
    };
  }
}

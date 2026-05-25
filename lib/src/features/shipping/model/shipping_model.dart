class ShippingModel {
  final String? id;
  final String addressDetail;
  final double lat;   // ← changed
  final double lng;   // ← changed
  final bool isDefault;
  final String? phoneNumber;
  final String? city;
  final String? streetAddress;
  final int? labelAddress;
  final String? apartmentSuite;
  final String fullName;

  ShippingModel({
    this.id,
    required this.fullName,
    required this.addressDetail,
    required this.lat,
    required this.lng,
    required this.isDefault,
    required this.phoneNumber,
    this.city,
    this.streetAddress,
    this.labelAddress,
    this.apartmentSuite,
  });

  factory ShippingModel.fromJson(Map<String, dynamic> json) {
    return ShippingModel(
      id: json["id"] ?? "",
      fullName: json["full_name"] ?? "",
      addressDetail: json["address_detail"] ?? "",
      lat: (json["latitude"] as num?)?.toDouble() ?? 0.0,   // ← fixed
      lng: (json["longitude"] as num?)?.toDouble() ?? 0.0,  // ← fixed
      isDefault: json["default"] ?? false,
      phoneNumber: json["phone_number"] ?? "",
      city: json["city"] ?? "",
      streetAddress: json["street_address"] ?? "",
      labelAddress: json["label_address"] ?? 0,
      apartmentSuite: json["apartment_suite"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'address_detail': addressDetail,
      'latitude': lat,
      'longitude': lng,
      'default': isDefault,
      'phone_number': phoneNumber,
      'city': city,
      'street_address': streetAddress,
      'label_address': labelAddress,
      'apartment_suite': apartmentSuite,
    };
  }

  ShippingModel copyWith({
    String? id,
    String? fullName,
    String? addressDetail,
    double? lat,   // ← changed
    double? lng,   // ← changed
    bool? isDefault,
    String? phoneNumber,
    String? city,
    String? streetAddress,
    int? labelAddress,
    String? apartmentSuite,
  }) {
    return ShippingModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      addressDetail: addressDetail ?? this.addressDetail,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      isDefault: isDefault ?? this.isDefault,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      city: city ?? this.city,
      streetAddress: streetAddress ?? this.streetAddress,
      labelAddress: labelAddress ?? this.labelAddress,
      apartmentSuite: apartmentSuite ?? this.apartmentSuite,
    );
  }
}
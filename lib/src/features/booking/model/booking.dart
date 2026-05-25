import 'package:petcare_store/src/features/booking/model/package.dart';
import 'package:petcare_store/src/features/booking/model/service.dart';
import 'package:petcare_store/src/features/my_pet/models/pet_model.dart';

class Booking {
  final String id;
  final String serviceId;
  final String? packageId;
  final String petId;
  final String userId;
  final DateTime bookingDate;
  final String status;
  final double? totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined Data
  final Service? service;
  final Package? package;
  final PetModel? pet; // Note: Ensure Pet model is imported correctly

  Booking({
    required this.id,
    required this.serviceId,
    this.packageId,
    required this.petId,
    required this.userId,
    required this.bookingDate,
    required this.status,
    this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    this.service,
    this.package,
    this.pet,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      serviceId: json['service_id'],
      packageId: json['package_id'],
      petId: json['pet_id'],
      userId: json['user_id'],
      bookingDate: DateTime.parse(json['booking_date']),
      status: json['status'],
      totalPrice: json['total_price'] == null
          ? null
          : double.parse(json['total_price'].toString()),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      service: json['services'] != null
          ? Service.fromJson(json['services'])
          : null,
      package: json['packages'] != null
          ? Package.fromJson(json['packages'])
          : null,
      pet: json['mypet'] != null ? PetModel.fromMap(json['mypet']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'package_id': packageId,
      'pet_id': petId,
      'user_id': userId,
      'booking_date': bookingDate.toIso8601String(),
      'status': status,
      'total_price': totalPrice,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Booking.fake() {
    return Booking(
      id: 'fake',
      serviceId: 'fake',
      petId: 'fake',
      userId: 'fake',
      bookingDate: DateTime.now(),
      status: 'pending',
      totalPrice: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

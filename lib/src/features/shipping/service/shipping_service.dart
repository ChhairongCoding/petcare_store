import 'dart:developer' as developer;
import 'package:petcare_store/src/features/shipping/model/shipping_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShippingService {
final ShippingModel shippingModel = ShippingModel(
fullName: "",
addressDetail: "",
lat: 0.0,
lng: 0.0,
isDefault: false,
phoneNumber: '',
city: '',
streetAddress: '',
labelAddress: 0,
apartmentSuite: '',
  );
  final _client = Supabase.instance.client;

  String? getCurrentUserId() {
    return _client.auth.currentSession?.user.id;
  }

  Future<List<ShippingModel>> fetchAddress() async {
    try {
      final userId = getCurrentUserId();
      final response = await _client
          .from("addresses")
          .select()
          .eq('user_id', userId!)
          .order('created_at', ascending: true); // 👈 always same order

      final listAddress = response
          .map((e) => ShippingModel.fromJson(e))
          .toList();
      return listAddress;
    } catch (e) {
      developer.log("Error fetch address $e");
      rethrow;
    }
  }

  Future<void> addAdress({
  required String name,
  required String addressDetail,
  required double lat,
  required double lng,
  required bool isDefault,
  required String phoneNumber,
  String? city,
  String? streetAddress,
  String? apartmentSuite,
  int? labelAddress,
}) async {
  final auth = getCurrentUserId();
  try {
    await _client.from("addresses").insert({
      "user_id": auth,
      "full_name": name,
      "address_detail": addressDetail,
      "latitude": lat.toString(),
      "longitude": lng.toString(),
      "default": isDefault,
      "phone_number": phoneNumber,
      "city": city,
      "street_address": streetAddress,
      "apartment_suite": apartmentSuite,
      "label_address": labelAddress,
    });
  } catch (e) {
    developer.log("$e");
    rethrow;
  }
}

  Future<void> removeAddress(String id) async {
    final auth = getCurrentUserId();
    try {
      await _client
          .from("addresses")
          .delete()
          .eq('id', id)
          .eq("user_id", auth.toString());
    } catch (e) {
      developer.log("$e");
    }
  }

  Future<void> setDefault(String id) async {
    final auth = getCurrentUserId();
    if (auth == null) return;

    try {
      // Step 1: Set all addresses to false
      await _client
          .from("addresses")
          .update({'default': false})
          .eq('user_id', auth);

      // Step 2: Set selected address to true
      await _client
          .from("addresses")
          .update({'default': true})
          .eq('id', id)
          .eq('user_id', auth);

      developer.log("Default address updated successfully");
    } catch (e) {
      developer.log("Error setting default: $e");
      rethrow;
    }
  }
}

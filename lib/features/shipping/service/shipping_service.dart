import 'dart:developer' as developer;
import 'package:petcare_store/features/shipping/model/shipping_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShippingService {
  final ShippingModel shippingModel = ShippingModel(
    name: "",
    addressDetail: "",
    lat: '',
    lng: '',
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
          .eq('user_id', userId!);
      developer.log("Fetch address successfully");
      final listAddress = 
         response.map((e) => ShippingModel.fromJson(e))
          .toList();
      return listAddress;
    } on PostgrestException catch (e) {
      developer.log("Supabase error: ${e.message} | code: ${e.code}");
      rethrow;
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
  }) async {
    final auth = getCurrentUserId();
    try {
      await _client.from("addresses").insert({
        "user_id": auth,
        "name": name,
        "address_detail": addressDetail,
        "latitude": lat,
        "longitude": lng,
      });
    } catch (e) {
      developer.log("$e");
      rethrow; // let controller handle UI
    } 
  }
}

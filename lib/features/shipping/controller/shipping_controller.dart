import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class ShippingController extends GetxController {
  RxString addressText = "".obs;
  RxBool isGeocoding = false.obs;

  TextEditingController addressDetail = TextEditingController();

  Future<void> reverseGeocode(LatLng location) async {
    isGeocoding(true);

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        final address = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        addressText.value = address;

        addressDetail.text = address;
      }
    } catch (e) {
      print("Geocode error: $e");
      addressText.value = "Could not get address";
    } finally {
      isGeocoding(false);
    }
  }

  @override
  void onClose() {
    addressDetail.dispose();
    super.onClose();
  }
}

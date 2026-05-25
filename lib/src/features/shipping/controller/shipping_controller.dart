import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:petcare_store/src/features/shipping/model/shipping_model.dart';
import 'package:petcare_store/src/features/shipping/service/shipping_service.dart';

class ShippingController extends GetxController {
  RxString addressText = "".obs;
  RxBool isLoading = false.obs;
  RxBool isGeocoding = false.obs;

  RxList<ShippingModel> addressLists = <ShippingModel>[].obs;

  final ShippingService _shippingService = ShippingService();

  TextEditingController addressDetail = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getAddress();
  }

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
      addressText.value = "Could not get address";
    } finally {
      isGeocoding(false);
    }
  }

  Future<void> getAddress() async {
    try {
      isLoading(true);
      final list = await _shippingService.fetchAddress();
      addressLists.clear();
      await Future.delayed(
        Duration(milliseconds: 50),
      ); // 👈 force Obx to see the clear
      addressLists.addAll(list);
    } catch (e) {
      developer.log("$e");
    } finally {
      isLoading(false);
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
    try {
      isLoading(true);
      await _shippingService.addAdress(
        name: name,
        addressDetail: addressDetail,
        lat: lat,
        lng: lng,
        isDefault: isDefault,
        phoneNumber: phoneNumber,
        city: city,
        streetAddress: streetAddress,
        apartmentSuite: apartmentSuite,
        labelAddress: labelAddress,
      );
      await getAddress();


      await Future.delayed(const Duration(milliseconds: 300));
      Navigator.of(Get.context!).pop();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong!",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> removeAddress(int index) async {
    isLoading(true);
    String? id = addressLists[index].id;
    if (id == null) return;
    _shippingService.removeAddress(id);
    await getAddress();
    isLoading(false);
  }

  bool checkAddressDefault() {
    return addressLists.any((e) => e.isDefault == true);
  }

  ShippingModel? get defaultAddress =>
      addressLists.firstWhereOrNull((e) => e.isDefault == true);

  Future<void> setDefault(String id) async {
    try {
      await _shippingService.setDefault(id);
      await getAddress();
    } catch (e) {
      developer.log("$e");
    }
  }

  @override
  void onClose() {
    addressDetail.dispose();
    super.onClose();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/features/booking/model/package.dart';
import 'package:petcare_store/src/features/booking/model/service.dart';
import 'package:petcare_store/src/features/my_pet/controller/my_pet_controller.dart';
import 'package:petcare_store/src/features/booking/controller/my_bookings_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingController extends GetxController {
  final supabase = Supabase.instance.client;
  final MyPetController _petController = Get.find<MyPetController>();

  final RxList<Service> services = <Service>[].obs;
  final RxList<Package> packages = <Package>[].obs;

  final RxString selectedServiceId = ''.obs;
  final RxString selectedPackageId = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxString selectedTime = ''.obs;
  final RxString selectedPetId = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isServicesLoading = false.obs;
  final RxBool isPackagesLoading = false.obs;

  final RxDouble totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
    fetchPackages();
    if (_petController.pets.isEmpty) {
      _petController.fetchPets();
    }

    // Auto-calculate whenever selection changes
    everAll([
      selectedServiceId,
      selectedPackageId,
      services,
      packages,
    ], (_) => calculateTotalPrice());
  }

  void calculateTotalPrice() {
    final service = services.firstWhereOrNull(
      (s) => s.id == selectedServiceId.value,
    );
    final package = packages.firstWhereOrNull(
      (p) => p.id == selectedPackageId.value,
    );

    double total = 0.0;
    if (service != null) total += service.price;
    if (package != null && package.price != null) total += package.price!;

    totalPrice.value = total;
    print(
      '➔ Price Update: Service(${service?.price}) + Package(${package?.price}) = ${totalPrice.value}',
    );
  }

  Future<void> fetchServices() async {
    try {
      isServicesLoading(true);
      final response = await supabase.from('services').select();

      final List<Service> loadedServices = (response as List)
          .map((data) => Service.fromJson(data))
          .toList();
      services.assignAll(loadedServices);
      if (services.isNotEmpty && selectedServiceId.value.isEmpty) {
        selectedServiceId.value = services.first.id;
      }
      calculateTotalPrice();
    } catch (e) {
    } finally {
      isServicesLoading(false);
    }
  }

  Future<void> fetchPackages() async {
    try {
      isPackagesLoading(true);
      final response = await supabase.from('packages').select();

      final List<Package> loadedPackages = (response as List)
          .map((data) => Package.fromJson(data))
          .toList();

      // Sort by price: lowest to highest (upper price is put in last)
      loadedPackages.sort((a, b) => (a.price ?? 0.0).compareTo(b.price ?? 0.0));

      packages.assignAll(loadedPackages);
      if (packages.isNotEmpty && selectedPackageId.value.isEmpty) {
        selectedPackageId.value = packages.first.id;
      }
      calculateTotalPrice();
    } catch (e) {
    } finally {
      isPackagesLoading(false);
    }
  }

  // Computed total price (kept for backward compatibility with UI calls)
  double get currentTotalPrice => totalPrice.value;

  void selectService(String serviceId) => selectedServiceId.value = serviceId;
  void selectPackage(String packageId) => selectedPackageId.value = packageId;
  void selectDate(DateTime date) => selectedDate.value = date;
  void selectTime(String time) => selectedTime.value = time;
  void selectPet(String petId) => selectedPetId.value = petId;

  final List<String> availableTimes = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];

  Future<void> confirmBooking() async {
    if (selectedServiceId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a service.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    if (selectedPackageId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a package.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    if (selectedDate.value == null || selectedTime.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a date and time.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    if (selectedPetId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a pet.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);

      // Combine Date and Time
      DateTime bookingDateTime = selectedDate.value!;
      if (selectedTime.value.isNotEmpty) {
        try {
          // Parse time like '09:00 AM'
          final timeParts = selectedTime.value.split(' ');
          final hm = timeParts[0].split(':');
          int hour = int.parse(hm[0]);
          int minute = int.parse(hm[1]);
          final ampm = timeParts[1];

          if (ampm == 'PM' && hour < 12) hour += 12;
          if (ampm == 'AM' && hour == 12) hour = 0;

          bookingDateTime = DateTime(
            bookingDateTime.year,
            bookingDateTime.month,
            bookingDateTime.day,
            hour,
            minute,
          );
        } catch (e) {
          print('Error parsing time: $e');
        }
      }

      await supabase.from('bookings').insert({
        'user_id': supabase.auth.currentUser?.id,
        'service_id': selectedServiceId.value,
        'package_id': selectedPackageId.value,
        'pet_id': selectedPetId.value,
        'booking_date': bookingDateTime.toIso8601String(),
        'status': 'pending',
        'total_price': totalPrice.value,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      if (Get.isRegistered<MyBookingsController>()) {
        Get.find<MyBookingsController>().fetchUserBookings();
      }

      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 80,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Booking Confirmed!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your appointment has been booked successfully. You can track it in My Bookings.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offNamedUntil(
                        '/myBookings',
                        (route) => route.isFirst,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Great!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      print(' BOOKING FAILED: $e');
      Get.snackbar(
        'Error',
        'Could not complete booking. Please check your data.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}

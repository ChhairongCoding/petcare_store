import 'package:get/get.dart';
import 'package:petcare_store/src/features/booking/model/booking.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyBookingsController extends GetxController {
  final supabase = Supabase.instance.client;
  final RxList<Booking> bookings = <Booking>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserBookings();
  }

  Future<void> fetchUserBookings() async {
    try {
      isLoading(true);
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Fetch bookings with joined services, packages, and pets
      // Using explicit relationship names to resolve ambiguity
      final response = await supabase
          .from('bookings')
          .select('*, services(*), packages!bookings_package_id_fkey(*), mypet(*)')
          .eq('user_id', userId)
          .order('booking_date', ascending: false);

      final List<Booking> loadedBookings = (response as List).map((data) => Booking.fromJson(data)).toList();
      bookings.assignAll(loadedBookings);
    } catch (e) {
      print('Error fetching bookings: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await supabase
          .from('bookings')
          .update({'status': 'cancelled'})
          .eq('id', bookingId);
      
      // Update local state
      final index = bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        final oldBooking = bookings[index];
        bookings[index] = Booking(
          id: oldBooking.id,
          serviceId: oldBooking.serviceId,
          packageId: oldBooking.packageId,
          petId: oldBooking.petId,
          userId: oldBooking.userId,
          bookingDate: oldBooking.bookingDate,
          status: 'cancelled',
          totalPrice: oldBooking.totalPrice,
          createdAt: oldBooking.createdAt,
          updatedAt: DateTime.now(),
          service: oldBooking.service,
          package: oldBooking.package,
          pet: oldBooking.pet,
        );
      }
    } catch (e) {
      print('Error cancelling booking: $e');
    }
  }
}

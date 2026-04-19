import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:petcare_store/src/features/my_order/models/order.dart';

class MyOrderController extends GetxController {
  final _supabase = Supabase.instance.client;

  final RxList<Order> orders = <Order>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await _supabase
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final List<Order> loadedOrders = (response as List)
          .map((data) => Order.fromJson(data))
          .toList();

      orders.assignAll(loadedOrders);
    } catch (e) {
      print('Error fetching orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<Order> get pendingOrders =>
      orders.where((o) => o.status.toLowerCase() == 'pending').toList();

  List<Order> get confirmedOrders => orders
      .where(
        (o) =>
            o.status.toLowerCase() == 'processing' ||
            o.status.toLowerCase() == 'shipped',
      )
      .toList();

  List<Order> get completedOrders =>
      orders.where((o) => o.status.toLowerCase() == 'delivered').toList();

  List<Order> get cancelledOrders =>
      orders.where((o) => o.status.toLowerCase() == 'cancelled').toList();
}

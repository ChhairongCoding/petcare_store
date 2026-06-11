import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petcare_store/src/features/notification/models/notification_model.dart';
import 'dart:developer' as dev;

class NotificationPageController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxString activeFilter = 'all'.obs;

  static const String _storageKey = 'in_app_notifications_list';

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  // Load notifications from SharedPreferences
  Future<void> loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> decodedList = json.decode(jsonStr);
        final List<NotificationModel> loadedList = decodedList
            .map(
              (item) =>
                  NotificationModel.fromMap(Map<String, dynamic>.from(item)),
            )
            .toList();
        // Sort by timestamp descending
        loadedList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        notifications.assignAll(loadedList);
      } else {
        // Load some mockup notifications on first launch
        _loadMockNotifications();
      }
    } catch (e) {
      dev.log(
        "🔔 [NotificationPageController] Error loading notifications: $e",
      );
    }
  }

  // Save notifications to SharedPreferences
  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> mapList = notifications
          .map((item) => item.toMap())
          .toList();
      await prefs.setString(_storageKey, json.encode(mapList));
    } catch (e) {
      dev.log("🔔 [NotificationPageController] Error saving notifications: $e");
    }
  }

  void _loadMockNotifications() {
    final now = DateTime.now();
    final mockList = [
      NotificationModel(
        id: 'mock_welcome',
        title: 'Welcome to PetCare Store! 🐾',
        body:
            'Find high-quality products and book premium grooming services for your pets.',
        timestamp: now.subtract(const Duration(hours: 2)),
        type: 'general',
        isRead: false,
      ),
      NotificationModel(
        id: 'mock_promo',
        title: 'Special Promo: 20% Off! 🏷️',
        body:
            'Get 20% off on all grooming products this week. Use code PETLOVER20 at checkout.',
        timestamp: now.subtract(const Duration(days: 1)),
        type: 'promo',
        isRead: false,
      ),
      NotificationModel(
        id: 'mock_reminder',
        title: 'Vaccination Reminder 💉',
        body:
            'Keep your pets healthy. Schedule their yearly vaccinations today through our booking tab.',
        timestamp: now.subtract(const Duration(days: 2)),
        type: 'reminder',
        isRead: true,
      ),
    ];
    notifications.assignAll(mockList);
    _saveNotifications();
  }

  // Add a new notification
  Future<void> addNotification({
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? payload,
  }) async {
    final newNotif = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
      type: type,
      isRead: false,
      payload: payload,
    );
    notifications.insert(0, newNotif); // Add to the top
    await _saveNotifications();
  }

  // Mark a single notification as read
  Future<void> markAsRead(String id) async {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index].isRead = true;
      notifications.refresh(); // Notify RxList updates
      await _saveNotifications();
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    bool updated = false;
    for (var n in notifications) {
      if (!n.isRead) {
        n.isRead = true;
        updated = true;
      }
    }
    if (updated) {
      notifications.refresh();
      await _saveNotifications();
    }
  }

  // Delete a single notification
  Future<void> deleteNotification(String id) async {
    notifications.removeWhere((n) => n.id == id);
    await _saveNotifications();
  }

  // Clear all notifications
  Future<void> clearAll() async {
    notifications.clear();
    await _saveNotifications();
  }

  // Reactive unread count
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  // Filtered notifications list
  List<NotificationModel> get filteredNotifications {
    if (activeFilter.value == 'all') {
      return notifications;
    }
    return notifications.where((n) => n.type == activeFilter.value).toList();
  }

  // Helper count for tabs
  int countByType(String type) {
    if (type == 'all') return notifications.length;
    return notifications.where((n) => n.type == type).length;
  }
}

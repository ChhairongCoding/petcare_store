import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:petcare_store/src/notification/notification_service.dart';

class NotificationController {
  Future<void> showNotification({String? title, String? body}) async {
    try {
      print("🔔 [NotificationController] showNotification called (Title: $title, Body: $body)");
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'channel_id',
            "General Notifications",
            importance: Importance.max,
            priority: Priority.high,
          );

      const DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

      const NotificationDetails details = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      );

      await NotificationService.notifications.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // Using unique ID to avoid collision
        title: title ?? "Notification",
        body: body ?? "This is notification",
        notificationDetails: details,
      );
      print("🔔 [NotificationController] Notification successfully dispatched to OS!");
    } catch (e, stack) {
      print("🔔 [NotificationController] ERROR showing notification: $e\n$stack");
    }
  }
}

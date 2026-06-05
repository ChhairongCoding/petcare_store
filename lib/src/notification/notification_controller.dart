import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/notification/notification_service.dart';
import 'package:petcare_store/src/features/notification/controller/notification_page_controller.dart';

class NotificationController {
  Future<void> showNotification({String? title, String? body}) async {
    try {
      // Save notification to local in-app history if controller is registered
      if (Get.isRegistered<NotificationPageController>()) {
        final notifController = Get.find<NotificationPageController>();
        String type = 'general';
        final lowerTitle = (title ?? "").toLowerCase();
        final lowerBody = (body ?? "").toLowerCase();
        if (lowerTitle.contains('payment') ||
            lowerTitle.contains('order') ||
            lowerBody.contains('order') ||
            lowerBody.contains('payment') ||
            lowerBody.contains('processed')) {
          type = 'order';
        } else if (lowerTitle.contains('reminder') ||
            lowerTitle.contains('vaccination') ||
            lowerBody.contains('appointment') ||
            lowerBody.contains('booking')) {
          type = 'reminder';
        } else if (lowerTitle.contains('promo') ||
            lowerTitle.contains('sale') ||
            lowerBody.contains('discount')) {
          type = 'promo';
        }

        await notifController.addNotification(
          title: title ?? "Notification",
          body: body ?? "",
          type: type,
        );
      }

      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'channel_id',
            "General Notifications",
            importance: Importance.max,
            priority: Priority.high,
            largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
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
        id:
            DateTime.now().millisecondsSinceEpoch ~/
            1000, // Using unique ID to avoid collision
        title: title ?? "Notification",
        body: body ?? "This is notification",
        notificationDetails: details,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

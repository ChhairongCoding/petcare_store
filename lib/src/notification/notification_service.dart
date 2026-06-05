import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    try {
      print("🔔 [NotificationService] Initializing notifications...");
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      bool? initialized = await notifications.initialize(settings: settings);
      print(
        "🔔 [NotificationService] Plugin initialization result: $initialized",
      );

      // Explicitly request permissions on iOS
      print("🔔 [NotificationService] Requesting iOS permissions...");
      bool? granted = await notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      print("🔔 [NotificationService] iOS permission request result: $granted");
    } catch (e, stack) {
      print("🔔 [NotificationService] Initialization error: $e\n$stack");
    }
  }
}

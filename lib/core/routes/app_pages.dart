import 'package:get/get.dart';
import 'package:petcare_store/core/routes/app_routes.dart';
import 'package:petcare_store/views/main_views/main_screen.dart';
import 'package:petcare_store/views/notification_views/notification_screen.dart';
import 'package:petcare_store/views/profile_views/profile_screen.dart';
import 'package:petcare_store/views/reminder_views/reminder_screen.dart';
import 'package:petcare_store/views/service_views/controller/service_screen.dart';
import 'package:petcare_store/views/shop_views/shop_screen.dart';

List<GetPage<dynamic>> appPages = [
  GetPage(name: AppRoutes.mainScreen, page: () => MainScreen()),
  GetPage(name: AppRoutes.homeScreen, page: () => MainScreen()),
  GetPage(name: AppRoutes.service, page: () => ServiceScreen()),
  GetPage(name: AppRoutes.shopScreen, page: () => ShopScreen()),
  GetPage(name: AppRoutes.reminderScreen, page: () => ReminderScreen()),
  GetPage(name: AppRoutes.profileScreen, page: () => ProfileScreen()),
  GetPage(name: AppRoutes.notificationScreen, page: () => NotificationScreen()),
];

import 'package:get/get.dart';
import 'package:petcare_store/core/routes/app_routes.dart';
import 'package:petcare_store/feature/main/views/main_screen.dart';
import 'package:petcare_store/feature/notification/views/notification_screen.dart';
import 'package:petcare_store/feature/profile/views/profile_screen.dart';
import 'package:petcare_store/feature/reminder_views/shop/views/reminder_screen.dart';
import 'package:petcare_store/feature/service/views/service_screen.dart';
import 'package:petcare_store/feature/shop/shop_screen.dart';

List<GetPage<dynamic>> appPages = [
  GetPage(name: AppRoutes.mainScreen, page: () => MainScreen()),
  GetPage(name: AppRoutes.homeScreen, page: () => MainScreen()),
  GetPage(name: AppRoutes.service, page: () => ServiceScreen()),
  GetPage(name: AppRoutes.shopScreen, page: () => ShopScreen()),
  GetPage(name: AppRoutes.reminderScreen, page: () => ReminderScreen()),
  GetPage(name: AppRoutes.profileScreen, page: () => ProfileScreen()),
  GetPage(name: AppRoutes.notificationScreen, page: () => NotificationScreen()),
];

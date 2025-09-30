import 'package:get/get.dart';
import 'package:petcare_store/config/core/routes/app_routes.dart';
import 'package:petcare_store/features/main/views/main_screen.dart';
import 'package:petcare_store/features/my_pet/views/my_pet_screen.dart';
import 'package:petcare_store/features/notification/views/notification_screen.dart';
import 'package:petcare_store/features/profile/views/profile_screen.dart';
import 'package:petcare_store/features/reminder_views/shop/views/reminder_screen.dart';
import 'package:petcare_store/features/shop/shop_screen.dart';

List<GetPage<dynamic>> appPages = [
  GetPage(name: AppRoutes.mainScreen, page: () => MainScreen()),
  GetPage(name: AppRoutes.homeScreen, page: () => MainScreen()),
  GetPage(name: AppRoutes.mypet, page: () => MyPet()),
  GetPage(name: AppRoutes.shopScreen, page: () => ShopScreen()),
  GetPage(name: AppRoutes.reminderScreen, page: () => ReminderScreen()),
  GetPage(name: AppRoutes.profileScreen, page: () => ProfileScreen()),
  GetPage(name: AppRoutes.notificationScreen, page: () => NotificationScreen()),
];

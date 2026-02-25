import 'package:get/get.dart';
import 'package:petcare_store/config/core/routes/app_routes.dart';
import 'package:petcare_store/features/auth/views/login_screen.dart';
import 'package:petcare_store/features/auth/views/signup_screen.dart';
import 'package:petcare_store/features/cart/view/cart_screen.dart';
import 'package:petcare_store/features/cart/view/checkout_screen.dart';
import 'package:petcare_store/features/main/splash_screen.dart';
import 'package:petcare_store/features/main/views/main_screen.dart';
import 'package:petcare_store/features/my_orders/my_orders_screen.dart';
import 'package:petcare_store/features/my_pet/views/my_pet_screen.dart';
import 'package:petcare_store/features/my_pet/views/widgets/tracking_my_pet.dart';
import 'package:petcare_store/features/notification/views/notification_screen.dart';
import 'package:petcare_store/features/profile/views/profile_screen.dart';
import 'package:petcare_store/features/reminder_views/view/views/reminder_screen.dart';
import 'package:petcare_store/features/setting/view/setting_screen.dart';
import 'package:petcare_store/features/shop/shop_screen.dart';

List<GetPage<dynamic>> appPages = [
  GetPage(name: AppRoutes.splashScreen, page: () => const SplashScreen()),

  GetPage(name: AppRoutes.login, page: ()=>  LoginScreen()),
  GetPage(name: AppRoutes.signup, page: ()=> const SignupScreen()),

  GetPage(name: AppRoutes.mainScreen, page: () => MainScreen()),
  GetPage(name: AppRoutes.homeScreen, page: () => MainScreen()),
  GetPage(name: AppRoutes.mypet, page: () => MyPet()),
  GetPage(name: AppRoutes.shopScreen, page: () => ShopScreen()),
  GetPage(name: AppRoutes.reminderScreen, page: () => ReminderScreen()),
  GetPage(name: AppRoutes.profileScreen, page: () => ProfileScreen()),
  GetPage(name: AppRoutes.notificationScreen, page: () => NotificationScreen()),
  GetPage(name: AppRoutes.myorders, page: () => MyOrdersScreen()),
  GetPage(name: AppRoutes.settings, page: () => SettingScreen()),
  GetPage(name: AppRoutes.cart, page: () => CartScreen()),
  GetPage(name: AppRoutes.trackingPet, page: () => TrackingMyPet()),
  GetPage(name: AppRoutes.processBuy, page: () => ProcessBuyScreen()),
];

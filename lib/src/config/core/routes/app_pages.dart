import 'package:get/get.dart';
import 'package:petcare_store/src/config/core/routes/app_routes.dart';
import 'package:petcare_store/src/features/auth/views/login_screen.dart';
import 'package:petcare_store/src/features/auth/views/signup_screen.dart';
import 'package:petcare_store/src/features/cart/view/cart_screen.dart';
import 'package:petcare_store/src/features/checkout/view/aba_pay_screen.dart';
import 'package:petcare_store/src/features/checkout/view/checkout_screen.dart';
import 'package:petcare_store/src/features/checkout/view/khqr_payment_screen.dart';
import 'package:petcare_store/src/features/checkout/view/success_payment_screen.dart';
import 'package:petcare_store/src/features/main/splash_screen.dart';
import 'package:petcare_store/src/features/main/views/main_screen.dart';
import 'package:petcare_store/src/features/my_orders/my_orders_screen.dart';
import 'package:petcare_store/src/features/my_pet/views/my_pet_screen.dart';
import 'package:petcare_store/src/features/my_pet/views/widgets/tracking_my_pet.dart';
import 'package:petcare_store/src/features/notification/views/notification_screen.dart';
import 'package:petcare_store/src/features/profile/views/profile_screen.dart';
import 'package:petcare_store/src/features/reminder_views/view/views/reminder_screen.dart';
import 'package:petcare_store/src/features/setting/view/setting_screen.dart';
import 'package:petcare_store/src/features/shipping/view/address_form_screen.dart';
import 'package:petcare_store/src/features/shipping/view/shipping_screen.dart';
import 'package:petcare_store/src/features/shop/shop_screen.dart';

List<GetPage<dynamic>> appPages = [
  GetPage(name: AppRoutes.splashScreen, page: () => const SplashScreen()),

  GetPage(name: AppRoutes.login, page: () => LoginScreen()),
  GetPage(name: AppRoutes.signup, page: () => const SignupScreen()),

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
  GetPage(name: AppRoutes.shipping, page: () => ShippingScreen()),
  GetPage(name: AppRoutes.addressForm, page: () => AddressFormScreen()),
  GetPage(
    name: AppRoutes.successPayment,
    page: () => const SuccessPaymentScreen(),
  ),
  GetPage(name: AppRoutes.khqrPayment, page: () => const KhqrPaymentScreen()),
  GetPage(name: AppRoutes.abaPayment, page: () => const AbaPayScreen()),
];

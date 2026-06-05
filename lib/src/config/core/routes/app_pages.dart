import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/config/core/routes/app_routes.dart';
import 'package:petcare_store/src/config/core/routes/auth_middleware.dart';
import 'package:petcare_store/src/features/auth/views/login_screen.dart';
import 'package:petcare_store/src/features/auth/views/signup_screen.dart';
import 'package:petcare_store/src/features/booking/view/booking_screen.dart';
import 'package:petcare_store/src/features/booking/view/my_bookings_screen.dart';
import 'package:petcare_store/src/features/cart/view/cart_screen.dart';
import 'package:petcare_store/src/features/checkout/view/aba_pay_screen.dart';
import 'package:petcare_store/src/features/checkout/view/checkout_screen.dart';
import 'package:petcare_store/src/features/checkout/view/khqr_payment_screen.dart';
import 'package:petcare_store/src/features/checkout/view/success_payment_screen.dart';
import 'package:petcare_store/src/features/main/splash_screen.dart';
import 'package:petcare_store/src/features/main/views/main_screen.dart';
import 'package:petcare_store/src/features/my_order/view/my_orders_screen.dart';
import 'package:petcare_store/src/features/my_order/view/order_detail_screen.dart';
import 'package:petcare_store/src/features/my_pet/views/my_pet_screen.dart';
import 'package:petcare_store/src/features/my_pet/views/widgets/tracking_my_pet.dart';
import 'package:petcare_store/src/features/notification/views/notification_screen.dart';
import 'package:petcare_store/src/features/products/views/product_detail_page.dart';
import 'package:petcare_store/src/features/products/views/wishlist_page.dart';
import 'package:petcare_store/src/features/profile/views/profile_screen.dart';
import 'package:petcare_store/src/features/setting/view/update_profile_screen.dart';
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
  GetPage(
    name: AppRoutes.mypet,
    page: () => MyPet(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(name: AppRoutes.shopScreen, page: () => ShopScreen()),
  GetPage(
    name: AppRoutes.reminderScreen,
    page: () => ReminderScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.profileScreen,
    page: () => ProfileScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.notificationScreen,
    page: () => NotificationScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.myorders,
    page: () => MyOrdersScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.settings,
    page: () => SettingScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.cart,
    page: () => CartScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.trackingPet,
    page: () => TrackingMyPet(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.processBuy,
    page: () => ProcessBuyScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.shipping,
    page: () => ShippingScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.addressForm,
    page: () => AddressFormScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.successPayment,
    page: () => const SuccessPaymentScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.khqrPayment,
    page: () => const KhqrPaymentScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.abaPayment,
    page: () => const AbaPayScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.booking,
    page: () => BookingScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.myBookings,
    page: () => MyBookingsScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.orderDetail,
    page: () => const OrderDetailScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.productDetail,
    page: () => ProductDetailPage(key: UniqueKey()),
  ),
  GetPage(
    name: AppRoutes.updateProfile,
    page: () => const UpdateProfileScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.wishlist,
    page: () => const WishlistPage(),
    middlewares: [AuthMiddleware()],
  ),
];

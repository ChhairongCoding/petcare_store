import 'package:get/get.dart';
import 'package:petcare_store/src/features/auth/controller/auth_controller.dart';
import 'package:petcare_store/src/features/cart/controller/cart_controller.dart';
import 'package:petcare_store/src/features/category/controller/category_controller.dart';
import 'package:petcare_store/src/features/checkout/controller/payment_controller.dart';
import 'package:petcare_store/src/features/home/controller/home_controller.dart';
import 'package:petcare_store/src/features/main/controller/main_controller.dart';
import 'package:petcare_store/src/features/products/controllers/product_controller.dart';
import 'package:petcare_store/src/features/profile/controller/profile_controller.dart';
import 'package:petcare_store/src/features/my_pet/controller/my_pet_controller.dart';
import 'package:petcare_store/src/features/reminder_views/controller/reminder_controller.dart';
import 'package:petcare_store/src/features/shipping/controller/shipping_controller.dart';
import 'package:petcare_store/src/services/auth_service.dart';
import 'package:petcare_store/src/services/local_service.dart';
import 'package:petcare_store/src/util/provider_local.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    //services
    Get.put(AuthService());
    Get.put(LocalService());

    //controller
    Get.put(MainController());
    Get.put(HomeController());
    Get.put(CategoryController());
    Get.put(ReminderController());
    Get.put(AuthController());
    Get.put(ProductController());
    Get.put(MyPetController());
    Get.put(ProfileController());
    Get.put(CartController());
    Get.put(ShippingController());
    Get.put(PaymentController());

    //provider
    Get.put(ProviderLocal());
  }
}

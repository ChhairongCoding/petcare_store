import 'package:get/get.dart';
import 'package:petcare_store/features/auth/controller/auth_controller.dart';
import 'package:petcare_store/features/cart/controller/cart_controller.dart';
import 'package:petcare_store/features/category/controller/category_controller.dart';
import 'package:petcare_store/features/home/controller/home_controller.dart';
import 'package:petcare_store/features/main/controller/main_controller.dart';
import 'package:petcare_store/features/products/controllers/product_controller.dart';
import 'package:petcare_store/features/profile/controller/profile_controller.dart';
import 'package:petcare_store/features/reminder_views/controller/reminder_controller.dart';
import 'package:petcare_store/services/auth_service.dart';
import 'package:petcare_store/services/local_service.dart';
import 'package:petcare_store/util/provider_local.dart';

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
    Get.put(ProfileController());
    Get.put(CartController());

    //provider
    Get.put(ProviderLocal());
  }
}

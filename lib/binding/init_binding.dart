import 'package:get/get.dart';
import 'package:petcare_store/views/category_views/controller/category_controller.dart';
import 'package:petcare_store/views/home_views/controller/home_controller.dart';
import 'package:petcare_store/views/main_views/controller/main_controller.dart';

class InitBinding  extends Bindings{

  @override
  void dependencies() {
    Get.put(MainController());
    Get.put(HomeController());
    Get.put(CategoryController());
  }
}
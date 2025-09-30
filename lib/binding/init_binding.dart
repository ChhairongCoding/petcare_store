import 'package:get/get.dart';
import 'package:petcare_store/features/category/controller/category_controller.dart';
import 'package:petcare_store/features/home/controller/home_controller.dart';
import 'package:petcare_store/features/main/controller/main_controller.dart';
import 'package:petcare_store/features/reminder_views/controller/reminder_controller.dart';

class InitBinding  extends Bindings{

  @override
  void dependencies() {
    Get.put(MainController());
    Get.put(HomeController());
    Get.put(CategoryController());
    Get.put(ReminderController());
  }
}
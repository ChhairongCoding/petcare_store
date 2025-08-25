import 'package:get/get.dart';
import 'package:petcare_store/core/routes/app_routes.dart';
import 'package:petcare_store/views/main_views/main_screen.dart';

List<GetPage<dynamic>> appPages = [
  GetPage(name: AppRoutes.mainScreen, page: () => MainScreen()),
  GetPage(name: AppRoutes.homeScreen, page: () => MainScreen()),
];

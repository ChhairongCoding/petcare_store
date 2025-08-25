import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/binding/init_binding.dart';
import 'package:petcare_store/core/routes/app_pages.dart';
import 'package:petcare_store/core/routes/app_routes.dart';
import 'package:petcare_store/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      
      color: Color(0xffF5F5F7),
      title: 'PetCare Store',
      theme: AppTheme.lightTheme,
      initialBinding: InitBinding(),
      initialRoute: AppRoutes.mainScreen,
      getPages: appPages,
    );
  }
}

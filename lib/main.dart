import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/binding/init_binding.dart';
import 'package:petcare_store/core/routes/app_pages.dart';
import 'package:petcare_store/core/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PetCats Store',
      initialBinding: InitBinding(),
      initialRoute: AppRoutes.mainScreen,
      getPages: appPages,
    );
  }
}

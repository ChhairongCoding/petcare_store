import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/views/home_views/home_screen.dart';
import 'package:petcare_store/views/service_views/controller/service_screen.dart';

class MainController extends GetxController {
  var currentIndex = 0.obs;

  final List<Map<String, dynamic>> bottomItems = [
    {"icon": Icons.home, "label": "Home"},
    {"icon": Icons.hearing_outlined, "label": "Service"},
  ];

  final List<Widget> pages = [HomeScreen(), ServiceScreen()];
}

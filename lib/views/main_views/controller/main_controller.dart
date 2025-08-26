import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/views/home_views/home_screen.dart';
import 'package:petcare_store/views/profile_views/profile_screen.dart';
import 'package:petcare_store/views/reminder_views/reminder_screen.dart';
import 'package:petcare_store/views/service_views/controller/service_screen.dart';
import 'package:petcare_store/views/shop_views/shop_screen.dart';

class MainController extends GetxController {
  var currentIndex = 0.obs;

  final List<Map<String, dynamic>> bottomItems = [
    {"icon": HugeIcons.strokeRoundedHome01, "label": "Home"},
    {"icon": HugeIcons.strokeRoundedFavourite, "label": "Service"},
    {"icon": HugeIcons.strokeRoundedShoppingBag01, "label": "Shop"},
    {"icon": HugeIcons.strokeRoundedReminder, "label": "Reminder"},
    {"icon": HugeIcons.strokeRoundedUser, "label": "Profile"},
  ];

  final List<Widget> pages = [HomeScreen(), ServiceScreen(),ShopScreen(),ReminderScreen(),ProfileScreen()];
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/feature/home/view/home_screen.dart';
import 'package:petcare_store/feature/profile/views/profile_screen.dart';
import 'package:petcare_store/feature/reminder_views/shop/views/reminder_screen.dart';
import 'package:petcare_store/feature/service/views/service_screen.dart';
import 'package:petcare_store/feature/shop/shop_screen.dart';

class MainController extends GetxController {
  var currentIndex = 0.obs;

  final List<Map<String, dynamic>> bottomItems = [
    {"icon": HugeIcons.strokeRoundedHome01, "label": "Home"},
    {"icon": HugeIcons.strokeRoundedReminder, "label": "Reminder"},
    {"icon": HugeIcons.strokeRoundedShoppingBag01, "label": "Shop"},
    {"icon": HugeIcons.strokeRoundedFolderDetails, "label": "Pet Details"},
    {"icon": HugeIcons.strokeRoundedUser, "label": "Profile"},
  ];

  final List<Widget> pages = [HomeScreen(), ReminderScreen(),ShopScreen(),ServiceScreen(),ProfileScreen()];

  void changePage(int index) => currentIndex.value = index;
}

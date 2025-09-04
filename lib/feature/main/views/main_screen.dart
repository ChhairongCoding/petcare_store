import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:petcare_store/feature/main/controller/main_controller.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final MainController mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBody: true,
        body: _buidBody(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buidBody() {
    return mainController.pages[mainController.currentIndex.value];
  }

  Widget _buildBottomNavigationBar() {
    final bottomItem = mainController.bottomItems;

    return Container(
      margin: const EdgeInsets.all(16), // floating effect
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: GNav(
        gap: 8,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        backgroundColor: Colors.transparent, // transparent to show container bg
        color: Colors.grey[600],
        activeColor: Colors.white,
        tabBackgroundColor: const Color(0xff378B6F),
        tabs: List.generate(
          bottomItem.length,
          (index) => GButton(
            icon: bottomItem[index]['icon'],
            text: bottomItem[index]['label'],
          ),
        ),
        selectedIndex: mainController.currentIndex.value,
        onTabChange: (index) => mainController.changePage(index),
      ),
    );
  }
}

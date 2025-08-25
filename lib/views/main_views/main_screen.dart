import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:petcare_store/views/main_views/controller/main_controller.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final MainController mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _buidBody(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buidBody() {
    return mainController.pages[mainController.currentIndex.value];
  }

  GNav _buildBottomNavigationBar() {
    final bottomItem = mainController.bottomItems;
    return GNav(
      tabMargin: EdgeInsetsGeometry.all(12),
      gap: 20,
      backgroundColor: Colors.white,
      activeColor: Colors.white,
      color: Colors.grey[600],

      tabBackgroundColor: Color(0xff378B6F),
      tabs: List.generate(
        bottomItem.length,
        (index) => GButton(
          icon: bottomItem[index]['icon'],
          text: bottomItem[index]['label'],
        ),
      ),
      selectedIndex: mainController.currentIndex.value,
      onTabChange: (index) => mainController.currentIndex.value = index,
    );
  }
}

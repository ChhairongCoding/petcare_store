import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/views/main_views/controller/main_controller.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final MainController mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: _buidBody(),
          bottomNavigationBar: _buildBottomNavigationBar(),
        ));
  }

  Widget _buidBody() {
    return mainController.pages[mainController.currentIndex.value];
  }

  _buildBottomNavigationBar() {
    final bottomItem = mainController.bottomItems;

    return BottomNavigationBar(
      
      currentIndex: mainController.currentIndex.value,
      onTap: (index) => mainController.currentIndex.value = index,
      items: List.generate(
        bottomItem.length,
        (index) => BottomNavigationBarItem(
          icon: bottomItem[index]['icons'],
          label: bottomItem[index]['label'],
        ),
      ),
    );
  }
}

import 'package:get/get.dart';
import 'package:petcare_store/config/core/routes/app_routes.dart';
import 'package:petcare_store/services/local_service.dart';
import 'dart:developer' as developer;

class ProviderLocal extends GetxController {
  static RxBool isDetail = true.obs;
  static List<String> page = ["Home", "Reminder", "Pet Details", "Profile"];
  final LocalService token = LocalService();

  Future<void> isPage(int index, bool checkDetail) async {
    isDetail.value = checkDetail;

    // 🔑 get token asynchronously
    final currentToken = await token.getToken();
    final hasToken = currentToken != null && currentToken.isNotEmpty;

    // 🔒 Restricted pages
    developer.log('Current token: $currentToken');
    if (index != 0 && !hasToken) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    // 🏠 Home page logic
    if (index == 0 && isDetail.value) {
      if (hasToken) {
        Get.offAllNamed(AppRoutes.mainScreen);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    }
  }
}

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  final _storage = GetStorage();
  final RxString token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    token.value = _storage.read('token') ?? '';
  }

  bool get isLoggedIn => token.isNotEmpty;

  void saveToken(String newToken) {
    token.value = newToken;
    _storage.write('token', newToken);
  }

  void logout() {
    token.value = '';
    _storage.remove('token');
  }
}

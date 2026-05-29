import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FavoriteController extends GetxController {
  final _storage = GetStorage();
  static const String _key = 'favorite_products';

  final RxList<String> favoriteIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    final List<dynamic>? stored = _storage.read<List<dynamic>>(_key);
    if (stored != null) {
      favoriteIds.assignAll(stored.cast<String>());
    }
  }

  void toggleFavorite(String productId) {
    if (favoriteIds.contains(productId)) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }
    _storage.write(_key, favoriteIds.toList());
  }

  bool isFavorite(String productId) {
    return favoriteIds.contains(productId);
  }
}

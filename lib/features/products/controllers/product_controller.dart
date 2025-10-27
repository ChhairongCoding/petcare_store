import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/product_model.dart';
import 'dart:developer' as developer;

class ProductController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final _client = Supabase.instance.client;

  final int _limit = 20;
  final RxBool isFirstLoadRunning = false.obs;
  final RxBool isLoadMoreRunning = false.obs;
  final RxBool hasNextPage = true.obs;
  final RxInt _page = 1.obs;

  @override
  void onInit() {
    super.onInit();
    firstLoad();
  }

  Future<void> firstLoad() async {
    isFirstLoadRunning(true);
    _page(1);
    products.clear();
    await fetchProducts();
    isFirstLoadRunning(false);
  }

  Future<void> fetchProducts({bool loadMore = false}) async {
    if (!hasNextPage.value && loadMore) return;

    try {
      if (loadMore) isLoadMoreRunning(true);

      final from = (_page.value - 1) * _limit;
      final to = from + _limit - 1;

      final response = await _client
          .from('products')
          .select()
          .range(from, to)
          .order('id', ascending: true);

      await dotenv.load(fileName: ".env");
      final baseUrl = dotenv.env['bucketUrl']!;

      final fetched = response.map<ProductModel>((product) {
        final fullImageUrl = '$baseUrl${product['image_path']}';
        return ProductModel.fromJson({...product, 'image_path': fullImageUrl});
      }).toList();

      if (fetched.isEmpty) {
        hasNextPage(false);
      } else {
        if (loadMore) {
          products.addAll(fetched);
        } else {
          products.assignAll(fetched);
        }
        _page.value++;
      }

    } catch (e) {
      developer.log('Error fetching products: $e');
    } finally {
      isLoadMoreRunning(false);
    }
  }

  Future<void> loadMore() async {
    if (hasNextPage.value &&
        !isFirstLoadRunning.value &&
        !isLoadMoreRunning.value) {
      await fetchProducts(loadMore: true);
    }
  }
}

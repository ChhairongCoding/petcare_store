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
    hasNextPage(true);
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

      developer.log('Fetching products from $from to $to');

      final response = await _client
          .from('products')
          .select()
          .range(from, to)
          .order('id', ascending: true);

      developer.log('Supabase response: ${response.length} products');

      final fetched = response.map<ProductModel>((product) {
        final imagePath = product['image_path'] as String?;
        final bucketId = product['image_bucket_id'] as String? ?? 'product_image';

        String finalImageUrl = '';

        if (imagePath != null && imagePath.isNotEmpty) {
          if (imagePath.startsWith('http')) {
            // Already a full URL, use as-is
            finalImageUrl = imagePath;
            developer.log('Using existing URL for ${product['name']}: $finalImageUrl');
          } else {
            // Use Supabase Storage to build the correct public URL
            finalImageUrl = _client.storage
                .from(bucketId)
                .getPublicUrl(imagePath);
            developer.log('Generated URL for ${product['name']}: $finalImageUrl');
          }
        } else {
          developer.log('No image path for product: ${product['name']}');
        }

        return ProductModel.fromJson({...product, 'image_path': finalImageUrl});
      }).toList();

      developer.log('Processed ${fetched.length} products');

      if (fetched.isEmpty) {
        hasNextPage(false);
        developer.log('No more products available');
      } else {
        if (loadMore) {
          products.addAll(fetched);
        } else {
          products.assignAll(fetched);
        }
        _page.value++;
        developer.log('Products loaded. Total: ${products.length}');
      }
    } catch (e, stackTrace) {
      developer.log('Error fetching products: $e');
      developer.log('Stack trace: $stackTrace');
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

  Future<void> refresh() async {
    await firstLoad();
  }
}
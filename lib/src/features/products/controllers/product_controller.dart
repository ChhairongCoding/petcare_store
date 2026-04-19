import 'package:get/get.dart';
import 'package:petcare_store/src/features/products/model/product_variant_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/product_model.dart';
import 'dart:developer' as developer;

class ProductController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final _client = Supabase.instance.client;
  final RxList<ProductVariantModel> selectedProductVariants =
      <ProductVariantModel>[].obs;
  final RxList<ProductModel> relatedProducts = <ProductModel>[].obs;

  final RxBool isRelatedLoading = false.obs;
  final RxBool isVariantsLoading = false.obs;
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
        final bucketId =
            product['image_bucket_id'] as String? ?? 'product_image';

        String finalImageUrl = '';

        if (imagePath != null && imagePath.isNotEmpty) {
          if (imagePath.startsWith('http')) {
            // Already a full URL, use as-is
            finalImageUrl = imagePath;
            developer.log(
              'Using existing URL for ${product['name']}: $finalImageUrl',
            );
          } else {
            // Use Supabase Storage to build the correct public URL
            finalImageUrl = _client.storage
                .from(bucketId)
                .getPublicUrl(imagePath);
            developer.log(
              'Generated URL for ${product['name']}: $finalImageUrl',
            );
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

  Future<void> fetchVariants(String productId) async {
    try {
      isVariantsLoading(true);
      selectedProductVariants.clear();

      final response = await _client
          .from('product_variants')
          .select('''
          id, product_id, sku, price, stock_qty, is_active,
          animal_types(name),
          flavors(name),
          weight_options(label, weight_kg)
        ''')
          .eq('product_id', productId)
          .eq('is_active', true);

      final variants = response
          .map<ProductVariantModel>((v) => ProductVariantModel.fromJson(v))
          .toList();

      selectedProductVariants.assignAll(variants);
    } catch (e) {
      developer.log('Error fetching variants: $e');
    } finally {
      isVariantsLoading(false);
    }
  }

  Future<void> fetchRelatedProducts({
    required String excludeProductId,
    String? animalType,
    String? flavor,
  }) async {
    try {
      isRelatedLoading(true);
      relatedProducts.clear();

      if (animalType != null || flavor != null) {
        final response = await _client
            .from('product_variants')
            .select('product_id, animal_types(name), flavors(name)')
            .eq('is_active', true)
            .neq('product_id', excludeProductId);

        final matchingProductIds = response
            .where((v) {
              final vAnimal = v['animal_types']?['name'] as String?;
              final vFlavor = v['flavors']?['name'] as String?;
              return (animalType != null && vAnimal == animalType) ||
                  (flavor != null && vFlavor == flavor);
            })
            .map((v) => v['product_id'] as String)
            .toSet()
            .toList();

        if (matchingProductIds.isNotEmpty) {
          await _fetchProductsByIds(matchingProductIds);
          return; // Found variant-based related products
        }
      }

      // Fallback: just show other products (excluding current)
      developer.log(
        'No variant-based related products, falling back to all products',
      );
      final fallback = await _client
          .from('products')
          .select()
          .neq('id', excludeProductId)
          .limit(6);

      final fetched = _mapProducts(fallback);
      relatedProducts.assignAll(fetched);
    } catch (e) {
      developer.log('Error fetching related products: $e');
    } finally {
      isRelatedLoading(false);
    }
  }

  // Helper to avoid repeating image URL logic
  Future<void> _fetchProductsByIds(List<String> ids) async {
    final response = await _client
        .from('products')
        .select()
        .inFilter('id', ids)
        .limit(6);
    relatedProducts.assignAll(_mapProducts(response));
  }

  List<ProductModel> _mapProducts(List<dynamic> response) {
    return response.map<ProductModel>((product) {
      final imagePath = product['image_path'] as String?;
      final bucketId = product['image_bucket_id'] as String? ?? 'product_image';
      String finalImageUrl = '';

      if (imagePath != null && imagePath.isNotEmpty) {
        finalImageUrl = imagePath.startsWith('http')
            ? imagePath
            : _client.storage.from(bucketId).getPublicUrl(imagePath);
      }

      return ProductModel.fromJson({...product, 'image_path': finalImageUrl});
    }).toList();
  }
}

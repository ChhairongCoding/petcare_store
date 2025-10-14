import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/product_model.dart';
import 'dart:developer' as developer;

class ProductController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final _client = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await _client.from('products').select();

      const baseUrl =
          'https://olifzzukugzbckppxnke.supabase.co/storage/v1/object/public/product_image/';

      products.value = response.map<ProductModel>((product) {
        final fullImageUrl = '$baseUrl${product['image_path']}';
        developer.log('Full image URL: $fullImageUrl');
        return ProductModel.fromJson({...product, 'image_path': fullImageUrl});
      }).toList();
    } catch (e) {
      developer.log('Error fetching products: $e');
    }
  }
}

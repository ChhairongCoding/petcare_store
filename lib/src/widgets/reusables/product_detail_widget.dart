import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/features/products/model/product_model.dart';

class ProductDetailWidget extends StatelessWidget {
  const ProductDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the product argument passed from the navigation
    final ProductModel product = Get.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(background: _buildAppBar(product)),
          ),
          _buildBody(product, context),
        ],
      ),
    );
  }

  Container _buildAppBar(ProductModel product) {
    return Container(
      padding: EdgeInsets.all( 60),
      height: 500,
      width: double.infinity,
      child: Image.network(
        product.imagePath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(child: Icon(Icons.broken_image, size: 50));
        },
      ),
    );
  }

  SliverToBoxAdapter _buildBody(ProductModel product, BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          // Product Image
          // Product Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8),
                Text(
                  "\$${product.price}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Product Description",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8),
                Text(
                  product.description ?? "No description available",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/features/products/controllers/product_controller.dart';
import 'package:petcare_store/widgets/reusables/product_card_widget_custom.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          showSearch(context: context, delegate: CustomSearchDelegate()),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 1,
              offset: Offset(0, 0.2),
            ),
          ],
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      HugeIcons.strokeRoundedSearch01,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {},
                  ),
                  Text(
                    "Search products...",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
              // CircleAvatar(
              //   backgroundColor: Colors.grey[200],
              //   child: Icon(
              //     HugeIcons.strokeRoundedFilterHorizontal,
              //     color: Colors.grey[700],
              //     size: 30,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final ProductController productController = Get.find<ProductController>();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredProducts = productController.products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildProductList(filteredProducts, context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredProducts = productController.products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildProductList(filteredProducts, context);
  }

  Widget _buildProductList(List products, BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text(
          'Start typing to search products...',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Text(
          'No products found',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCardWidgetCustom(
            price: product.price.toString(),
            productImage: product.imagePath,
            name: product.name,
            products: product,
          );
        },
      ),
    );
  }
}

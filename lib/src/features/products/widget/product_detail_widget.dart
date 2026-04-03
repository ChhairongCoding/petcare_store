import 'dart:io' as platform;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/src/config/core/routes/app_routes.dart';
import 'package:petcare_store/src/features/cart/controller/cart_controller.dart';
import 'package:petcare_store/src/features/products/controllers/product_controller.dart';
import 'package:petcare_store/src/features/products/model/product_model.dart';
import 'package:petcare_store/src/widgets/reusables/product_card_widget_custom.dart';

class ProductDetailWidget extends StatefulWidget {
  const ProductDetailWidget({super.key});

  @override
  State<ProductDetailWidget> createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  ProductModel product = Get.arguments;
  final CartController cartController = Get.find<CartController>();
  final ProductController productController = Get.find<ProductController>();
  final products = ProductController().products;
  int quantity = 1;
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          Obx(
            () => SliverAppBar(
              floating: true,
              backgroundColor: Colors.white,
              actionsPadding: EdgeInsets.only(right: 10),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    platform.Platform.isAndroid
                        ? Icons.arrow_back
                        : Icons.arrow_back_ios_new,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
              actions: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      HugeIcons.strokeRoundedShare01,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      HugeIcons.strokeRoundedFavourite,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () => Get.toNamed(AppRoutes.cart),
                    icon: Badge(
                      label: Text(cartController.cartItems.length.toString()),
                      child: Icon(
                        HugeIcons.strokeRoundedShoppingCart02,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
              expandedHeight: 390,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    PageView.builder(
                      itemCount: 3, // Simulating 3 images for the product
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: product.imagePath,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentImageIndex == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildBody(context)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton.icon(
            onPressed: () =>
                cartController.addToCart(product, quantity: quantity),
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Add to Cart'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildBody(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 6,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              child: Row(
                spacing: 6,
                children: [
                  Icon(
                    HugeIcons.strokeRoundedChampion,
                    size: 18,
                    color: Colors.blueAccent,
                  ),
                  Text(
                    "Bestseller",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.redAccent, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              child: Row(
                spacing: 6,
                children: [
                  Icon(
                    HugeIcons.strokeRoundedCouponPercent,
                    size: 18,
                    color: Colors.redAccent,
                  ),
                  Text("15% OFF", style: TextStyle(color: Colors.redAccent)),
                ],
              ),
            ),
          ],
        ),
        Text(
          product.name,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        Row(
          spacing: 12,
          children: [
            Text(
              "198 sold",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[900]),
            ),
            Text("-"),
            Text(
              'Free Shipping Available',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[900]),
            ),
          ],
        ),
        Row(
          children: [
            Column(
              spacing: 4,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "In stock (12)",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: quantity > 1
                      ? () => setState(() => quantity--)
                      : null,
                  icon: Icon(
                    Icons.remove,
                    color: quantity > 1
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    quantity.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => quantity++),
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: List.generate(5, (index) {
                return Icon(
                  HugeIcons.strokeRoundedStar,
                  color: index < product.rating.toString().length
                      ? Colors.orangeAccent
                      : Colors.grey,
                  size: 20,
                );
              }),
            ),
            SizedBox(width: 12),
            Text(
              "(2,198)",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                print("Tappped");
              },
              child: Text(
                "18 Questions",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),

        SizedBox(
          height: 20,
          child: Divider(thickness: 1, color: Colors.grey.shade300),
        ),
        Text(
          "Related Products",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                children: List.generate(productController.products.length, (
                  index,
                ) {
                  return ProductCardWidgetCustom(
                    products: productController.products[index],
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/config/core/routes/app_routes.dart';
import 'package:petcare_store/features/cart/controller/cart_controller.dart';
import 'package:petcare_store/features/products/controllers/product_controller.dart';
import 'package:petcare_store/features/products/model/product_model.dart';
import 'package:petcare_store/widgets/reusables/product_card_widget_custom.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 390,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(imageUrl: product.imagePath),
            ),
          ),
          SliverToBoxAdapter(child: _buildBody(context)),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
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
    );
  }

  AppBar _buildAppBar() => AppBar(
    backgroundColor: Theme.of(context).colorScheme.primary,
    actions: [
      IconButton(onPressed: () {}, icon: Icon(HugeIcons.strokeRoundedShare01)),
      IconButton(
        onPressed: () {},
        icon: Icon(HugeIcons.strokeRoundedFavourite),
      ),
      IconButton(
        onPressed: () => Get.toNamed(AppRoutes.cart),
        icon: Badge(
          label: Text(quantity.toString()),
          child: Icon(HugeIcons.strokeRoundedShoppingCart02),
        ),
      ),
    ],
  );

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
        child: Divider(
          thickness: 1,
          color: Colors.grey.shade300,
        ),
        ),
        Text("Related Products" , style: Theme.of(context).textTheme.titleMedium,),
        Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                children: List.generate(productController.products.length, (index) {
                  final product = productController.products[index];
                  return ProductCardWidgetCustom(
                    price: product.price.toString(),
                    productImage: product.imagePath,
                    name: product.name,
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

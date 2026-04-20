import 'dart:io' as platform;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/src/config/core/routes/app_routes.dart';
import 'package:petcare_store/src/features/cart/controller/cart_controller.dart';
import 'package:petcare_store/src/features/products/controllers/product_controller.dart';
import 'package:petcare_store/src/features/products/model/product_model.dart';
import 'package:petcare_store/src/features/products/model/product_variant_model.dart';
import 'package:petcare_store/src/features/products/views/widget/skeleton_chip_widget.dart';
import 'package:petcare_store/src/widgets/reusables/product_card_widget_custom.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:petcare_store/src/widgets/reusables/custom_snackbar_widget.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late ProductModel product;
  final CartController cartController = Get.find<CartController>();
  final ProductController productController = Get.find<ProductController>();
  int quantity = 1;
  int _currentImageIndex = 0;

  late ScrollController _scrollController;
  bool _showAppBarBg = false;

  String? _selectedAnimalType;
  String? _selectedFlavor;
  String? _selectedWeight;
  ProductVariantModel? _selectedVariant;

  @override
  void initState() {
    super.initState();

    product = Get.arguments as ProductModel;

    productController.fetchVariants(product.id).then((_) {
      final variants = productController.selectedProductVariants;
      final defaultAnimal = variants.isNotEmpty
          ? variants.first.animalType
          : null;
      productController.fetchRelatedProducts(
        excludeProductId: product.id,
        animalType: defaultAnimal,
      );
    });

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset > 320;
      if (shouldShow != _showAppBarBg) {
        setState(() => _showAppBarBg = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateSelectedVariant() {
    final variants = productController.selectedProductVariants;
    try {
      _selectedVariant = variants.firstWhere(
        (v) =>
            v.animalType == _selectedAnimalType &&
            v.flavor == _selectedFlavor &&
            v.weightLabel == _selectedWeight,
      );
    } catch (_) {
      _selectedVariant = null;
    }
    setState(() {});

    productController.fetchRelatedProducts(
      excludeProductId: product.id,
      animalType: _selectedAnimalType,
      flavor: _selectedFlavor,
    );
  }

  bool _isItemEnabled(String category, String value) {
    if (productController.selectedProductVariants.isEmpty) return true;

    return productController.selectedProductVariants.any((v) {
      if (category == 'Animal Type' && v.animalType != value) return false;
      if (category == 'Flavor' && v.flavor != value) return false;
      if (category == 'Size / Weight' && v.weightLabel != value) return false;

      if (category != 'Animal Type' &&
          _selectedAnimalType != null &&
          v.animalType != _selectedAnimalType)
        return false;
      if (category != 'Flavor' &&
          _selectedFlavor != null &&
          v.flavor != _selectedFlavor)
        return false;
      if (category != 'Size / Weight' &&
          _selectedWeight != null &&
          v.weightLabel != _selectedWeight)
        return false;

      return v.stockQty > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => Skeletonizer(
              enabled: productController.isVariantsLoading.value,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    SizedBox(
                      height: 390,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40, bottom: 20),
                            child: PageView.builder(
                              itemCount: 3,
                              onPageChanged: (index) =>
                                  setState(() => _currentImageIndex = index),
                              itemBuilder: (context, index) {
                                if (product.imagePath.isEmpty) {
                                  return Container(
                                    color: Colors.grey.shade100,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                  );
                                }
                                return CachedNetworkImage(
                                  imageUrl: product.imagePath,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: Colors.grey.shade100,
                                        child: const Icon(
                                          Icons.broken_image,
                                          size: 64,
                                          color: Colors.grey,
                                        ),
                                      ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(color: Colors.white, child: _buildBody(context)),
                  ],
                ),
              ),
            ),
          ),

          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              color: _showAppBarBg ? Colors.white : Colors.transparent,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _showAppBarBg
                            ? Colors.grey.shade100
                            : Colors.white.withValues(alpha: 0.8),
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
                      const Spacer(),
                      CircleAvatar(
                        backgroundColor: _showAppBarBg
                            ? Colors.grey.shade100
                            : Colors.white.withValues(alpha: 0.8),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            HugeIcons.strokeRoundedShare01,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: _showAppBarBg
                            ? Colors.grey.shade100
                            : Colors.white.withValues(alpha: 0.8),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            HugeIcons.strokeRoundedFavourite,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: _showAppBarBg
                            ? Colors.grey.shade100
                            : Colors.white.withValues(alpha: 0.8),
                        child: IconButton(
                          onPressed: () => Get.toNamed(AppRoutes.cart),
                          icon: Badge(
                            label: Text(
                              cartController.cartItems.length.toString(),
                            ),
                            child: const Icon(
                              HugeIcons.strokeRoundedShoppingCart02,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton.icon(
            onPressed: () {
              if (_selectedVariant?.stockQty == 0) return;
              if (productController.selectedProductVariants.isNotEmpty &&
                  _selectedVariant == null) {
                CustomSnackbar.show(
                  title: 'Wait a Sec!',
                  message:
                      'Please pick your favorite options (flavor, size, etc.) first.',
                  type: SnackbarType.warning,
                );
                return;
              }
              cartController.addToCart(
                product,
                quantity: quantity,
                variant: _selectedVariant,
              );
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Add to Cart'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedVariant?.stockQty != 0
                  ? Get.theme.primaryColor
                  : Colors.grey,
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

  Widget _buildBody(BuildContext context) => Padding(
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
                borderRadius: const BorderRadius.all(Radius.circular(14)),
              ),
              child: Row(
                spacing: 6,
                children: [
                  const Icon(
                    HugeIcons.strokeRoundedChampion,
                    size: 18,
                    color: Colors.blueAccent,
                  ),
                  const Text(
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
                borderRadius: const BorderRadius.all(Radius.circular(14)),
              ),
              child: Row(
                spacing: 6,
                children: [
                  const Icon(
                    HugeIcons.strokeRoundedCouponPercent,
                    size: 18,
                    color: Colors.redAccent,
                  ),
                  const Text(
                    "15% OFF",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                product.name,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              '\$${(_selectedVariant?.price ?? product.price).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
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
            const Text("-"),
            Text(
              'Free Shipping Available',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[900]),
            ),
          ],
        ),

        _buildVariantSection(context),

        SizedBox(
          height: 20,
          child: Divider(thickness: 1, color: Colors.grey.shade300),
        ),
        Row(
          children: [
            Text(
              "Quantity",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                    icon: const Icon(HugeIcons.strokeRoundedRemove01),
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      quantity.toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => quantity++),
                    icon: const Icon(HugeIcons.strokeRoundedAdd01),
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
          child: Divider(thickness: 1, color: Colors.grey.shade300),
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
            const SizedBox(width: 12),
            Text(
              "(2,198)",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => print("Tapped"),
              child: Text(
                "18 Questions",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),

        SizedBox(child: Divider(thickness: 1, color: Colors.grey.shade300)),

        Text(
          "Related Products",
          style: Theme.of(context).textTheme.titleMedium,
        ),

        Obx(() {
          final isLoading = productController.isRelatedLoading.value;
          final related = productController.relatedProducts;

          if (!isLoading && related.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No related products found.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            );
          }

          return Skeletonizer(
            enabled: isLoading,
            child: Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                spacing: 0,
                runSpacing: 0,
                children: isLoading
                    ? List.generate(
                        4,
                        (_) => ProductCardWidgetCustom(
                          products: ProductModel.fake(),
                        ),
                      )
                    : related
                          .map((p) => ProductCardWidgetCustom(products: p))
                          .toList(),
              ),
            ),
          );
        }),
      ],
    ),
  );

  Widget _buildVariantSection(BuildContext context) {
    return Obx(() {
      final isLoading = productController.isVariantsLoading.value;
      final variants = productController.selectedProductVariants;

      if (!isLoading && variants.isEmpty) return const SizedBox.shrink();

      return Skeletonizer(
        enabled: isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSkeletonChipsWidget(
              context,
              "Animal Type",
              isLoading
                  ? ["Dog", "Cat"]
                  : variants
                        .map((v) => v.animalType)
                        .whereType<String>()
                        .toSet()
                        .toList(),
              _selectedAnimalType,
              (val) {
                setState(() => _selectedAnimalType = val);
                _updateSelectedVariant();
              },
              isEnabled: (val) =>
                  isLoading ? true : _isItemEnabled('Animal Type', val),
            ),
            buildSkeletonChipsWidget(
              context,
              "Flavor",
              isLoading
                  ? ["Salmon", "Chicken", "Beef"]
                  : variants
                        .map((v) => v.flavor)
                        .whereType<String>()
                        .toSet()
                        .toList(),
              _selectedFlavor,
              (val) {
                setState(() => _selectedFlavor = val);
                _updateSelectedVariant();
              },
              isEnabled: (val) =>
                  isLoading ? true : _isItemEnabled('Flavor', val),
            ),
            buildSkeletonChipsWidget(
              context,
              "Size / Weight",
              isLoading
                  ? ["1kg", "5kg", "10kg"]
                  : variants
                        .map((v) => v.weightLabel)
                        .whereType<String>()
                        .toSet()
                        .toList(),
              _selectedWeight,
              (val) {
                setState(() => _selectedWeight = val);
                _updateSelectedVariant();
              },
              isEnabled: (val) =>
                  isLoading ? true : _isItemEnabled('Size / Weight', val),
            ),
            if (_selectedVariant != null)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      '\$${_selectedVariant!.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Stock: ${_selectedVariant!.stockQty}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (_selectedVariant!.sku != null) ...[
                      const SizedBox(width: 12),
                      Text(
                        'SKU: ${_selectedVariant!.sku}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }
}

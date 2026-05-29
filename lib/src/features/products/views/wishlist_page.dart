import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/src/config/core/routes/app_routes.dart';
import 'package:petcare_store/src/features/products/controllers/favorite_controller.dart';
import 'package:petcare_store/src/features/products/controllers/product_controller.dart';
import 'package:petcare_store/src/features/products/model/product_model.dart';
import 'package:petcare_store/src/widgets/reusables/product_card_widget_custom.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final favoriteController = Get.find<FavoriteController>();
  final productController = Get.find<ProductController>();

  final RxList<ProductModel> _favProducts = <ProductModel>[].obs;
  final RxBool _isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    if (favoriteController.favoriteIds.isEmpty) return;

    _isLoading(true);
    try {
      final products = await productController.fetchProductsByIds(
        favoriteController.favoriteIds,
      );
      _favProducts.assignAll(products);
    } catch (e) {
      debugPrint('Error loading wishlist products: $e');
    } finally {
      _isLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Obx(() {
          final count = favoriteController.favoriteIds.length;
          return Text(
            "My Wishlist${count > 0 ? ' ($count)' : ''}",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
          );
        }),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              HugeIcons.strokeRoundedArrowLeft01,
              color: Colors.black87,
              size: 20,
            ),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (_isLoading.value) {
          return _buildLoadingGrid();
        }

        // Live filtering so items animate/disappear instantly when unfavorited on this screen
        final activeFavs = _favProducts
            .where((p) => favoriteController.isFavorite(p.id))
            .toList();

        if (activeFavs.isEmpty) {
          return _buildEmptyState(context);
        }

        return _buildWishlistGrid(activeFavs);
      }),
    );
  }

  Widget _buildLoadingGrid() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Loading your favorites...",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Stunning aesthetic heart and star composition
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    HugeIcons.strokeRoundedFavourite,
                    color: colorScheme.primary,
                    size: 48,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 15,
                child: Icon(
                  HugeIcons.strokeRoundedStar,
                  color: colorScheme.secondary,
                  size: 24,
                ),
              ),
              Positioned(
                bottom: 15,
                left: 10,
                child: Icon(
                  Icons.pets,
                  color: colorScheme.primary.withValues(alpha: 0.4),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            "Your Wishlist is Empty",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            "Tap the heart icon on any product or pet to save it here for later.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {
              Get.until((route) => Get.currentRoute == AppRoutes.mainScreen);
            },
            icon: const Icon(HugeIcons.strokeRoundedShoppingBag01, size: 18),
            label: const Text("Explore Products"),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistGrid(List<ProductModel> products) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Center(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: products.map((product) {
            return ProductCardWidgetCustom(
              key: ValueKey(product.id),
              products: product,
            );
          }).toList(),
        ),
      ),
    );
  }
}

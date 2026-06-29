import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/config/core/routes/app_routes.dart';
import 'package:petcare_store/src/features/booking/controller/booking_controller.dart';
import 'package:petcare_store/src/features/category/controller/category_controller.dart';
import 'package:petcare_store/src/features/home/controller/home_controller.dart';
import 'package:petcare_store/src/features/home/view/widgets/app_bar.dart';
import 'package:petcare_store/src/features/products/controllers/product_controller.dart';
import 'package:petcare_store/src/features/products/model/product_model.dart';
import 'package:petcare_store/src/features/home/view/widgets/card_show_widget.dart';
import 'package:petcare_store/src/widgets/reusables/product_card_widget_custom.dart';
import 'package:petcare_store/src/widgets/search_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.find<HomeController>();
  final ProductController productController = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final BookingController bookingController = Get.find<BookingController>();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!productController.isLoadMoreRunning.value &&
          productController.hasNextPage.value) {
        productController.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        final isLoading = productController.isFirstLoadRunning.value;
        return Padding(
          padding: const EdgeInsets.all(12),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              AppBarWidget(),
              _buildBody(context, isLoading),
              if (productController.isLoadMoreRunning.value)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 50)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBody(context, bool isLoading) {
    return SliverToBoxAdapter(
      child: Skeletonizer(
        enabled: isLoading,
        child: Column(
          spacing: 20,
          children: [
            const SizedBox(height: 10),
            SearchWidget(),
            CartBannerSlider(),

            Column(
              spacing: 12,
              children: [
                Row(
                  children: [
                    Text(
                      "Booking Services",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.booking),
                      child: Text(
                        "Bookings",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                /// Booking services with its own skeleton state
                Obx(() {
                  final isServicesLoading =
                      bookingController.isServicesLoading.value;
                  final services = bookingController.services;

                  /// Show skeleton placeholders when services are loading
                  if (isServicesLoading || services.isEmpty) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Row(
                        children: List.generate(
                          4,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: _buildServiceSkeletonItem(context),
                          ),
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: services.map((service) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _buildServiceItem(context, service),
                        );
                      }).toList(),
                    ),
                  );
                }),
                SizedBox(height: 10),
                Column(
                  spacing: 12,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Popular Pets",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.shopScreen),
                          child: const Text(
                            "See All",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      final isLoading =
                          productController.isFirstLoadRunning.value;
                      return SizedBox(
                        height: 290,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: isLoading
                              ? 5
                              : productController.products.length,
                          itemBuilder: (context, index) {
                            final isLoading =
                                productController.isFirstLoadRunning.value;

                            final product = isLoading
                                ? ProductModel.fake()
                                : productController.products[index];

                            return ProductCardWidgetCustom(
                              products: product,
                              width: 150,
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
                Column(
                  spacing: 12,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Hot New",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.local_fire_department,
                              color: Colors.orange,
                              size: 20,
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.shopScreen),
                          child: const Text(
                            "See All",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      final isLoading =
                          productController.isFirstLoadRunning.value;
                      final displayProducts = isLoading
                          ? []
                          : productController.products.reversed.toList();
                      return SizedBox(
                        height: 290,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: isLoading ? 5 : displayProducts.length,
                          itemBuilder: (context, index) {
                            final isLoading =
                                productController.isFirstLoadRunning.value;

                            final product = isLoading
                                ? ProductModel.fake()
                                : displayProducts[index];

                            return ProductCardWidgetCustom(
                              products: product,
                              width: 150,
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),

                Column(
                  spacing: 20,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Nearby Pets",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.shopScreen),
                          child: const Text(
                            "See All",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Obx(() {
                      final currentIsLoading =
                          productController.isFirstLoadRunning.value;
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: List.generate(
                            currentIsLoading
                                ? 6
                                : productController.products.length,
                            (index) {
                              final product = currentIsLoading
                                  ? ProductModel.fake()
                                  : productController.products[index];
                              return ProductCardWidgetCustom(products: product);
                            },
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getServiceIcon(String imageKey) {
    final lowerKey = imageKey.toLowerCase();
    if (lowerKey.contains('groom') || lowerKey.contains('cut')) {
      return Icons.content_cut_rounded;
    } else if (lowerKey.contains('vet') ||
        lowerKey.contains('clinic') ||
        lowerKey.contains('medical') ||
        lowerKey.contains('hospital')) {
      return Icons.local_hospital_rounded;
    } else if (lowerKey.contains('board') ||
        lowerKey.contains('hotel') ||
        lowerKey.contains('stay')) {
      return Icons.hotel_rounded;
    } else if (lowerKey.contains('train') || lowerKey.contains('school')) {
      return Icons.school_rounded;
    } else if (lowerKey.contains('spa') ||
        lowerKey.contains('bath') ||
        lowerKey.contains('wash')) {
      return Icons.spa_rounded;
    }
    return Icons.pets_rounded;
  }

  /// Skeleton placeholder for a booking service item
  Widget _buildServiceSkeletonItem(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 30, backgroundColor: Colors.grey.shade200),
          const SizedBox(height: 8),
          Container(
            width: 50,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  /// Actual booking service item
  Widget _buildServiceItem(BuildContext context, dynamic service) {
    final icon = _getServiceIcon(service.image);
    final bgColor = Theme.of(context).primaryColor.withValues(alpha: 0.1);
    final iconColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () {
        bookingController.selectService(service.id);
        Get.toNamed(AppRoutes.booking);
      },
      child: SizedBox(
        width: 76,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, size: 28, color: iconColor),
            ),
            const SizedBox(height: 8),
            Text(
              service.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

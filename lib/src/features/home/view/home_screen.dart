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
  final HomeController homeController = Get.put(HomeController());
  final ProductController productController = Get.put(ProductController());
  final CategoryController categoryController = Get.put(CategoryController());
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
    final BookingController bookingController = Get.put(BookingController());

    return SliverToBoxAdapter(
      child: Skeletonizer(
        enabled: isLoading,
        child: Column(
          spacing: 20,
          children: [
            const SizedBox(height: 20),
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

                Obx(() {
                  if (bookingController.isServicesLoading.value &&
                      bookingController.services.isEmpty) {
                    return const SizedBox(
                      height: 60,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bookingController.services.length,
                      itemBuilder: (context, index) {
                        final service = bookingController.services[index];
                        return GestureDetector(
                          onTap: () {
                            bookingController.selectService(service.id);
                            Get.toNamed(AppRoutes.booking);
                          },
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              height: 55,
                              width: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.1),
                                      child: Icon(
                                        Icons.pets_rounded,
                                        size: 20,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        service.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),

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

                            return ProductCardWidgetCustom(products: product);
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

                            return ProductCardWidgetCustom(products: product);
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
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

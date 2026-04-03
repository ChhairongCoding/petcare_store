import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/features/category/controller/category_controller.dart';
import 'package:petcare_store/src/features/home/controller/home_controller.dart';
import 'package:petcare_store/src/features/home/view/widgets/app_bar.dart';
import 'package:petcare_store/src/features/products/controllers/product_controller.dart';
import 'package:petcare_store/src/features/products/model/product_model.dart';
import 'package:petcare_store/src/features/home/view/widgets/card_show_widget.dart';
import 'package:petcare_store/src/widgets/reusables/product_card_widget_custom.dart';
import 'package:petcare_store/src/widgets/search_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController homeController = Get.put(HomeController());
  final ProductController productController = Get.put(ProductController());
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          final isLoading = productController.isFirstLoadRunning.value;
          return Padding(
            padding: const EdgeInsets.all(12),
            child: CustomScrollView(
              slivers: <Widget>[AppBarWidget(), _buildBody(context, isLoading)],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBody(context, bool isLoading) {
    return SliverToBoxAdapter(
      child: Skeletonizer(
        enabled: isLoading,
        child: Column(
          spacing: 20,
          children: [
            SizedBox(height: 20),
            SearchWidget(),
            CartBannerSlider(),

            Column(
              spacing: 12,
              children: [
                Row(
                  children: [
                    Text(
                      "Categories",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Spacer(),
                    Text(
                      "See All",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),

                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryController.cateLists.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(right: 12),
                          height: 55,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.grey[300],
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: categoryController
                                          .cateLists[index]
                                          .image,
                                      fit: BoxFit.cover,
                                      height: 35, // match 2 * radius
                                      width: 35,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  categoryController.cateLists[index].name,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Column(
                  spacing: 12,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Popular Pets",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Spacer(),
                        Text(
                          "See All",
                          style: Theme.of(context).textTheme.titleSmall,
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
                  spacing: 20,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Nearby Pets",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Spacer(),
                        Text(
                          "See All",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),

                    Obx(() {
                      final currentIsLoading = productController.isFirstLoadRunning.value;
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          spacing: 20,
                          children: List.generate(
                            currentIsLoading ? 5 : productController.products.length,
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

                SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

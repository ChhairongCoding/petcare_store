import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/features/products/controllers/product_controller.dart';
import 'package:petcare_store/widgets/reusables/product_card_widget_custom.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  _buildBody(BuildContext context) => CustomScrollView(
    slivers: [
      SliverAppBar(
        expandedHeight: 220,
        backgroundColor: Theme.of(context).colorScheme.primary,
        flexibleSpace: FlexibleSpaceBar(
          background: _buildHeader(context),
        ),
      ),
      SliverToBoxAdapter(child: _buildFeature(context)),
    ],
  );

  _buildHeader(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://cdn.dribbble.com/userupload/16957240/file/original-953ea24eebfc40bb353251aa77abf1ee.jpg?resize=1504x1128&vertical=center",
                          fit: BoxFit.cover,
                          width: 200,
                          height: 200,
                          placeholder: (context, url) =>
                              Icon(Icons.person, color: Colors.grey[400]),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, color: Colors.redAccent),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Chhairong",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          Text(
                            "chchairong@gmail.com",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: Colors.grey[200]),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedSettings01,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildItemHead(context, title: "5", subtitle: "Wishlist"),
                    Container(
                      width: 1,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                      ),
                    ),
                    _buildItemHead(context, title: "10", subtitle: "Coupons"),
                    Container(
                      width: 1,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                      ),
                    ),
                    _buildItemHead(context, title: "55", subtitle: "Points"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildItemHead(
    BuildContext context, {
    String? title,
    String? subtitle,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? "0",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
          Text(
            subtitle ?? "0",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  _buildFeature(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 14,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 0.5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "My orders",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Spacer(),
                    Text(
                      "See all",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _featureItemProfile(
                      context,
                      "Pending",
                      HugeIcons.strokeRoundedDeliveryBox01,
                      Colors.grey[600],
                    ),
                    _featureItemProfile(
                      context,
                      "Processing",
                      HugeIcons.strokeRoundedDeliveryView01,
                      Colors.grey[600],
                    ),
                    _featureItemProfile(
                      context,
                      "Shipped",
                      HugeIcons.strokeRoundedDeliverySent01,
                      Colors.grey[600],
                    ),
                    _featureItemProfile(
                      context,
                      "Review",
                      HugeIcons.strokeRoundedSafeDelivery01,
                      Colors.grey[600],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 0.5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "My bookings Services",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Spacer(),
                    Text(
                      "See all",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _featureItemProfile(
                      context,
                      "Pending",
                      HugeIcons.strokeRoundedTime02,
                      Theme.of(context).colorScheme.primary,
                    ),
                    _featureItemProfile(
                      context,
                      "Confirmed",
                      HugeIcons.strokeRoundedCheckList,
                      Theme.of(context).colorScheme.primary,
                    ),
                    _featureItemProfile(
                      context,
                      "Completed",
                      HugeIcons.strokeRoundedCheckmarkBadge01,
                      Theme.of(context).colorScheme.primary,
                    ),
                    _featureItemProfile(
                      context,
                      "Concelled",
                      HugeIcons.strokeRoundedCancelCircle,
                      Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          _buildHotSales(context),
        ],
      ),
    );
  }

  _featureItemProfile(
    BuildContext context,
    String title,
    IconData icon,
    Color? color,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 28),
          Icon(icon, color: color, size: 35),
          SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  _buildHotSales(BuildContext context) {
    ProductController productController = Get.find<ProductController>();
    return Column(
      children: [
        Text("Hot sales", style: Theme.of(context).textTheme.titleMedium),
          Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              children: List.generate(productController.products.length, (index) {
                final product = productController.products[index];
                return ProductCardWidgetCustom(
              products: product,
                );
              }),
            ),
          ),
      ],
    );
  }
}
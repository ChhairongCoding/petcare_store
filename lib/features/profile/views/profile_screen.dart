import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/features/products/controllers/product_controller.dart';
import 'package:petcare_store/features/profile/controller/profile_controller.dart';
import 'package:petcare_store/features/profile/widgets/feature_item_profile.dart';
import 'package:petcare_store/features/profile/widgets/item_head_widget.dart';
import 'package:petcare_store/widgets/reusables/product_card_widget_custom.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(background: _buildHeader(context)),
          ),
          SliverToBoxAdapter(child: _buildFeature(context)),
        ],
      ),
    );
  }

  // 🔹 HEADER SECTION
  Widget _buildHeader(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top Row: Avatar + Info + Settings
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                Obx(() {
                  final avatarUrl =
                      profileController.profile.value?.avatar ?? '';
                  return CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: avatarUrl.isNotEmpty ? avatarUrl : '',
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                        placeholder: (context, url) => Icon(
                          Icons.person,
                          color: Colors.grey[500],
                          size: 40,
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 40,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 16),

                // Name + Email
                Expanded(
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profileController.profile.value?.name ?? "Guest User",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profileController.profile.value?.email ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[200]),
                        ),
                      ],
                    ),
                  ),
                ),

                // Settings Button
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedSettings01,
                    color: Colors.white,
                    size: 26,
                  ),
                  onPressed: () => Get.toNamed(
                    "/settings",
                    arguments: profileController.profile.value,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Wishlist / Coupons / Points
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildItemHead(context, title: "5", subtitle: "Wishlist"),
                _divider(),
                buildItemHead(context, title: "10", subtitle: "Coupons"),
                _divider(),
                buildItemHead(context, title: "55", subtitle: "Points"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3));

  // 🔹 FEATURE SECTION
  Widget _buildFeature(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCardSection(
            context,
            title: "My Orders",
            items: [
              featureItemProfile(
                context,
                "Pending",
                HugeIcons.strokeRoundedDeliveryBox01,
                Colors.grey[600],
              ),
              featureItemProfile(
                context,
                "Processing",
                HugeIcons.strokeRoundedDeliveryView01,
                Colors.grey[600],
              ),
              featureItemProfile(
                context,
                "Shipped",
                HugeIcons.strokeRoundedDeliverySent01,
                Colors.grey[600],
              ),
              featureItemProfile(
                context,
                "Review",
                HugeIcons.strokeRoundedSafeDelivery01,
                Colors.grey[600],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCardSection(
            context,
            title: "My Booking Services",
            items: [
              featureItemProfile(
                context,
                "Pending",
                HugeIcons.strokeRoundedTime02,
                Theme.of(context).colorScheme.primary,
              ),
              featureItemProfile(
                context,
                "Confirmed",
                HugeIcons.strokeRoundedCheckList,
                Theme.of(context).colorScheme.primary,
              ),
              featureItemProfile(
                context,
                "Completed",
                HugeIcons.strokeRoundedCheckmarkBadge01,
                Theme.of(context).colorScheme.primary,
              ),
              featureItemProfile(
                context,
                "Cancelled",
                HugeIcons.strokeRoundedCancelCircle,
                Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildHotSales(context),
        ],
      ),
    );
  }

  Widget _buildCardSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
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
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Text(
                "See all",
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items,
          ),
        ],
      ),
    );
  }

  // 🔹 HOT SALES SECTION
  Widget _buildHotSales(BuildContext context) {
    final productController = Get.find<ProductController>();
    final products = productController.products;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Hot Sales", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),

        Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            children: List.generate(productController.products.length, (index) {
              final product = productController.products[index];
              return ProductCardWidgetCustom(
                price: product.price.toString(),
                productImage: product.imagePath,
                name: product.name,
              );
            }),
          ),
        ),
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/src/config/core/routes/app_routes.dart';
import 'package:petcare_store/src/features/products/controllers/product_controller.dart';
import 'package:petcare_store/src/widgets/reusables/product_card_widget_custom.dart';
import 'package:petcare_store/src/features/profile/controller/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildBody(context);
      }),
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverAppBar(context),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 60),
              _buildStatsBar(context),
              _buildMainFeatures(context),
              _buildAccountSettings(context),
              // _buildHotSales(context),
              const SizedBox(height: 72),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final profile = controller.profile.value;
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: profile?.avatar != null
                                ? CachedNetworkImageProvider(profile!.avatar!)
                                : const CachedNetworkImageProvider(
                                    "https://cdn.dribbble.com/userupload/16957240/file/original-953ea24eebfc40bb353251aa77abf1ee.jpg?resize=1504x1128&vertical=center",
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      profile?.name ?? "Guest User",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      profile?.email ?? "Sign in to see details",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedSettings01,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildStatsBar(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
              context,
              "5",
              "Wishlist",
              HugeIcons.strokeRoundedFavourite,
            ),
            _buildDivider(),
            _buildStatItem(
              context,
              "12",
              "Coupons",
              HugeIcons.strokeRoundedTicket01,
            ),
            _buildDivider(),
            _buildStatItem(
              context,
              "840",
              "Points",
              HugeIcons.strokeRoundedStar,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Colors.grey[200]);
  }

  Widget _buildMainFeatures(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildSectionHeader(context, "My Activities", () {}),
          _buildActivityGrid(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback onSeeAll,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              "See All",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActivityItem(
            context,
            "Orders",
            HugeIcons.strokeRoundedShoppingBag01,
            () => Get.toNamed(AppRoutes.myorders),
          ),
          _buildActivityItem(
            context,
            "Bookings",
            HugeIcons.strokeRoundedCalendar03,
            () => Get.toNamed(AppRoutes.myBookings),
          ),
          _buildActivityItem(context, "My Pets", Icons.pets_outlined, () {}),
          _buildActivityItem(
            context,
            "Reviews",
            HugeIcons.strokeRoundedMessageEdit01,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            "Personal Info",
            HugeIcons.strokeRoundedUser,
            () {},
          ),
          _buildMenuItem(
            context,
            "Address Book",
            HugeIcons.strokeRoundedLocation01,
            () => Get.toNamed(AppRoutes.shipping),
          ),
          // _buildMenuItem(
          //   context,
          //   "Payment Methods",
          //   HugeIcons.strokeRoundedCreditCard,
          //   () {},
          // ),
          _buildMenuItem(
            context,
            "Notification Settings",
            HugeIcons.strokeRoundedNotification03,
            () {},
          ),
          _buildMenuItem(
            context,
            "Help & Support",
            HugeIcons.strokeRoundedHelpCircle,
            () {},
          ),
          _buildMenuItem(
            context,
            "Logout",
            HugeIcons.strokeRoundedLogout01,
            () => _showLogoutDialog(context),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDestructive ? Colors.red : Colors.grey[700],
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Widget _buildHotSales(BuildContext context) {
  //   final productController = Get.find<ProductController>();
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
  //         child: Text(
  //           "Recommended for You",
  //           style: Theme.of(
  //             context,
  //           ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //       SizedBox(
  //         height: 280,
  //         child: ListView.builder(
  //           padding: const EdgeInsets.symmetric(horizontal: 12),
  //           scrollDirection: Axis.horizontal,
  //           itemCount: productController.products.length,
  //           itemBuilder: (context, index) {
  //             final product = productController.products[index];
  //             return Container(
  //               width: 180,
  //               margin: const EdgeInsets.symmetric(horizontal: 8),
  //               child: ProductCardWidgetCustom(products: product),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

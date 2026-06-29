import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:marquee/marquee.dart';
import 'package:petcare_store/src/config/core/routes/app_routes.dart';
import 'package:petcare_store/src/features/cart/controller/cart_controller.dart';
import 'package:petcare_store/src/features/shipping/controller/shipping_controller.dart';
import 'package:petcare_store/src/features/notification/controller/notification_page_controller.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final ShippingController shippingController = Get.find();
    final NotificationPageController notificationPageController =
        Get.find<NotificationPageController>();

    return SliverAppBar(
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light,
      ),
      title: GestureDetector(
        onTap: () {
          Get.toNamed("/shipping");
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              HugeIcons.strokeRoundedPinLocation01,
              size: 26,
              color: Colors.red,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Location",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 18,
                    width: 140,
                    child: Marquee(
                      text:
                          shippingController.defaultAddress?.addressDetail ??
                          'No address',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      scrollAxis: Axis.horizontal,
                      velocity: 30.0,
                      blankSpace: 20.0,
                      pauseAfterRound: const Duration(seconds: 3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      actions: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Obx(() {
            final unread = notificationPageController.unreadCount;
            return Badge(
              isLabelVisible: unread > 0,
              label: Text(unread.toString()),
              child: IconButton(
                icon: Icon(
                  HugeIcons.strokeRoundedNotification02,
                  size: 26,
                  color: Colors.grey[700],
                ),
                onPressed: () => Get.toNamed(AppRoutes.notificationScreen),
              ),
            );
          }),
        ),
        SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Obx(() {
            return Badge(
              label: Text(cartController.countItemCart().toString()),
              child: IconButton(
                icon: Icon(
                  HugeIcons.strokeRoundedShoppingCart01,
                  size: 26,
                  color: Colors.grey[700],
                ),
                onPressed: () => Get.toNamed(AppRoutes.cart),
              ),
            );
          }),
        ),
        SizedBox(width: 8),
      ],
    );
  }
}

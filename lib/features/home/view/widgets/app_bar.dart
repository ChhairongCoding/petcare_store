import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:marquee/marquee.dart';
import 'package:petcare_store/config/core/routes/app_routes.dart';
import 'package:petcare_store/features/cart/controller/cart_controller.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return SliverAppBar(
      elevation: 0,
      floating: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(12),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              HugeIcons.strokeRoundedPinLocation01,
              size: 32,
              color: Colors.red,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Location",
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 20,
                    width: 120,
                    child: Marquee(
                      text: "7c, Phnom Penh, Cambodia",
                      style: Theme.of(context).textTheme.titleSmall,
                      scrollAxis: Axis.horizontal,
                      velocity: 30.0,
                      blankSpace: 20.0,
                      pauseAfterRound: Duration(seconds: 3),
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
          child: IconButton(
            icon: Icon(
              HugeIcons.strokeRoundedNotification02,
              size: 26,
              color: Colors.grey[700],
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Obx(() => Badge(
            label: Text(cartController.totalItems.toString()),
            child: IconButton(
              icon: Icon(
                HugeIcons.strokeRoundedShoppingCart01,
                size: 26,
                color: Colors.grey[700],
              ),
              onPressed: () => Get.toNamed(AppRoutes.cart),
            ),
          )),
        ),
        SizedBox(width: 8),
      ],
    );
  }
}
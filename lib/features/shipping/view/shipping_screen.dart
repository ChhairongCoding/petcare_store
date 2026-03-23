import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/features/shipping/controller/shipping_controller.dart';

class ShippingScreen extends StatelessWidget {
  ShippingScreen({super.key});
  final ShippingController shippingController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Shipping Address"),
      actions: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.withValues(alpha: 0.1),
          ),
          onPressed: () => Get.toNamed("addressForm"),
          icon: Icon(Icons.add),
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(() {
        if (shippingController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (shippingController.addressLists.isEmpty) {
          return const Center(child: Text("No address found"));
        }
        return ListView.builder(
          itemCount: shippingController.addressLists.length,
          itemBuilder: (context, index) {
            final address = shippingController.addressLists[index];
            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(0.3, 2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(address.name, style: Get.textTheme.headlineSmall),

                      DropdownButton(
                        items: [
                          DropdownMenuItem(
                            value: 'remove',
                            child: Text("Remove",style: Get.textTheme.bodyMedium,),
                          ),
                          DropdownMenuItem(
                            value: 'remove',
                            child: Text("Default",style: Get.textTheme.bodyMedium),
                          ),
                        ],
                        icon: Icon(Icons.more_vert),
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                  Text(address.addressDetail),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

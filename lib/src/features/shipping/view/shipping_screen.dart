import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:petcare_store/src/features/shipping/controller/shipping_controller.dart';
import 'package:petcare_store/src/features/shipping/model/shipping_model.dart';

class ShippingScreen extends StatelessWidget {
  ShippingScreen({super.key});
  final ShippingController shippingController = Get.find();
  final bool isSelectMode = Get.arguments?['selectMode'] ?? false;
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
            return GestureDetector(
              onTap: isSelectMode
                  ? () {
                      Get.back(result: address);
                    }
                  : null,
              child: _addressCard(address, context, shippingController, index),
            );
          },
        );
      }),
    );
  }

  Container _addressCard(
    ShippingModel address,
    BuildContext context,
    ShippingController shippingController,
    int index,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 10),
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
              Expanded(
                child: Text(address.name, style: Get.textTheme.titleMedium),
              ),
              address.isDefault == true
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColor.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Default", style: Get.textTheme.bodySmall),
                    )
                  : SizedBox.shrink(),
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  customButton: Icon(Icons.more_vert),
                  items: [
                    DropdownItem<String>(
                      value: 'remove',
                      child: Text(
                        "Remove",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                      ),
                    ),
                    DropdownItem<String>(
                      value: 'default',
                      child: Text(
                        "Default",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],

                  onChanged: (value) {
                    if (value == "remove") {
                      shippingController.removeAddress(index);
                    } else if (value == "default") {
                      shippingController.setDefault(
                        address.id.toString(),
                      ); // pass the address id
                    }
                  },

                  // 👇 CONTROL POSITION HERE
                  dropdownStyleData: DropdownStyleData(
                    offset: Offset(-120, 0), // move down/up
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(address.addressDetail),
        ],
      ),
    );
  }
}

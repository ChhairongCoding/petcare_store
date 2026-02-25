import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/features/cart/controller/cart_controller.dart';

class ProcessBuyScreen extends StatelessWidget {
  const ProcessBuyScreen({super.key, this.cartController, this.currentStep = 0});

  final CartController? cartController;
  final int currentStep; // 0 = Summary, 1 = Payment, 2 = Confirmation

  @override
  Widget build(BuildContext context) {
    final controller = cartController ?? Get.find<CartController>();

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(controller, context),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  
  AppBar _buildAppBar() => AppBar(title: const Text("Checkout"));

  SingleChildScrollView _buildBody(CartController controller, BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStepIndicator(),
            const SizedBox(height: 20),
            _buildLocationPick(context),
            const SizedBox(height: 20),
            Column(
              children: List.generate(controller.cartItems.length, (index) {
                return _cardProduct(context, controller, index);
              }),
            ),
            SizedBox(height: 20,),
            _buildCartSummary(context),
            SizedBox(height: 20,),
            
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildBottomNavigationBar() {
    return ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(currentStep == 2 ? "Place Order" : "Confirm Payment"),
        );
  }


  Container _buildCartSummary(BuildContext context) {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cart Summary",
                style: Get.textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Divider(),
              Row(children: [
                Text("Delivery fee", style: Get.textTheme.bodyMedium),
                Spacer(),
                Text("\$00.0", style: Get.textTheme.bodyMedium),
              ],),
              const SizedBox(height: 10),
              Row(children: [
                Text("Subtotal", style: Get.textTheme.bodyMedium),
                Spacer(),
                Text("\$45.0", style: Get.textTheme.bodyMedium),
              ],),
              const SizedBox(height: 10),
              Row(children: [
                Text("Total", style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                Spacer(),
                Text("\$45.0", style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],),
            ],
          ),
        );
  }

  

  Container _cardProduct(BuildContext context, CartController controller, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(1, 5),
          )
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: Image.network(
              controller.cartItems[index].product.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.cartItems[index].product.name,
                  overflow: TextOverflow.ellipsis,
                  style: Get.textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text("Size: M",
                        style: Get.textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey)),
                    const SizedBox(width: 8),
                    Text("|",
                        style: Get.textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey)),
                    const SizedBox(width: 8),
                    Text(
                        "Qty: ${controller.cartItems[index].quantity}",
                        style: Get.textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$15.0", style: Get.textTheme.titleMedium),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text("-",
                              style: Get.textTheme.titleSmall
                                  ?.copyWith(fontSize: 20)),
                        ),
                        Text(controller.cartItems[index].quantity.toString()),
                        TextButton(
                          onPressed: () {},
                          child: Text("+",
                              style: Get.textTheme.titleSmall
                                  ?.copyWith(fontSize: 20)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

GestureDetector _buildLocationPick(BuildContext context) {
    return GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.pin_drop_outlined, color: Colors.blue),
                Text(
                  " 123 Main Street, City, Country",
                  style: Get.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
  }

  // ✅ Step Indicator Widget
Widget _buildStepIndicator() {
  final steps = ["Summary", "Payment", "Confirmation"];
  final step = currentStep; // ✅ fallback to 0 if null

  return Row(
    children: List.generate(steps.length * 2 - 1, (i) {
      if (i.isOdd) {
        final lineIndex = i ~/ 2;
        final isCompleted = step > lineIndex; // ✅ use step
        return Expanded(
          child: Container(
            height: 3,
            color: isCompleted ? Colors.green : Colors.grey.shade300,
          ),
        );
      } else {
        final stepIndex = i ~/ 2;
        final isCompleted = step > stepIndex; // ✅ use step
        final isActive = step == stepIndex;   // ✅ use step
        return Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green : (isActive ? Colors.blue : Colors.grey.shade300),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              (stepIndex + 1).toString(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    }),
  );
}}
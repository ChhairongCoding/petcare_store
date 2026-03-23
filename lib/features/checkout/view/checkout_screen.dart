import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/features/cart/controller/cart_controller.dart';
import 'package:petcare_store/features/checkout/view/widget/modal_bottom_sheet_payment_widget.dart';

class ProcessBuyScreen extends StatefulWidget {
  const ProcessBuyScreen({
    super.key,
    this.cartController,
    this.initialStep = 0,
  });

  final CartController? cartController;
  final int initialStep; // 0 = Summary, 1 = Payment, 2 = Confirmation

  @override
  State<ProcessBuyScreen> createState() => _ProcessBuyScreenState();
}

class _ProcessBuyScreenState extends State<ProcessBuyScreen> {
  late CartController _controller;
  late int _currentStep;
  bool _isPaymentSelected = false;
  bool _isPaymentSuccessful = false;

  @override
  void initState() {
    super.initState();
    final controllerArg =
        widget.cartController ?? Get.arguments as CartController?;
    if (controllerArg == null) {
      throw Exception('Cart controller not found');
    }
    _controller = controllerArg;
    _currentStep = widget.initialStep;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(_controller),
      bottomNavigationBar: SafeArea(
        child: _buildBottomNavigationBar(_controller),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(title: const Text("Checkout"));

  SingleChildScrollView _buildBody(CartController controller) {
    final theme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Obx(()=> Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStepIndicator(),

            if (_currentStep == 0)
              Column(
                children: [
                  const SizedBox(height: 20),
                  _buildLocationPick(),
                  const SizedBox(height: 20),
                  Container(
      padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(1, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Text("Items(${controller.cartItems.length})", style: theme.titleMedium),
                        Column(
                          children: List.generate(controller.cartItems.length, (
                            index,
                          ) {
                            return _cardProduct(controller, index);
                          }),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  _buildCartSummary(controller),
                ],
              ),

            const SizedBox(height: 20),
            // Dynamic content based on payment state
            if (_isPaymentSelected && _currentStep == 1) _buildPaymentContent(),
            if (_isPaymentSuccessful) _buildSuccessContent(),
          ],
        ),
      )),
    );
  }

  // Payment content widget
  Widget _buildPaymentContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payment Details",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Divider(),
          Row(
            children: [
              Icon(Icons.credit_card, color: Colors.blue),
              const SizedBox(width: 10),
              Text(
                "Credit Card Payment",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Spacer(),
              Text(
                "Selected",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.account_balance, color: Colors.blue),
              const SizedBox(width: 10),
              Text("Card ending in 1234", style: Get.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                "Amount to pay:",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Spacer(),
              Text(
                "\$${_controller.totalPrice.value.toStringAsFixed(2)}",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Success content widget
  Widget _buildSuccessContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 10),
          Text(
            "Payment Successful!",
            style: Get.textTheme.titleLarge?.copyWith(color: Colors.green),
          ),
          const SizedBox(height: 10),
          Text(
            "Your order has been placed successfully.",
            style: Get.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text("Order ID:", style: Get.textTheme.bodyMedium),
              Spacer(),
              Text(
                "#ORD-123456",
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Expected Delivery:", style: Get.textTheme.bodyMedium),
              Spacer(),
              Text(
                "2-3 days",
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to order history or home
              Get.back(); // Close checkout screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Continue Shopping",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildBottomNavigationBar(CartController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          if (_isPaymentSuccessful) {
            // User can go back to shopping after success
            Get.back(); // Close checkout screen
            return;
          }

          if (_currentStep == 0) {
            Get.bottomSheet(
              modalBottomSheetPaymentWidget(
                onPaymentSelected: () {
                  setState(() {
                    _currentStep = 1;
                    _isPaymentSelected = true;
                  });
                },
              ),
            );
          } else if (_currentStep == 1) {
            // Navigate to confirmation step
            setState(() {
              _currentStep = 2;
            });
          } else {
            // Place order logic here
            setState(() {
              _controller.removeAllItem();
              _isPaymentSuccessful = true;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: _isPaymentSuccessful ? Colors.green : null,
        ),
        child: Text(
          _isPaymentSuccessful
              ? "Continue Shopping"
              : (_currentStep == 2 ? "Place Order" : "Confirm Payment"),
          style: TextStyle(color: _isPaymentSuccessful ? Colors.white : null),
        ),
      ),
    );
  }

  Container _buildCartSummary(CartController controller) {
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
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Cart Summary", style: Get.textTheme.titleMedium),
          const SizedBox(height: 10),
          Divider(),
          Row(
            children: [
              Text("Delivery fee", style: Get.textTheme.bodyMedium),
              Spacer(),
              Text("\$00.0", style: Get.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Subtotal", style: Get.textTheme.bodyMedium),
              Spacer(),
              Text(
                "\$${controller.totalPrice.value.toStringAsFixed(2)}",
                style: Get.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                "Total",
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                "\$${controller.totalPrice.value.toStringAsFixed(2)}",
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _cardProduct(CartController controller, int index) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                    Text(
                      "Size: M",
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "|",
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Qty: ${controller.cartItems[index].quantity}",
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "\$${controller.cartItems[index].product.price}",
                  style: Get.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildLocationPick() {
    return GestureDetector(
      onTap: () => Get.toNamed("/shipping"),
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
            ),
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
    final step = _currentStep; // ✅ use _currentStep

    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final lineIndex = i ~/ 2;
          final isCompleted = step > lineIndex; // ✅ use step
          return Expanded(
            child: Column(
              children: [
                Container(
                  height: 3,
                  color: isCompleted ? Colors.green : Colors.grey.shade300,
                ),
                Text(""),
              ],
            ),
          );
        } else {
          final stepIndex = i ~/ 2;
          final isCompleted = step > stepIndex; // ✅ use step,
          final isActive = step == stepIndex; // ✅ use step
          return Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green
                      : (isActive ? Colors.blue : Colors.grey.shade300),
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
              ),
              SizedBox(height: 8),
              Text(
                steps[stepIndex],
                style: Get.textTheme.bodySmall?.copyWith(
                  color: isActive ? Colors.blue : Colors.grey,
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}

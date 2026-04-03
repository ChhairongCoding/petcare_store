import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/features/cart/controller/cart_controller.dart';
import 'package:petcare_store/src/features/checkout/controller/payment_controller.dart';
import 'package:petcare_store/src/features/checkout/view/widget/modal_bottom_sheet_payment_widget.dart';
import 'package:petcare_store/src/features/shipping/controller/shipping_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProcessBuyScreen extends StatefulWidget {
  const ProcessBuyScreen({
    super.key,
    this.cartController,
    this.initialStep = 0,
  });
  final CartController? cartController;
  final int initialStep; // 0 = Summary, 1 = Payment

  @override
  State<ProcessBuyScreen> createState() => _ProcessBuyScreenState();
}

class _ProcessBuyScreenState extends State<ProcessBuyScreen> {
  late CartController _controller;
  late int _currentStep;
  dynamic _selectedAddress;

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

    final shippingController = Get.find<ShippingController>();
    _selectedAddress = shippingController.defaultAddress;
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
    return SingleChildScrollView(
      child: Obx(
        () => Container(
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
                          Text(
                            "Items(${controller.cartItems.length})",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Column(
                            children: List.generate(
                              controller.cartItems.length,
                              (index) => _cardProduct(controller, index),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCartSummary(controller),
                  ],
                ),

              if (_currentStep == 1) ...[
                const SizedBox(height: 20),
                _buildPaymentContent(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Payment details card (step 1) ───────────────────────────
  Widget _buildPaymentContent() {
    final PaymentController paymentController = Get.find();

    return Obx(
      () => Container(
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
            const Divider(),
            Row(
              children: [
                const Icon(Icons.payment, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  paymentController.paymentMethodLabel,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                const Text(
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
                Text(
                  "Amount to pay:",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Text(
                  "\$${_controller.totalPrice.value.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (paymentController.errorMessage.value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  paymentController.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Bottom action bar ───────────────────────────────────────
  Padding _buildBottomNavigationBar(CartController controller) {
    final PaymentController paymentController = Get.find();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => ElevatedButton(
          onPressed: paymentController.isLoading.value
              ? null
              : () async {
                  if (_currentStep == 0) {
                    // Step 0: open payment-method picker
                    Get.bottomSheet(
                      modalBottomSheetPaymentWidget(
                        onPaymentSelected: () {
                          setState(() => _currentStep = 1);
                        },
                      ),
                    );
                  } else if (_currentStep == 1) {
                    // Step 1: place order then branch by method
                    final success = await paymentController.placeOrder(
                      cartController: _controller,
                      userId: Supabase.instance.client.auth.currentUser!.id,
                      addressId: _selectedAddress?.id?.toString() ?? '',
                      totalPrice: _controller.totalPrice.value,
                    );

                    if (!success) return; // error message shown in UI

                    final method =
                        paymentController.selectedPaymentMethod.value;

                    if (method == PaymentMethod.khqr) {
                      // KHQR: show QR screen + wait for real-time confirmation
                      paymentController.subscribeToOrderStatus(
                        paymentController.currentOrderId.value,
                      );
                      Get.toNamed(
                        '/khqrPayment',
                        arguments: {
                          'amount': _controller.totalPrice.value
                              .toStringAsFixed(2),
                        },
                      );
                    } else if (method == PaymentMethod.abaPay) {
                      // ABA Pay: show waiting screen + wait for confirmation
                      paymentController.subscribeToOrderStatus(
                        paymentController.currentOrderId.value,
                      );
                      Get.toNamed(
                        '/abaPayment',
                        arguments: {
                          'amount': _controller.totalPrice.value
                              .toStringAsFixed(2),
                        },
                      );
                    } else {
                      // Cash on Delivery: go straight to success
                      Get.offAllNamed('/successPayment');
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: paymentController.isLoading.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(_currentStep == 0 ? "Continue" : "Confirm Payment"),
        ),
      ),
    );
  }

  // ── Cart summary ────────────────────────────────────────────
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
          const Divider(),
          Row(
            children: [
              Text("Delivery fee", style: Get.textTheme.bodyMedium),
              const Spacer(),
              Text("\$00.0", style: Get.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Subtotal", style: Get.textTheme.bodyMedium),
              const Spacer(),
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
              const Spacer(),
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

  // ── Product card ────────────────────────────────────────────
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

  // ── Address picker ──────────────────────────────────────────
  GestureDetector _buildLocationPick() {
    final ShippingController shippingController = Get.find();
    return GestureDetector(
      onTap: () async {
        final result = await Get.toNamed(
          "/shipping",
          arguments: {'selectMode': true},
        );
        if (result != null) {
          setState(() => _selectedAddress = result);
        }
      },
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
            const Icon(Icons.pin_drop_outlined, color: Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shippingController.defaultAddress?.name.toString() ?? "",
                    style: Get.textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    shippingController.defaultAddress?.addressDetail
                            .toString() ??
                        "Select your address",
                    style: Get.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Step indicator ──────────────────────────────────────────
  Widget _buildStepIndicator() {
    final steps = ["Summary", "Payment", "Confirmation"];
    final step = _currentStep;

    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final lineIndex = i ~/ 2;
          final isCompleted = step > lineIndex;
          return Expanded(
            child: Column(
              children: [
                Container(
                  height: 3,
                  color: isCompleted ? Colors.green : Colors.grey.shade300,
                ),
                const Text(""),
              ],
            ),
          );
        } else {
          final stepIndex = i ~/ 2;
          final isCompleted = step > stepIndex;
          final isActive = step == stepIndex;
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
              const SizedBox(height: 8),
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

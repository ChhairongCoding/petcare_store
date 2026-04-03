import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/features/checkout/controller/payment_controller.dart';

class AbaPayScreen extends StatefulWidget {
  const AbaPayScreen({super.key});

  @override
  State<AbaPayScreen> createState() => _AbaPayScreenState();
}

class _AbaPayScreenState extends State<AbaPayScreen> {
  late final PaymentController _paymentController;
  Worker? _worker;

  @override
  void initState() {
    super.initState();
    _paymentController = Get.find<PaymentController>();

    // Subscribe to real-time order status
    _paymentController.subscribeToOrderStatus(
      _paymentController.currentOrderId.value,
    );

    // Navigate to success when payment is confirmed
    _worker = ever(_paymentController.paymentConfirmed, (bool confirmed) {
      if (confirmed && mounted) {
        Get.offNamed('/successPayment');
      }
    });
  }

  @override
  void dispose() {
    _worker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderId = _paymentController.currentOrderId.value;
    final amount = Get.arguments?['amount'] ?? '0.00';

    return Scaffold(
      appBar: AppBar(
        title: const Text('ABA Pay'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _paymentController.cancelSubscription();
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── ABA logo ──────────────────────────────────
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    'assets/images/aba.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.account_balance,
                      size: 60,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Complete Payment via ABA',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Open your ABA Mobile app and confirm the payment.',
                style: Get.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // ── Amount card ────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Amount to Pay',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$$amount',
                      style: Get.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order ID',
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '#$orderId',
                          style: Get.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Waiting indicator ──────────────────────────
              Obx(() {
                final status = _paymentController.orderStatus.value;
                return Column(
                  children: [
                    const CircularProgressIndicator(color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      status == OrderStatus.pending
                          ? 'Waiting for payment confirmation...'
                          : 'Confirming payment...',
                      style: Get.textTheme.bodyMedium,
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

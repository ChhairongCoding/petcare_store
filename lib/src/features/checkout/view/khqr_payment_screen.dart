import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:petcare_store/src/features/checkout/controller/payment_controller.dart';

class KhqrPaymentScreen extends StatefulWidget {
  const KhqrPaymentScreen({super.key});

  @override
  State<KhqrPaymentScreen> createState() => _KhqrPaymentScreenState();
}

class _KhqrPaymentScreenState extends State<KhqrPaymentScreen> {
  late final PaymentController _paymentController;
  Worker? _worker;

  @override
  void initState() {
    super.initState();
    _paymentController = Get.find<PaymentController>();

    // Start listening for payment confirmation
    _paymentController.subscribeToOrderStatus(
      _paymentController.currentOrderId.value,
    );

    // When paymentConfirmed becomes true → navigate to success
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
    // Build a simple KHQR-style QR string with the order ID
    final qrData =
        'KHQR|ORDER:$orderId|AMOUNT:${Get.arguments?['amount'] ?? ''}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan to Pay'),
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
              // ── Header ────────────────────────────────────
              Image.asset(
                'assets/images/khqr.png',
                height: 40,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),
              Text(
                'Scan the QR code to complete your payment',
                style: Get.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // ── QR Code ───────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 240,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 32),

              // ── Waiting indicator ─────────────────────────
              Obx(() {
                final status = _paymentController.orderStatus.value;
                return Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(
                      status == OrderStatus.pending
                          ? 'Waiting for payment...'
                          : 'Confirming payment...',
                      style: Get.textTheme.bodyMedium,
                    ),
                  ],
                );
              }),
              const SizedBox(height: 24),

              // ── Order ID ──────────────────────────────────
              Text(
                'Order ID: #$orderId',
                style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

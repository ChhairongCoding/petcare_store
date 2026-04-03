import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/features/cart/controller/cart_controller.dart';
import 'package:petcare_store/src/features/checkout/controller/payment_controller.dart';
import 'package:petcare_store/src/features/checkout/view/widget/modal_bottom_sheet_payment_widget.dart';
import 'package:petcare_store/src/features/shipping/controller/shipping_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timelines_plus/timelines_plus.dart';

// ── Step model (mirrors BuyNowPage) ────────────────────────────────────────
class _StepModel {
  final String title;
  final IconData icon;
  const _StepModel({required this.title, required this.icon});
}

class ProcessBuyScreen extends StatefulWidget {
  const ProcessBuyScreen({
    super.key,
    this.cartController,
    this.initialStep = 0,
  });
  final CartController? cartController;
  final int initialStep;

  @override
  State<ProcessBuyScreen> createState() => _ProcessBuyScreenState();
}

class _ProcessBuyScreenState extends State<ProcessBuyScreen>
    with TickerProviderStateMixin {
  late CartController _controller;
  late int _currentStep;
  dynamic _selectedAddress;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _checkController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;
  late Animation<Offset> _slideAnimation;

  // Steps definition — mirrors BuyNowPage's TimeLineModel list
  final List<_StepModel> _steps = const [
    _StepModel(title: 'Summary', icon: Icons.list_alt_outlined),
    _StepModel(title: 'Payment', icon: Icons.credit_card_outlined),
    _StepModel(title: 'Confirmation', icon: Icons.check_circle_outline),
  ];

  @override
  void initState() {
    super.initState();
    final controllerArg =
        widget.cartController ?? Get.arguments as CartController?;
    if (controllerArg == null) throw Exception('Cart controller not found');
    _controller = controllerArg;
    _currentStep = widget.initialStep;

    final shippingController = Get.find<ShippingController>();
    _selectedAddress = shippingController.defaultAddress;

    // Fade + slide animation for step transitions
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    // Check-mark bounce animation for success
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );
    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    _fadeController.reset();
    setState(() => _currentStep = step);
    _fadeController.forward();
    if (step == 2) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) _checkController.forward(from: 0);
      });
    }
  }

  // ── Build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: SafeArea(child: _buildBottomBar()),
    );
  }

  // ── AppBar with timeline in bottom (mirrors BuyNowPage) ─────────────────
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_outlined, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: const Text(
        'Checkout',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SizedBox(height: 65, child: _buildTimeline()),
      ),
    );
  }

  // ── Timeline step indicator (mirrors BuyNowPage._step) ──────────────────
  Widget _buildTimeline() {
    return Timeline.tileBuilder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      theme: TimelineThemeData(direction: Axis.horizontal, nodePosition: 0),
      builder: TimelineTileBuilder.connected(
        itemCount: _steps.length,
        connectionDirection: ConnectionDirection.before,
        itemExtentBuilder: (_, __) =>
            MediaQuery.of(context).size.width / _steps.length,
        contentsBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Center(
              child: Text(
                _steps[index].title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _currentStep >= index
                      ? Colors.green
                      : Colors.grey.shade400,
                ),
              ),
            ),
          );
        },
        indicatorBuilder: (_, index) {
          final isActive = index <= _currentStep;
          return DotIndicator(
            size: 28,
            color: isActive ? Colors.green : Colors.grey.shade300,
            child: Icon(_steps[index].icon, size: 14, color: Colors.white),
          );
        },
        connectorBuilder: (_, index, __) {
          if (index == 0) return null;
          return (index - 1) < _currentStep
              ? const SolidLineConnector(color: Colors.green)
              : SolidLineConnector(color: Colors.grey.shade300);
        },
      ),
    );
  }

  // ── Body ────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_currentStep == 0) ...[
                  const SizedBox(height: 10),
                  _buildAddressPicker(),
                  const SizedBox(height: 16),
                  _buildItemsCard(),
                  const SizedBox(height: 16),
                  _buildCartSummary(),
                  const SizedBox(height: 80),
                ],
                if (_currentStep == 1) ...[
                  const SizedBox(height: 10),
                  _buildPaymentCard(),
                  const SizedBox(height: 80),
                ],
                if (_currentStep == 2) ...[
                  const SizedBox(height: 24),
                  _buildConfirmationView(),
                  const SizedBox(height: 40),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── Confirmation view (step 2) ──────────────────────────────────────────
  Widget _buildConfirmationView() {
    final PaymentController paymentController = Get.find();
    return Column(
      children: [
        // Animated check circle
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _checkAnimation,
              builder: (_, __) => Icon(
                Icons.check_rounded,
                color: Colors.white.withValues(alpha: _checkAnimation.value),
                size: 52,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Payment Successful!',
          style: Get.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Your order has been placed.',
          style: Get.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),

        // ── Receipt Card ──────────────────────────────────
        Obx(
          () => _CheckoutReceiptCard(
            orderId: paymentController.currentOrderId.value,
            paymentMethod: paymentController.paymentMethodLabel,
            status: paymentController.orderStatusLabel,
            address: _selectedAddress,
          ),
        ),
        const SizedBox(height: 28),

        // Continue Shopping button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {
              paymentController.reset();
              Get.offAllNamed('/');
            },
            icon: const Icon(Icons.storefront_outlined, color: Colors.white),
            label: const Text(
              'Continue Shopping',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            paymentController.reset();
            Get.offAllNamed('/myorders');
          },
          child: Text(
            'View My Orders',
            style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ── Address picker card ─────────────────────────────────────────────────
  Widget _buildAddressPicker() {
    final ShippingController shippingController = Get.find();
    return GestureDetector(
      onTap: () async {
        final result = await Get.toNamed(
          '/shipping',
          arguments: {'selectMode': true},
        );
        if (result != null) setState(() => _selectedAddress = result);
      },
      child: _card(
        child: Row(
          children: [
            const Icon(Icons.pin_drop_outlined, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shippingController.defaultAddress?.name?.toString() ?? '',
                    style: Get.textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    shippingController.defaultAddress?.addressDetail
                            ?.toString() ??
                        'Select your address',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ── Items card ──────────────────────────────────────────────────────────
  Widget _buildItemsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items (${_controller.cartItems.length})',
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          ...List.generate(
            _controller.cartItems.length,
            (i) => _buildProductTile(i),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTile(int index) {
    final item = _controller.cartItems[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 68,
              height: 68,
              child: Image.network(item.product.imagePath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  overflow: TextOverflow.ellipsis,
                  style: Get.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Size: M',
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '|',
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Qty: ${item.quantity}',
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.product.price}',
                  style: Get.textTheme.titleSmall?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Cart summary card ───────────────────────────────────────────────────
  Widget _buildCartSummary() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cart Summary',
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          _summaryRow('Delivery fee', '\$0.00'),
          const SizedBox(height: 8),
          _summaryRow(
            'Subtotal',
            '\$${_controller.totalPrice.value.toStringAsFixed(2)}',
          ),
          const Divider(height: 20),
          _summaryRow(
            'Total',
            '\$${_controller.totalPrice.value.toStringAsFixed(2)}',
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    final style = bold
        ? Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
        : Get.textTheme.bodyMedium;
    return Row(
      children: [
        Text(label, style: style),
        const Spacer(),
        Text(value, style: style),
      ],
    );
  }

  // ── Payment card (step 1) ───────────────────────────────────────────────
  Widget _buildPaymentCard() {
    final PaymentController paymentController = Get.find();
    return Obx(
      () => _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Details',
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.payment, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  paymentController.paymentMethodLabel,
                  style: Get.textTheme.bodyMedium,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Selected',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Text('Amount to pay:', style: Get.textTheme.bodyMedium),
                const Spacer(),
                Text(
                  '\$${_controller.totalPrice.value.toStringAsFixed(2)}',
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (paymentController.errorMessage.value.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        paymentController.errorMessage.value,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Bottom action button ────────────────────────────────────────────────
  Widget _buildBottomBar() {
    // Hide bottom bar on confirmation step
    if (_currentStep == 2) return const SizedBox.shrink();

    final PaymentController paymentController = Get.find();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Obx(
        () => ElevatedButton(
          onPressed: paymentController.isLoading.value
              ? null
              : () async {
                  if (_currentStep == 0) {
                    // Step 0 → open payment method sheet
                    Get.bottomSheet(
                      modalBottomSheetPaymentWidget(
                        onMethodConfirmed: (method) async {
                          if (method == PaymentMethod.cashOnDelivery) {
                            // COD: place order then go to receipt step
                            final success = await paymentController.placeOrder(
                              cartController: _controller,
                              userId: Supabase
                                  .instance.client.auth.currentUser!.id,
                              addressId:
                                  _selectedAddress?.id?.toString() ?? '',
                              totalPrice: _controller.totalPrice.value,
                            );
                            if (!mounted) return;
                            if (!success) {
                              final msg = paymentController
                                      .errorMessage.value.isNotEmpty
                                  ? paymentController.errorMessage.value
                                  : 'Could not place order. Please try again.';
                              Get.snackbar(
                                'Order Failed',
                                msg,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red.shade600,
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(16),
                                borderRadius: 12,
                                duration: const Duration(seconds: 4),
                                icon: const Icon(Icons.error_outline,
                                    color: Colors.white),
                              );
                              return;
                            }
                            // Success → show inline confirmation receipt
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) _goToStep(2);
                            });
                          } else {
                            // KHQR / ABA → go to payment detail step
                            _goToStep(1);
                          }
                        },
                      ),
                      isScrollControlled: true,
                    );
                  } else if (_currentStep == 1) {
                    // Step 1 → only KHQR / ABA reach here
                    final success = await paymentController.placeOrder(
                      cartController: _controller,
                      userId: Supabase.instance.client.auth.currentUser!.id,
                      addressId: _selectedAddress?.id?.toString() ?? '',
                      totalPrice: _controller.totalPrice.value,
                    );

                    if (!mounted) return;

                    if (!success) {
                      final msg =
                          paymentController.errorMessage.value.isNotEmpty
                              ? paymentController.errorMessage.value
                              : 'Could not place order. Please try again.';
                      Get.snackbar(
                        'Order Failed',
                        msg,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.shade600,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                        duration: const Duration(seconds: 4),
                        icon: const Icon(Icons.error_outline,
                            color: Colors.white),
                      );
                      return;
                    }

                    final method =
                        paymentController.selectedPaymentMethod.value;

                    if (method == PaymentMethod.khqr) {
                      paymentController.subscribeToOrderStatus(
                          paymentController.currentOrderId.value);
                      if (!mounted) return;
                      Get.toNamed('/khqrPayment', arguments: {
                        'amount':
                            _controller.totalPrice.value.toStringAsFixed(2),
                      });
                    } else if (method == PaymentMethod.abaPay) {
                      paymentController.subscribeToOrderStatus(
                          paymentController.currentOrderId.value);
                      if (!mounted) return;
                      Get.toNamed('/abaPayment', arguments: {
                        'amount':
                            _controller.totalPrice.value.toStringAsFixed(2),
                      });
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: paymentController.isLoading.value
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  _currentStep == 0 ? 'SELECT PAYMENT' : 'CONFIRM PAYMENT',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
        ),
      ),
    );
  }

  // ── Shared card wrapper ─────────────────────────────────────────────────
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Receipt card used in the Confirmation step ─────────────────────────────
class _CheckoutReceiptCard extends StatelessWidget {
  final String orderId;
  final String paymentMethod;
  final String status;
  final dynamic address;

  const _CheckoutReceiptCard({
    required this.orderId,
    required this.paymentMethod,
    required this.status,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final shortId = orderId.isEmpty
        ? '—'
        : orderId.substring(0, orderId.length.clamp(0, 8)).toUpperCase();

    return Column(
      children: [
        // ── Receipt body ────────────────────────────────────────────────
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            children: [
              // Store header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, color: Colors.green.shade500, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'PetCare Store',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'RECEIPT',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 4,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // Date & time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _metaChip(Icons.calendar_today_outlined, dateStr),
                  _metaChip(Icons.access_time_outlined, timeStr),
                ],
              ),
              const SizedBox(height: 20),
              _dottedDivider(),
              const SizedBox(height: 16),

              // Order rows
              _receiptRow('Order ID', '#$shortId'),
              const SizedBox(height: 12),
              _receiptRow('Payment', paymentMethod),
              const SizedBox(height: 12),
              _receiptRow('Status', status, valueColor: Colors.green.shade700),
              const SizedBox(height: 12),
              _receiptRow('Delivery', '2–3 business days'),
              if (address != null) ...[
                const SizedBox(height: 12),
                _receiptRow('Ship to', address?.name?.toString() ?? ''),
              ],
              const SizedBox(height: 16),
              _dottedDivider(),
              const SizedBox(height: 16),

              // Thank-you note
              Text(
                'Thank you for your purchase! 🐾',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade400,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),

        // ── Zigzag torn bottom edge ──────────────────────────────────────
        CustomPaint(
          size: const Size(double.infinity, 22),
          painter: _CheckoutTornEdgePainter(),
        ),
      ],
    );
  }

  Widget _metaChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.grey.shade400),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _receiptRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor ?? const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }

  Widget _dottedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount = (constraints.maxWidth / 8).floor();
        return Row(
          children: List.generate(
            dashCount,
            (_) => Expanded(
              child: Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                color: Colors.grey.shade200,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Torn / zigzag bottom edge painter ──────────────────────────────────────
class _CheckoutTornEdgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path();
    path.moveTo(0, 0);
    const toothWidth = 12.0;
    final teethCount = (size.width / toothWidth).ceil();
    for (int i = 0; i < teethCount; i++) {
      final x = i * toothWidth;
      path.lineTo(x + toothWidth / 2, size.height);
      path.lineTo(x + toothWidth, 0);
    }
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

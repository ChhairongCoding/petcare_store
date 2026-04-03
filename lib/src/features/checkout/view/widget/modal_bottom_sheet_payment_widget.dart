import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/features/checkout/controller/payment_controller.dart';

/// Calls [onMethodConfirmed] with the selected [PaymentMethod] when the user
/// taps Confirm. The caller decides what to do based on the method.
Widget modalBottomSheetPaymentWidget({
  required void Function(PaymentMethod method) onMethodConfirmed,
}) {
  return _PaymentMethodSheet(onMethodConfirmed: onMethodConfirmed);
}

class _PaymentMethodSheet extends StatefulWidget {
  final void Function(PaymentMethod method) onMethodConfirmed;
  const _PaymentMethodSheet({required this.onMethodConfirmed});

  @override
  State<_PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<_PaymentMethodSheet> {
  PaymentMethod? _selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select Payment Method',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // KHQR
          _PaymentTile(
            image: 'assets/images/khqr.png',
            label: 'KHQR',
            isSelected: _selected == PaymentMethod.khqr,
            onTap: () => setState(() => _selected = PaymentMethod.khqr),
          ),
          const SizedBox(height: 10),

          // ABA Pay
          _PaymentTile(
            image: 'assets/images/aba.png',
            label: 'ABA Pay',
            isSelected: _selected == PaymentMethod.abaPay,
            onTap: () => setState(() => _selected = PaymentMethod.abaPay),
          ),
          const SizedBox(height: 10),

          // Cash on Delivery
          _PaymentTile(
            image: 'assets/images/cod.png',
            label: 'Cash on Delivery',
            isSelected: _selected == PaymentMethod.cashOnDelivery,
            onTap: () =>
                setState(() => _selected = PaymentMethod.cashOnDelivery),
          ),
          const SizedBox(height: 20),

          // Confirm button — only active when something is selected
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _selected != null
                ? SizedBox(
                    key: const ValueKey('confirm'),
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final method = _selected!;
                        // Save in controller before closing
                        Get.find<PaymentController>()
                            .selectPaymentMethod(method);
                        Get.back(); // close sheet
                        widget.onMethodConfirmed(method);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(key: ValueKey('empty'), height: 50),
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String image;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.image,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green.shade400 : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: ListTile(
          leading: Image.asset(image, width: 28,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.payment, size: 28)),
          title: Text(
            label,
            style: TextStyle(
              fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.green.shade800 : Colors.black87,
            ),
          ),
          trailing: isSelected
              ? Icon(Icons.check_circle_rounded,
                  color: Colors.green.shade600, size: 22)
              : null,
        ),
      ),
    );
  }
}
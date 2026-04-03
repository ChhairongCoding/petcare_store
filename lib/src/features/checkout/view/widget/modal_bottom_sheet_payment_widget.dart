import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/features/checkout/controller/payment_controller.dart';

Widget modalBottomSheetPaymentWidget({VoidCallback? onPaymentSelected}) {
  final PaymentController paymentController = Get.find();

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle
        Container(
          width: 50,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Select Payment Method",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        // KHQR
        _paymentTile(
          image: "assets/images/khqr.png",
          label: "KHQR",
          onTap: () {
            paymentController.selectPaymentMethod(PaymentMethod.khqr);
            Get.back();
            onPaymentSelected?.call();
          },
        ),
        const SizedBox(height: 10),
        
        // ABA Pay
        _paymentTile(
          image: "assets/images/aba.png",
          label: "ABA Pay",
          onTap: () {
            paymentController.selectPaymentMethod(PaymentMethod.abaPay);
            Get.back();
            onPaymentSelected?.call();
          },
        ),
        const SizedBox(height: 10),

        // Cash on Delivery
        _paymentTile(
          image: "assets/images/cod.png",
          label: "Cash on Delivery",
          onTap: () {
            paymentController.selectPaymentMethod(PaymentMethod.cashOnDelivery);
            Get.back();
            onPaymentSelected?.call();
          },
        ),
        const SizedBox(height: 10),

        
      ],
    ),
  );
}

Widget _paymentTile({
  required String image,
  required String label,
  required VoidCallback onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      leading: Image.asset(image, width: 20),
      title: Text(label),
      onTap: onTap,
    ),
  );
}
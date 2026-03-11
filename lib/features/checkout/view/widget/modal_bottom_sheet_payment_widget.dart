import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

Widget modalBottomSheetPaymentWidget({
  VoidCallback? onPaymentSelected,
}) {
  return Container(

    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
    )),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 50,height: 5,decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(20)),),
        SizedBox(height: 10),
        Text(
          "Select Payment Method",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        ListTile(
          leading: Icon(Icons.credit_card),
          title: Text("Credit Card"),
          onTap: () {
            Get.back();
            onPaymentSelected?.call();
          },
        ),
        ListTile(
          leading: Icon(Icons.account_balance_wallet),
          title: Text("Mobile Wallet"),
          onTap: () {
            Get.back();
            onPaymentSelected?.call();
          },
        ),
        ListTile(
          leading: Icon(Icons.money),
          title: Text("Cash on Delivery"),
          onTap: () {
            Get.back();
            onPaymentSelected?.call();
          },
        ),
      ],
    ),
  );
}

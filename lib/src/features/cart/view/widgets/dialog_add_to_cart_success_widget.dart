
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class DialogAddToCartSuccessWidget extends StatefulWidget {
  const DialogAddToCartSuccessWidget({super.key});

  @override
  State<DialogAddToCartSuccessWidget> createState() => _DialogAddToCartSuccessWidgetState();
}

class _DialogAddToCartSuccessWidgetState extends State<DialogAddToCartSuccessWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
    Timer(const Duration(seconds: 2), () {
      Get.back();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        title: Text('Added to Cart'),
        icon: Icon(
          HugeIcons.strokeRoundedShoppingCartCheck01,
          color: Colors.green,
          size: 50,
        ),
        content: Text('Product added to cart', textAlign: TextAlign.center,),
      ),
    );
  }
}

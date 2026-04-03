import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/features/cart/models/cart_item_model.dart';
import 'package:petcare_store/src/features/cart/services/cart_service.dart';
import 'package:petcare_store/src/features/cart/view/widgets/dialog_add_to_cart_success_widget.dart';
import 'package:petcare_store/src/features/products/model/product_model.dart';
import 'dart:developer' as dev;

class CartController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final CartService cartService = CartService();
  RxInt quantity = 0.obs;
  RxDouble totalPrice = 0.0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _updateTotalPrice();
    getAllProductCart();
  }

  int countItemCart (){
    return cartItems.length;
  }

  void _updateTotalPrice() {
    totalPrice.value = cartItems.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(ProductModel product, {int quantity = 1}) async {
  final userId = cartService.getCurrentUserId();
  if (userId == null) {
    Get.snackbar(
      'Authentication Required',
      'Please log in to add items to your cart.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  final existingItemIndex = cartItems.indexWhere(
    (item) => item.product.id == product.id,
  );

  if (existingItemIndex != -1) {
    // Already in local list — just update
    final newQty = cartItems[existingItemIndex].quantity + quantity;
    cartItems[existingItemIndex].quantity = newQty;
    cartItems.refresh();
    await cartService.updateCartQty(productId: product.id, qty: newQty);
  } else {
    // ✅ Check Supabase directly before inserting
    final existingCart = await cartService.getCartItem(product.id);

    if (existingCart != null) {
      // Exists in DB but not in local list (e.g. after restart)
      final newQty = (existingCart['quantity'] as int) + quantity;
      await cartService.updateCartQty(productId: product.id, qty: newQty);
      cartItems.add(CartItemModel(product: product, quantity: newQty));
    } else {
      // Truly new item
      await cartService.addToCart(product.id, quantity);
      cartItems.add(CartItemModel(product: product, quantity: quantity));
    }
  }

  _updateTotalPrice();
  Get.dialog(DialogAddToCartSuccessWidget());
}

  void removeFromCart(String productId) {
    cartItems.removeWhere(
      (item) => item.product.id == productId,
    ); // ✅ remove locally
    _updateTotalPrice(); // ✅ update total
    cartService.removeFromCart(productId); // sync to supabase
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final itemIndex = cartItems.indexWhere(
      (item) => item.product.id == productId,
    );
    if (itemIndex != -1) {
      cartItems[itemIndex].quantity = newQuantity;
      cartItems.refresh();
      _updateTotalPrice();
    }
  }

  void clearCart() {
    cartItems.clear();
    _updateTotalPrice();
  }

  void removeAllItem() {
    isLoading(true);
    cartService.clearCart();
    cartItems.clear();
    cartItems.refresh();
    isLoading(false);
  }

  bool isInCart(String productId) {
    return cartItems.any((item) => item.product.id == productId);
  }

  CartItemModel? getCartItem(String productId) {
    return cartItems.firstWhereOrNull((item) => item.product.id == productId);
  }

  Future<void> getAllProductCart() async {
    try {
      isLoading(true);
      dev.log("Starting cart load process");

      final cartList = await cartService.getCart();
      dev.log("Cart list loaded: ${cartList.length} items");

      if (cartList.isEmpty) {
        cartItems.clear();
        cartItems.refresh();
        dev.log("Cart is empty, cleared items");
        return;
      }

      /// Extract product IDs
      final productIds = cartList.map((e) => e['product_id']).toList();
      dev.log("Product IDs to fetch: $productIds");

      /// Get product detail from Supabase
      final products = await cartService.client
          .from('products')
          .select()
          .inFilter('id', productIds);

      dev.log("Products fetched: ${products.length}");

      /// Convert to ProductModel list
      final productModels = products
          .map<ProductModel>((p) => ProductModel.fromJson(p))
          .toList();

      dev.log("Product models created: ${productModels.length}");

      /// Merge Cart + Product
      final cartItemsList = <CartItemModel>[];

      for (final cart in cartList) {
        final productId = cart['product_id'];
        dev.log("Looking for product with ID: $productId");

        final product = productModels.firstWhere(
          (p) => p.id == productId,
          orElse: () => throw Exception("Product not found for ID: $productId"),
        );

        dev.log("Found product: ${product.name}");

        final cartItem = CartItemModel(
          product: product,
          quantity: cart['quantity'] ?? 0,
        );

        cartItemsList.add(cartItem);
      }

      cartItems.value = cartItemsList;
      dev.log("Cart items mapped: ${cartItems.length}");

      _updateTotalPrice();
      cartItems.refresh();

      dev.log("Cart load completed successfully");
    } catch (e) {
      dev.log("Error loading full cart: $e");
    } finally {
      isLoading(false);
    }
  }
}

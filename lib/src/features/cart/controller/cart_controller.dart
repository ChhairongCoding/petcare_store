import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/features/cart/models/cart_item_model.dart';
import 'package:petcare_store/src/features/cart/services/cart_service.dart';
import 'package:petcare_store/src/features/cart/view/widgets/dialog_add_to_cart_success_widget.dart';
import 'package:petcare_store/src/features/products/model/product_model.dart';
import 'dart:developer' as dev;

import 'package:petcare_store/src/features/products/model/product_variant_model.dart';
import 'package:petcare_store/src/widgets/reusables/custom_snackbar_widget.dart';

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

  int countItemCart() {
    return cartItems.length;
  }

  void _updateTotalPrice() {
    totalPrice.value = cartItems.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(
    ProductModel product, {
    int quantity = 1,
    ProductVariantModel? variant,
  }) async {
    final userId = cartService.getCurrentUserId();
    if (userId == null) {
      CustomSnackbar.show(
        title: 'Heads Up!',
        message: 'Please log in to start adding items to your cart.',
        type: SnackbarType.warning,
      );
      return;
    }

    final variantId = variant?.id;

    final existingItemIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id && item.variantId == variantId,
    );

    if (existingItemIndex != -1) {
      final newQty = cartItems[existingItemIndex].quantity + quantity;
      cartItems[existingItemIndex].quantity = newQty;
      cartItems.refresh();
      await cartService.updateCartQty(
        productId: product.id,
        qty: newQty,
        variantId: variantId,
      );
    } else {
      final existingCart = await cartService.getCartItem(
        product.id,
        variantId: variantId,
      );

      if (existingCart != null) {
        final newQty = (existingCart['quantity'] as int) + quantity;
        await cartService.updateCartQty(
          productId: product.id,
          qty: newQty,
          variantId: variantId,
        );
        cartItems.add(
          CartItemModel(
            product: product,
            quantity: newQty,
            variantId: variantId,
            variant: variant,
          ),
        );
      } else {
        await cartService.addToCart(product.id, quantity, variantId: variantId);
        cartItems.add(
          CartItemModel(
            product: product,
            quantity: quantity,
            variantId: variantId,
            variant: variant,
          ),
        );
      }
    }

    _updateTotalPrice();
    Get.dialog(DialogAddToCartSuccessWidget());
  }

  void removeFromCart(String productId, {String? variantId}) {
    cartItems.removeWhere(
      (item) => item.product.id == productId && item.variantId == variantId,
    ); // ✅ remove locally
    _updateTotalPrice(); // ✅ update total
    cartService.removeFromCart(
      productId,
      variantId: variantId,
    ); // sync to supabase
  }

  void updateQuantity(String productId, int newQuantity, {String? variantId}) {
    if (newQuantity <= 0) {
      removeFromCart(productId, variantId: variantId);
      return;
    }

    final itemIndex = cartItems.indexWhere(
      (item) => item.product.id == productId && item.variantId == variantId,
    );
    if (itemIndex != -1) {
      cartItems[itemIndex].quantity = newQuantity;
      cartItems.refresh();
      _updateTotalPrice();
      cartService.updateQuantity(productId, newQuantity, variantId: variantId);
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
    _updateTotalPrice();
    isLoading(false);
  }

  bool isInCart(String productId, {String? variantId}) {
    return cartItems.any(
      (item) => item.product.id == productId && item.variantId == variantId,
    );
  }

  CartItemModel? getCartItem(String productId, {String? variantId}) {
    return cartItems.firstWhereOrNull(
      (item) => item.product.id == productId && item.variantId == variantId,
    );
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

      /// Extract product IDs and variant IDs
      final productIds = cartList
          .map((e) => e['product_id'])
          .whereType<String>()
          .toSet()
          .toList();
      final variantIds = cartList
          .map((e) => e['product_variant_id'])
          .whereType<String>()
          .toSet()
          .toList();

      dev.log("Product IDs to fetch: $productIds");
      dev.log("Variant IDs to fetch: $variantIds");

      /// Get product detail from Supabase
      final productsResponse = await cartService.client
          .from('products')
          .select()
          .filter('id', 'in', productIds);

      /// Get variant details from Supabase if any
      List<ProductVariantModel> variantModels = [];
      if (variantIds.isNotEmpty) {
        final variantsResponse = await cartService.client
            .from('product_variants')
            .select('''
              id, product_id, sku, price, stock_qty, is_active,
              animal_types(name),
              flavors(name),
              weight_options(label, weight_kg)
            ''')
            .filter('id', 'in', variantIds);
        variantModels = variantsResponse
            .map<ProductVariantModel>((v) => ProductVariantModel.fromJson(v))
            .toList();
      }

      dev.log("Products fetched: ${productsResponse.length}");
      dev.log("Variants fetched: ${variantModels.length}");

      /// Convert to ProductModel list
      final productModels = productsResponse
          .map<ProductModel>((p) => ProductModel.fromJson(p))
          .toList();

      /// Merge Cart + Product + Variant
      final cartItemsList = <CartItemModel>[];

      for (final cart in cartList) {
        final productId = cart['product_id'];
        final variantId = cart['product_variant_id'];

        final product = productModels.firstWhereOrNull(
          (p) => p.id == productId,
        );

        if (product != null) {
          final variant = variantModels.firstWhereOrNull(
            (v) => v.id == variantId,
          );

          final cartItem = CartItemModel(
            product: product,
            quantity: cart['quantity'] ?? 0,
            variantId: variantId,
            variant: variant,
          );
          cartItemsList.add(cartItem);
        }
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

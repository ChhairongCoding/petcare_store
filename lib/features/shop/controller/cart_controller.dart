import 'package:get/get.dart';
import 'package:petcare_store/features/shop/models/cart_item_model.dart';
import 'package:petcare_store/features/products/model/product_model.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(ProductModel product, {int quantity = 1}) {
    final existingItemIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex != -1) {
      // Product already in cart, increase quantity
      cartItems[existingItemIndex].quantity += quantity;
      cartItems.refresh();
    } else {
      // Add new item to cart
      cartItems.add(CartItemModel(product: product, quantity: quantity));
    }

    Get.snackbar(
      'Added to Cart',
      '${product.name} added to cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final itemIndex = cartItems.indexWhere((item) => item.product.id == productId);
    if (itemIndex != -1) {
      cartItems[itemIndex].quantity = newQuantity;
      cartItems.refresh();
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  bool isInCart(String productId) {
    return cartItems.any((item) => item.product.id == productId);
  }

  CartItemModel? getCartItem(String productId) {
    return cartItems.firstWhereOrNull((item) => item.product.id == productId);
  }
}


import 'package:get/get.dart';
import 'package:petcare_store/features/cart/models/cart_item_model.dart';
import 'package:petcare_store/features/cart/view/widgets/dialog_add_to_cart_success_widget.dart';
import 'package:petcare_store/features/products/model/product_model.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  RxInt quantity = 0.obs;
  RxDouble totalPrice = 0.0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _updateTotalPrice();
  }

  void _updateTotalPrice() {
    totalPrice.value = cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(ProductModel product, {int quantity = 1}) {
    final existingItemIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (existingItemIndex != -1) {
      cartItems[existingItemIndex].quantity += quantity;
      cartItems.refresh();
    }else{
      cartItems.add(CartItemModel(product: product, quantity: quantity));
    }
    _updateTotalPrice();
    Get.dialog(
      DialogAddToCartSuccessWidget());
  }

  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
    _updateTotalPrice();
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

  void removeAllItem(){
    isLoading(true);
    cartItems.clear();
    _updateTotalPrice();
  }

  bool isInCart(String productId) {
    return cartItems.any((item) => item.product.id == productId);
  }

  CartItemModel? getCartItem(String productId) {
    return cartItems.firstWhereOrNull((item) => item.product.id == productId);
  }
}

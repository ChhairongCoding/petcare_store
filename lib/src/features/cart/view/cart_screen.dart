import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/src/features/cart/controller/cart_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartController cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      cartController.getAllProductCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: SafeArea(child: _buildButtonProcessToCheckout()),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('My Cart'),
      actions: [
        IconButton(
          onPressed: () {
            cartController.removeAllItem();
          },
          icon: Icon(HugeIcons.strokeRoundedDelete02, color: Colors.red),
        ),
      ],
    );
  }

  _buildBody() {
    return Obx(
      () => cartController.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : cartController.cartItems.isEmpty
          ? Center(child: Text('Empty Cart'))
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: cartController.cartItems.length,
              itemBuilder: (context, index) {
                return _buildCardCart(
                  cartController.cartItems[index].product.imagePath,
                  cartController.cartItems[index].product.name,
                  cartController.cartItems[index].product.price,
                  cartController.cartItems[index].quantity,
                  index,
                  cartController,
                );
              },
            ),
    );
  }

  _buildButtonProcessToCheckout() {
    return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, ),
    child: Obx(()=> Column(
      mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Row(
            children: [
              Text(
                'Total:',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Text(
                '\$${cartController.totalPrice.value.toStringAsFixed(2)}',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cartController.totalItems == 0
                        ? Colors.blueGrey
                        : Get.theme.primaryColor,
                  ),
                  onPressed: () {
                    if (cartController.totalItems > 0) {
                      Get.toNamed('/processBuy', arguments: cartController);
                    } else {
                      Get.snackbar(
                        'Cart Empty',
                        'Please add items to your cart first',
                      );
                    }
                  },
                  label: Text('Process To Checkout'),
                  icon: Icon(HugeIcons.strokeRoundedArrowRight04, size: 30),
                  iconAlignment: IconAlignment.end,
                ),
              ),
            ],
          ),
        ],
      ),)
    );
  }

  _buildCardCart(
    String image,
    String name,
    double price,
    int quantity,
    int index,
    CartController cartController,
    // String size,
  ) {
    return Slidable(
      key: ValueKey(index),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => cartController.removeFromCart(
              cartController.cartItems[index].product.id,
            ),
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Padding(
        // ✅ Add padding
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              // ✅ Clip image
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => // ✅ Error fallback
                    Container(
                      height: 80,
                      width: 80,
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported),
                    ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              // ✅ Use Expanded instead of fixed SizedBox
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('Size: M'),
                  Text(
                    'Price: \$$price',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min, // ✅ Prevent Row from expanding
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    iconSize: 14,
                    minimumSize: Size(18, 18),
                    side: BorderSide(color: Colors.black54, width: 1),
                  ),
                  onPressed: () => cartController.updateQuantity(
                    cartController.cartItems[index].product.id,
                    quantity - 1,
                  ),
                  icon: const Icon(HugeIcons.strokeRoundedRemove01),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    quantity.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    iconSize: 14,
                    minimumSize: Size(18, 18),
                    backgroundColor: Colors.black,
                    side: BorderSide(color: Colors.black54, width: 1),
                  ),
                  onPressed: () => cartController.updateQuantity(
                    cartController.cartItems[index].product.id,
                    quantity + 1,
                  ),
                  icon: const Icon(
                    HugeIcons.strokeRoundedAdd01,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

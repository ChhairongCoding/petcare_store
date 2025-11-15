import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/features/cart/controller/cart_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
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
          : Stack(
              children: [
                cartController.cartItems.isEmpty
                    ? Center(child: Text('Empty Cart'))
                    : SizedBox(
                        child: ListView.builder(
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
                      ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    spacing: 8,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Total:',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          Text(
                            '\$${cartController.totalPrice.value}',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              label: Text('Process To Checkout'),
                              icon: Icon(
                                HugeIcons.strokeRoundedArrowRight04,
                                size: 30,
                              ),
                              iconAlignment: IconAlignment.end,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
      child: Row(
        children: [
          Image.network(image, height: 80, width: 80, fit: BoxFit.cover),
          const SizedBox(width: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2.5,
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('Size: M'),
                Text('Price: ', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          const Spacer(),
          Row(
            spacing: 6,
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
              Text(
                quantity.toString().padLeft(2, '0'),
                style: Theme.of(context).textTheme.bodyLarge,
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
    );
  }
}

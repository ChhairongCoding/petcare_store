import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/src/features/cart/controller/cart_controller.dart';
import 'package:petcare_store/src/features/cart/models/cart_item_model.dart';

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
                final item = cartController.cartItems[index];
                return _buildCardCart(
                  item: item,
                  index: index,
                  cartController: cartController,
                );
              },
            ),
    );
  }

  _buildButtonProcessToCheckout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(
        () => Column(
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
        ),
      ),
    );
  }

  _buildCardCart({
    required CartItemModel item,
    required int index,
    required CartController cartController,
  }) {
    String variantInfo = [
      if (item.variant?.animalType != null) item.variant!.animalType,
      if (item.variant?.flavor != null) item.variant!.flavor,
      if (item.variant?.weightLabel != null) item.variant!.weightLabel,
    ].join(', ');

    return Slidable(
      key: ValueKey('${item.product.id}_${item.variantId}'),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => cartController.removeFromCart(
              item.product.id,
              variantId: item.variantId,
            ),
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (item.product.imagePath.isEmpty || item.product.imagePath.endsWith('/'))
                  ? Container(
                      height: 80,
                      width: 80,
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported),
                    )
                  : Image.network(
                      item.product.imagePath,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 80,
                        width: 80,
                        color: Colors.grey[200],
                        child: Icon(Icons.image_not_supported),
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (variantInfo.isNotEmpty)
                    Text(
                      variantInfo,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  Text(
                    'Price: \$${item.totalPrice}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    iconSize: 14,
                    minimumSize: Size(18, 18),
                    side: BorderSide(color: Colors.black54, width: 1),
                  ),
                  onPressed: () => cartController.updateQuantity(
                    item.product.id,
                    item.quantity - 1,
                    variantId: item.variantId,
                  ),
                  icon: const Icon(HugeIcons.strokeRoundedRemove01),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    item.quantity.toString(),
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
                    item.product.id,
                    item.quantity + 1,
                    variantId: item.variantId,
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/src/config/core/routes/app_routes.dart';
import 'package:petcare_store/src/features/products/controllers/product_controller.dart';
import 'package:petcare_store/src/features/products/model/product_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductCardWidgetCustom extends StatelessWidget {
  const ProductCardWidgetCustom({
    super.key,
    required this.products,
  });

  final ProductModel products;

  @override
  Widget build(BuildContext context) {
    final ProductController productController =
        Get.find<ProductController>();

    final screenWidth = MediaQuery.of(context).size.width;

    final crossAxisCount = screenWidth < 400
        ? 1
        : screenWidth < 700
            ? 2
            : 3;

    final cardWidth =
        (screenWidth - (16 * (crossAxisCount + 1))) / crossAxisCount;

    return Skeletonizer(
      enabled: productController.isFirstLoadRunning.value,
      child: GestureDetector(
        onTap: () => Get.toNamed(
          AppRoutes.productDetail,
          arguments: products,
        ),
        child: SizedBox(
          width: cardWidth,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// IMAGE
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        products.imagePath.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: products.imagePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.grey[400],
                                      size: 40,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey[400],
                                      size: 40,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey[400],
                                    size: 40,
                                  ),
                                ),
                              ),
            
                        /// FAVORITE BUTTON
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              HugeIcons.strokeRoundedFavourite,
                              color: Colors.grey[600],
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            
                const SizedBox(height: 8),
            
                /// PRODUCT NAME
                Text(
                  products.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                ),
            
                const SizedBox(height: 4),
            
                /// RATING
                Row(
                  children: [
                    Icon(
                      HugeIcons.strokeRoundedStar,
                      color: Colors.amber,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        "4.5",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ),
                  ],
                ),
            
                const SizedBox(height: 6),
            
                /// PRICE + BUTTON
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "\$${products.price}",
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
            
                    const SizedBox(width: 8),
            
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F7C5B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: const Icon(
                          HugeIcons.strokeRoundedAdd01,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
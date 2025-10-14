import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ProductCardWidgetCustom extends StatelessWidget {
  const ProductCardWidgetCustom({
    super.key,
    required this.name,
    required this.price,
    required this.productImage,
  });

  final String name;
  final String price;
  final String productImage;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 32,
       padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: productImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image,
                          color: Colors.grey[400],
                          size: 40,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey[400],
                          size: 40,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
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
            SizedBox(height: 12),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedStar,
                  color: Colors.amber[600],
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  "4.5",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$$price",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(0xFF2F7C5B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: Icon(
                      HugeIcons.strokeRoundedAdd01,
                      color: Colors.white,
                      size: 16,
                    ),
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

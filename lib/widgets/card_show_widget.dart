import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CartShowWidget extends StatelessWidget {
  const CartShowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(0xff378B6F),
      ),

      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New year",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                Text(
                  "40% off",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
                Text(
                  "Bold Looks. Clean Lines.",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[200]),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    "Shop Now",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                imageUrl:
                    'https://pngfile.net/files/preview/1280x1191/4381749589022caoezzxbnp5wudmsiu93gqeple6drqpehxevx1ffnk5ljthq0ecemjqymtyedreqhozjwfvvgwakjubvzjgf4auftvpfihecb8gv.png',
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

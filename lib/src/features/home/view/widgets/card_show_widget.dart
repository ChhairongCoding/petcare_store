import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CartBannerSlider extends StatefulWidget {
  const CartBannerSlider({super.key});

  @override
  State<CartBannerSlider> createState() => _CartBannerSliderState();
}

class _CartBannerSliderState extends State<CartBannerSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  bool _isUserScrolling = false;

  final List<Map<String, String>> _banners = [
    {
      "title": "New Year",
      "subtitle": "40% OFF",
      "description": "Bold Looks. Clean Lines.",
      "image":
          "https://pngfile.net/files/preview/1280x1191/4381749589022caoezzxbnp5wudmsiu93gqeple6drqpehxevx1ffnk5ljthq0ecemjqymtyedreqhozjwfvvgwakjubvzjgf4auftvpfihecb8gv.png",
      "color": "0xff378B6F",
    },
    {
      "title": "Pet Essentials",
      "subtitle": "20% Discount",
      "description": "Best for your furry friends.",
      "image":
          "https://catadoptionteam.org/wp-content/uploads/2019/05/Adopt-Fees-nobkgrd1.png",
      "color": "0xff5A7BFF",
    },
    {
      "title": "Hot Deals",
      "subtitle": "Up to 50% OFF",
      "description": "Grab your favorites before they’re gone!",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThXuu7YuP1n94pCjusYu-Mr9h1anYIpJwoYg&s",
      "color": "0xffFF7043",
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            _isUserScrolling = true;
            _timer?.cancel();
          } else if (notification is ScrollEndNotification) {
            _isUserScrolling = false;
            _startAutoScroll();
          }
          return false;
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: _banners.length,
          onPageChanged: (page) => setState(() => _currentPage = page),
          itemBuilder: (context, index) {
            final banner = _banners[index];
            return _buildBannerCard(
              context,
              title: banner["title"]!,
              subtitle: banner["subtitle"]!,
              description: banner["description"]!,
              imageUrl: banner["image"]!,
              backgroundColor: Color(int.parse(banner["color"]!)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBannerCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required String imageUrl,
    required Color backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[200]),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Shop Now",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

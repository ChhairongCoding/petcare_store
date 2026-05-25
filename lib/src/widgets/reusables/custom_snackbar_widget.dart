import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

enum SnackbarType { success, error, warning, info }

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Defer to next frame to ensure Overlay widget is available in the widget tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        Get.showSnackbar(
          GetSnackBar(
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.transparent,
            duration: duration,
            messageText: CustomSnackbarWidget(
              title: title,
              message: message,
              type: type,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        );
      } catch (_) {
        // Silently ignore if overlay is not available yet
      }
    });
  }
}

class CustomSnackbarWidget extends StatelessWidget {
  final String title;
  final String message;
  final SnackbarType type;

  const CustomSnackbarWidget({
    super.key,
    required this.title,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    IconData icon;
    Color accentColor;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = const Color(0xFF2DCE89);
        accentColor = const Color(0xFF24A56D);
        icon = HugeIcons.strokeRoundedCheckmarkCircle01;
        break;
      case SnackbarType.error:
        backgroundColor = const Color(0xFFF5365C);
        accentColor = const Color(0xFFB32844);
        icon = HugeIcons.strokeRoundedCancelCircle;
        break;
      case SnackbarType.warning:
        backgroundColor = const Color(0xFFFB6340);
        accentColor = const Color(0xFFC04D31);
        icon = HugeIcons.strokeRoundedAlertCircle;
        break;
      case SnackbarType.info:
        backgroundColor = const Color(0xFF11CDEF);
        accentColor = const Color(0xFF0E9AB3);
        icon = HugeIcons.strokeRoundedInformationCircle;
        break;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(60, 16, 16, 16),
          height: 90,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // Bubbles decorative background
        Positioned(
          bottom: 0,
          left: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
            ),
            child: Stack(
              children: [
                _buildBubble(accentColor, 40, -10, -15),
                _buildBubble(accentColor, 20, 10, 5),
              ],
            ),
          ),
        ),
        // Top Icon
        Positioned(
          top: -15,
          left: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              radius: 18,
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ),
        ),
        // Close button
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.close, color: Colors.white70, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildBubble(Color color, double size, double bottom, double left) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.4),
        shape: BoxShape.circle,
      ),
    );
  }
}

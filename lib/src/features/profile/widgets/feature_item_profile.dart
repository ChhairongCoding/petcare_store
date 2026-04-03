import 'package:flutter/material.dart';

featureItemProfile(
    BuildContext context,
    String title,
    IconData icon,
    Color? color,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 28),
          Icon(icon, color: color, size: 35),
          SizedBox(height: 8),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
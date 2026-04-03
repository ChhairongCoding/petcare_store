 import 'package:flutter/material.dart';

GestureDetector buildItemHead(
    BuildContext context, {
    String? title,
    String? subtitle,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Text(
            title ?? "0",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          Text(
            subtitle ?? "0",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
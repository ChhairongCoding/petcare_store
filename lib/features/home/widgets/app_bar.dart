import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

buildAppBar(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 12),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl:
                    "https://img.freepik.com/freie-psd/3d-darstellung-eines-menschlichen-avatars-oder-profils_23-2150671142.jpg",
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hello, Chhairong",
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Good Morning!",
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      actions: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(
              HugeIcons.strokeRoundedNotification02,
              size: 26,
              color: Colors.grey[700],
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(
              HugeIcons.strokeRoundedShoppingCart01,
              size: 26,
              color: Colors.grey[700],
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
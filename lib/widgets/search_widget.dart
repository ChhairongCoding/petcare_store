import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(HugeIcons.strokeRoundedSearch01,color: Colors.grey[700],),
                  onPressed: () {},
                ),
                Text(
                  "Search",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Icon(HugeIcons.strokeRoundedFilterHorizontal, color: Colors.grey[700],size: 30,),
            )
          ],
        ),
      ),
    );
  }
}

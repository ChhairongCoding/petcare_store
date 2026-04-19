import 'package:flutter/material.dart';

Widget buildSkeletonChipsWidget(
  BuildContext context,
  String title,
  List<String> items,
  String? selectedItem,
  Function(String?) onSelected, {
  bool Function(String)? isEnabled,
}) {
  if (items.isEmpty) return const SizedBox.shrink();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        children: items.map((item) {
          final selected = selectedItem == item;
          final enabled = isEnabled == null ? true : isEnabled(item);
          return ChoiceChip(
            label: Text(
              item,
              style: TextStyle(
                color: enabled ? null : Colors.grey,
              ),
            ),
            selected: selected,
            onSelected: enabled
                ? (isSelected) {
                    if (isSelected) {
                      onSelected(item);
                    } else {
                      onSelected(null);
                    }
                  }
                : null,
          );
        }).toList(),
      ),
      const SizedBox(height: 12),
    ],
  );
}

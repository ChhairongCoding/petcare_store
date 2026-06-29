import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/src/config/core/routes/app_routes.dart';
import 'package:petcare_store/src/features/notification/controller/notification_page_controller.dart';
import 'package:petcare_store/src/features/notification/models/notification_model.dart';
import 'package:petcare_store/src/widgets/reusables/custom_button.dart';

class NotificationScreen extends GetView<NotificationPageController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              HugeIcons.strokeRoundedArrowLeft01,
              color: Colors.black87,
              size: 20,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            if (controller.notifications.isEmpty)
              return const SizedBox.shrink();
            return PopupMenuButton<String>(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
              surfaceTintColor: Colors.white,
              onSelected: (value) {
                if (value == 'read_all') {
                  controller.markAllAsRead();
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('All notifications marked as read'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: colorScheme.primary.withValues(
                        alpha: 0.9,
                      ),
                    ),
                  );
                } else if (value == 'clear_all') {
                  _showClearAllDialog(context);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'read_all',
                  child: Row(
                    children: [
                      Icon(Icons.done_all_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Mark all as read'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_sweep_rounded,
                        size: 18,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8),
                      Text('Clear all', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            );
          }),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          _buildFilterTabs(context),
          Expanded(
            child: Obx(() {
              final list = controller.filteredNotifications;
              if (list.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildNotificationList(context, list);
            }),
          ),
        ],
      ),
    );
  }

  // Horizontal filter tabs with badges
  Widget _buildFilterTabs(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filters = [
      {'key': 'all', 'label': 'All'},
      {'key': 'order', 'label': 'Orders'},
      {'key': 'reminder', 'label': 'Reminders'},
      {'key': 'promo', 'label': 'Promos'},
    ];

    return Container(
      height: 54,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final key = filter['key']!;
          final label = filter['label']!;

          return Obx(() {
            final isSelected = controller.activeFilter.value == key;
            final count = controller.countByType(key);

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                    if (count > 0) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.25)
                              : colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    controller.activeFilter.value = key;
                  }
                },
                selectedColor: colorScheme.primary,
                backgroundColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide.none,
                showCheckmark: false,
              ),
            );
          });
        },
      ),
    );
  }

  // Notifications List View with Slidable / Dismissible items
  Widget _buildNotificationList(
    BuildContext context,
    List<NotificationModel> list,
  ) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final notif = list[index];
        return Dismissible(
          key: Key(notif.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              HugeIcons.strokeRoundedDelete02,
              color: Colors.red[700],
              size: 24,
            ),
          ),
          onDismissed: (direction) {
            controller.deleteNotification(notif.id);
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Notification dismissed"),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: "Undo",
                  textColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    controller.addNotification(
                      title: notif.title,
                      body: notif.body,
                      type: notif.type,
                      payload: notif.payload,
                    );
                  },
                ),
              ),
            );
          },
          child: _buildNotificationCard(context, notif),
        );
      },
    );
  }

  // Elegant notification card design
  Widget _buildNotificationCard(BuildContext context, NotificationModel notif) {
    final colorScheme = Theme.of(context).colorScheme;
    IconData icon;
    Color iconColor;
    Color bgColor;

    // Categorize styling
    switch (notif.type) {
      case 'order':
        icon = HugeIcons.strokeRoundedShoppingBag01;
        iconColor = Colors.green[700]!;
        bgColor = Colors.green[50]!;
        break;
      case 'reminder':
        icon = HugeIcons.strokeRoundedCalendar03;
        iconColor = Colors.purple[700]!;
        bgColor = Colors.purple[50]!;
        break;
      case 'promo':
        icon = HugeIcons.strokeRoundedPercent;
        iconColor = Colors.orange[700]!;
        bgColor = Colors.orange[50]!;
        break;
      default:
        icon = HugeIcons.strokeRoundedNotification03;
        iconColor = Colors.blue[700]!;
        bgColor = Colors.blue[50]!;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notif.isRead
            ? Colors.white
            : colorScheme.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notif.isRead
              ? Colors.grey[100]!
              : colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            controller.markAsRead(notif.id);
            _handleDeepLink(notif);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Logo with small category icon badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[200]!, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/icons/logo/app_logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            HugeIcons.strokeRoundedNotification03,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Icon(icon, color: iconColor, size: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notif.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: notif.isRead
                                    ? FontWeight.w600
                                    : FontWeight.w700,
                                color: notif.isRead
                                    ? Colors.black87
                                    : Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTimeAgo(notif.timestamp),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notif.body,
                        style: TextStyle(
                          fontSize: 12,
                          color: notif.isRead
                              ? Colors.grey[600]
                              : Colors.grey[800],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Red dot for unread status
                if (!notif.isRead) ...[
                  const SizedBox(width: 8),
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Stunning empty state design
  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    HugeIcons.strokeRoundedNotification03,
                    color: colorScheme.primary,
                    size: 44,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 15,
                child: Icon(
                  HugeIcons.strokeRoundedStar,
                  color: colorScheme.secondary,
                  size: 24,
                ),
              ),
              Positioned(
                bottom: 15,
                left: 10,
                child: Icon(
                  Icons.pets,
                  color: colorScheme.primary.withValues(alpha: 0.4),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            "No Notifications Yet",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "We'll notify you when your orders ship, bookings get confirmed, or when special pet care deals drop!",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          CustomButton(
            onPressed: () {
              Get.until((route) => Get.currentRoute == AppRoutes.mainScreen);
            },
            icon: const Icon(HugeIcons.strokeRoundedShoppingBag01, size: 18, color: Colors.white),
            label: "Explore Pet Care Shop",
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  // Clear all confirmation dialog
  void _showClearAllDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Clear All Notifications?",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          "This will permanently delete all of your notification history. This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              controller.clearAll();
              Get.back();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Clear All"),
          ),
        ],
      ),
    );
  }

  // Handle deep-linking navigation when a notification card is tapped
  void _handleDeepLink(NotificationModel notif) {
    switch (notif.type) {
      case 'order':
        Get.toNamed(AppRoutes.myorders);
        break;
      case 'reminder':
        Get.toNamed(AppRoutes.myBookings);
        break;
      case 'promo':
        Get.toNamed(AppRoutes.shopScreen);
        break;
      default:
        // Regular click on a general notification, just stay on page (already marked read)
        break;
    }
  }

  // Premium helper for time-ago formatting
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.isNegative) {
      return 'Just now';
    }
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}';
    }
  }
}

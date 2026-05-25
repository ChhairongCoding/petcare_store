import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/src/features/reminder_views/controller/reminder_controller.dart';
import 'package:petcare_store/src/features/reminder_views/view/views/widgets/card_reminder_widget.dart';
import 'package:petcare_store/src/features/reminder_views/view/views/widgets/reminders_add_form.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  late final ReminderController reminderController;

  @override
  void initState() {
    super.initState();
    reminderController = Get.find<ReminderController>();
    reminderController.fetchReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(context),
      body: Obx(() {
        final isLoading = reminderController.isLoading.value;
        final hasData = reminderController.reminders.isNotEmpty;
        return Skeletonizer(
          enabled: isLoading && !hasData,
          child: Column(
            children: [
              _buildSummaryHeader(context),
              Expanded(child: _buildReminderList()),
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
  return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Text(
        'Pet Reminders',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Material(
            color: Colors.grey.withValues(alpha: 0.1),
            shape: const CircleBorder(),
            child: IconButton(
              icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
              onPressed: _openAddReminderModal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upcoming Tasks',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    '${reminderController.reminders.where((r) => !r.isCompleted).length} Active',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              HugeIcons.strokeRoundedCalendar03,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderList() {
    return Obx(() {
      if (reminderController.isLoading.value &&
          reminderController.reminders.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (reminderController.errorMessage.value != null) {
        return _ErrorState(
          message: reminderController.errorMessage.value!,
          onRetry: reminderController.fetchReminders,
        );
      }

      final reminders = reminderController.reminders;

      if (reminders.isEmpty) {
        return RefreshIndicator(
          onRefresh: reminderController.fetchReminders,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [SizedBox(height: 60), _EmptyState()],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: reminderController.fetchReminders,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            final reminder = reminders[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CardReminderWidget(
                reminder: reminder,
                onToggleComplete: () =>
                    reminderController.toggleCompletion(reminder),
                onDelete: () => reminderController.deleteReminder(reminder),
              ),
            );
          },
        ),
      );
    });
  }

  void _openAddReminderModal() {
    Get.bottomSheet(
      const RemindersAddForm(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enterBottomSheetDuration: const Duration(milliseconds: 300),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                color: Colors.red[400],
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Something went wrong while fetching your reminders. Please try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              HugeIcons.strokeRoundedCalendar03,
              size: 80,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Keep your pet healthy',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Schedule vaccinations, appointments and grooming to get timely notifications.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/features/reminder_views/controller/reminder_controller.dart';
import 'package:petcare_store/features/reminder_views/view/views/widgets/card_reminder_widget.dart';
import 'package:petcare_store/features/reminder_views/view/views/widgets/reminders_add_form.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Reminders'),
      ),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingButton(),
    );
  }

  Widget _buildFloatingButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: FloatingActionButton.extended(
        onPressed: _openAddReminderModal,
        icon: const Icon(Icons.add),
        label: const Text('Add reminder'),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Expanded(child: _buildReminderList())],
      ),
    );
  }

  Widget _buildReminderList() {
    return Obx(() {
      if (reminderController.isLoading.value) {
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
            children: const [SizedBox(height: 40), _EmptyState()],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: reminderController.fetchReminders,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: reminders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final reminder = reminders[index];
            return CardReminderWidget(
              reminder: reminder,
              onToggleComplete: () =>
                  reminderController.toggleCompletion(reminder),
              onDelete: () => reminderController.deleteReminder(reminder),
            );
          },
        ),
      );
    });
  }

  void _openAddReminderModal() {
    Get.bottomSheet(_addFormReminderModal(context), isScrollControlled: true);
  }

  Widget _addFormReminderModal(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          color: Theme.of(context).canvasColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Add New Reminder",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Divider(color: Colors.grey[600], thickness: 0.5),
              const SizedBox(height: 8),
              const RemindersAddForm(),
            ],
          ),
        ),
      ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off, color: Colors.grey[600], size: 48),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.pets, color: Colors.grey[500], size: 72),
        const SizedBox(height: 12),
        Text(
          'No reminders yet',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'Tap the add button to schedule your first reminder.',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

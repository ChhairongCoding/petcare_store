import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/features/reminder_views/controller/reminder_controller.dart';
import 'package:petcare_store/features/reminder_views/widgets/card_reminder_widget.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      floatingActionButton: _buildFloatingButton(),
    );
  }

  _buildFloatingButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80), // space from bottom
      child: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Add reminder'),
      ),
    );
  }

  _buildBody(BuildContext context) {
    final ReminderController reminderController =
        Get.find<ReminderController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          Text(
            'Hello 👋',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
          ),
          Text(
            'Do not forget to take your medicine today.',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontSize: 26, height: 1.2),
          ),
          SizedBox(height: 16),
          Text(
            "Today's reminders",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
          ),
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => CardReminderWidget(
                controller: reminderController,
                index: index,
              ),
              itemCount: reminderController.listReminder.length,
            ),
          ),
        ],
      ),
    );
  }
}

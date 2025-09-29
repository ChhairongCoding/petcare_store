import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/features/reminder_views/controller/reminder_controller.dart';

class CardReminderWidget extends StatelessWidget {
  const CardReminderWidget({
    super.key,
    required this.controller,
    required this.index,
  });

  final ReminderController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final reminder = controller.listReminder[index];
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(reminder.icon, color: Colors.green[700], size: 40),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.time.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 26),
                        ),
                        Text(
                          reminder.title.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ],
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    activeColor: Colors.green[700],
                    value: reminder.isCheck,
                    onChanged: (_) => controller.changeCheck(index),
                  ),
                ),
              ],
            ),
            if (reminder.isCheck)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Mark as done in 8:07',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey[800],
                        ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:petcare_store/features/reminder_views/models/reminder_model.dart';

class CardReminderWidget extends StatelessWidget {
  const CardReminderWidget({
    super.key,
    required this.reminder,
    required this.onToggleComplete,
  });

  final ReminderModel reminder;
  final VoidCallback onToggleComplete;

  @override
  Widget build(BuildContext context) {
    final scheduled = reminder.reminderDate?.toLocal();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: reminder.isCompleted ? Colors.green[50] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.alarm,
                    color: reminder.isCompleted
                        ? Colors.green[600]
                        : Colors.green[700],
                    size: 36,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatTime(scheduled),
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontSize: 24, height: 1.2),
                      ),
                      Text(
                        reminder.title,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
              Checkbox(
                value: reminder.isCompleted,
                activeColor: Colors.green[700],
                onChanged: (_) => onToggleComplete(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            scheduled != null
                ? _formatDate(scheduled)
                : 'No schedule selected',
            style: theme.textTheme.titleSmall
                ?.copyWith(color: Colors.grey[700], fontWeight: FontWeight.w500),
          ),
          if (reminder.reminderType != null &&
              reminder.reminderType!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Chip(
              backgroundColor: Colors.green[100],
              label: Text(
                reminder.reminderType!,
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: Colors.green[900]),
              ),
            ),
          ],
          if (reminder.description != null &&
              reminder.description!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              reminder.description!,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.grey[800], height: 1.4),
            ),
          ],
          if (reminder.isCompleted) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Completed',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: Colors.green[800]),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

String _formatTime(DateTime? dateTime) {
  if (dateTime == null) return '--:--';
  final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}

String _formatDate(DateTime dateTime) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
}

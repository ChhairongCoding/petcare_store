import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/src/features/reminder_views/models/reminder_model.dart';
import 'package:intl/intl.dart';

class CardReminderWidget extends StatelessWidget {
  const CardReminderWidget({
    super.key,
    required this.reminder,
    required this.onToggleComplete,
    required this.onDelete,
  });

  final ReminderModel reminder;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheduled = reminder.reminderDate?.toLocal();
    final theme = Theme.of(context);
    final isDone = reminder.isCompleted;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (_) => onDelete(),
                backgroundColor: const Color(0xFFFFEBEB),
                foregroundColor: Colors.redAccent,
                icon: HugeIcons.strokeRoundedDelete02,
                label: 'Delete',
              ),
            ],
          ),
          child: InkWell(
            onTap: onToggleComplete,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildTypeIcon(context),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                reminder.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDone ? Colors.grey : Colors.black87,
                                  decoration: isDone ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                            _buildStatusBadge(context),
                          ],
                        ),
                        if (reminder.description != null && reminder.description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 8),
                            child: Text(
                              reminder.description!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        else
                          const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildInfoChip(
                              context,
                              HugeIcons.strokeRoundedCalendar03,
                              scheduled != null ? DateFormat('MMM dd, yyyy').format(scheduled) : 'No date',
                            ),
                            const SizedBox(width: 12),
                            _buildInfoChip(
                              context,
                              HugeIcons.strokeRoundedClock01,
                              scheduled != null ? DateFormat('hh:mm a').format(scheduled) : '--:--',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon(BuildContext context) {
    final type = (reminder.reminderType ?? '').toLowerCase();
    IconData icon;
    Color color;

    if (type.contains('vaccin')) {
      icon = HugeIcons.strokeRoundedNote01; // Using verified icons
      color = Colors.blue;
    } else if (type.contains('groom')) {
      icon = Icons.content_cut;
      color = Colors.purple;
    } else if (type.contains('food') || type.contains('eat')) {
      icon = Icons.restaurant;
      color = Colors.orange;
    } else if (type.contains('walk')) {
      icon = Icons.directions_walk;
      color = Colors.green;
    } else {
      icon = HugeIcons.strokeRoundedNote01;
      color = Theme.of(context).primaryColor;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: reminder.isCompleted ? Colors.grey[100] : color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        size: 26,
        color: reminder.isCompleted ? Colors.grey : color,
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final isDone = reminder.isCompleted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDone ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDone ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
        ),
      ),
      child: Text(
        isDone ? 'COMPLETED' : 'UPCOMING',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isDone ? Colors.green[700] : Colors.orange[700],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[400]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

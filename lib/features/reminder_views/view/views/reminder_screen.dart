import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/features/reminder_views/controller/reminder_controller.dart';
import 'package:petcare_store/features/reminder_views/view/views/widgets/card_reminder_widget.dart';
import 'package:petcare_store/widgets/text_form_field_widgets.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  late final ReminderController reminderController;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  DateTime? _selectedDateTime;
  final ValueNotifier<DateTime?> _scheduleNotifier = ValueNotifier<DateTime?>(
    null,
  );
  final ValueNotifier<bool> _scheduleErrorNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    reminderController = Get.find<ReminderController>();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _typeController.dispose();
    _scheduleNotifier.dispose();
    _scheduleErrorNotifier.dispose();
    super.dispose();
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
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    _typeController.clear();
    _selectedDateTime = null;
    _scheduleNotifier.value = null;
    _scheduleErrorNotifier.value = false;

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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormFieldWidget(
                      hintText: "Enter reminder title",
                      label: "Title",
                      controller: _titleController,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Add details about this reminder',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormFieldWidget(
                      hintText: "Medication, grooming, vet visit...",
                      label: "Reminder type",
                      controller: _typeController,
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickDateTime,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _scheduleErrorNotifier,
                        builder: (context, showError, _) {
                          return ValueListenableBuilder<DateTime?>(
                            valueListenable: _scheduleNotifier,
                            builder: (context, scheduled, __) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Schedule',
                                  errorText: showError && scheduled == null
                                      ? 'Please choose a date and time'
                                      : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today_outlined),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        scheduled != null
                                            ? _formatDateTime(scheduled)
                                            : 'Select date & time',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: scheduled != null
                                                  ? null
                                                  : Colors.grey[600],
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      final isSubmitting =
                          reminderController.isSubmitting.value;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : _submitReminderForm,
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text('Save Reminder'),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final initialDate = _selectedDateTime ?? now;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );

    if (!mounted) return;

    if (date == null) return;

    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? now),
    );

    if (!mounted) return;

    if (timeOfDay == null) return;

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    _selectedDateTime = selected;
    _scheduleNotifier.value = selected;
    _scheduleErrorNotifier.value = false;
  }

  Future<void> _submitReminderForm() async {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    if (_selectedDateTime == null) {
      _scheduleErrorNotifier.value = true;
      return;
    }

    final success = await reminderController.addReminder(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      reminderType: _typeController.text.trim().isEmpty
          ? null
          : _typeController.text.trim(),
      reminderDate: _selectedDateTime,
    );

    if (!mounted) return;

    if (success) {
      Get.back();
      Get.snackbar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        colorText: Colors.white,
        'Success',
        'Reminder added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else if (reminderController.errorMessage.value != null) {
      Get.snackbar(
        backgroundColor: Theme.of(context).colorScheme.error,
        colorText: Colors.white,
        'Error',
        reminderController.errorMessage.value!,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '${months[local.month - 1]} ${local.day}, ${local.year} at $hour:$minute $period';
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

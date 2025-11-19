import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/features/my_pet/controller/my_pet_controller.dart';
import 'package:petcare_store/features/my_pet/models/pet_model.dart';
import 'package:petcare_store/features/reminder_views/controller/reminder_controller.dart';
import 'package:petcare_store/widgets/text_form_field_widgets.dart';

class RemindersAddForm extends StatefulWidget {
  const RemindersAddForm({super.key});

  @override
  State<RemindersAddForm> createState() => _RemindersAddFormState();
}

class _RemindersAddFormState extends State<RemindersAddForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _reminderTypeController = TextEditingController();
  DateTime? _selectedDate;
  final RxnString _selectedPetId = RxnString();

  final ReminderController _reminderController = Get.find<ReminderController>();
  final MyPetController _myPetController = Get.find<MyPetController>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _reminderTypeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  List<PetModel> get _pets {
    return _myPetController.pets;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _reminderController.addReminder(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      reminderType: _reminderTypeController.text.trim().isEmpty ? null : _reminderTypeController.text.trim(),
      reminderDate: _selectedDate,
      petId: _selectedPetId.value,
    );

    if (success) {
      Get.back();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Reminder added successfully')),
      );
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text(_reminderController.errorMessage.value ?? 'Failed to add reminder')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormFieldWidget(
            label: 'Title',
            controller: _titleController,
            hintText: 'Enter reminder title',
          ),
          const SizedBox(height: 16),
          TextFormFieldWidget(
            label: 'Description',
            controller: _descriptionController,
            hintText: 'Enter reminder description (optional)',
          ),
          const SizedBox(height: 16),
          TextFormFieldWidget(
            label: 'Reminder Type',
            controller: _reminderTypeController,
            hintText: 'e.g., Vaccination, Grooming (optional)',
          ),
          const SizedBox(height: 16),
          // Date Picker
          InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Reminder Date',
                hintText: 'Select date',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(width: 0.5, color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(width: 2, color: Colors.grey),
                ),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              child: Text(
                _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Select date',
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Pet Dropdown
          Obx(() {
            final pets = _pets;
            return DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select pet',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(width: 0.5, color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(width: 2, color: Colors.grey),
                ),
              ),
              value: _selectedPetId.value,
              hint: const Text('Choose a pet'),
              items: pets.map((pet) {
                return DropdownMenuItem<String>(
                  value: pet.id,
                  child: Text(pet.name),
                );
              }).toList(),
              onChanged: (value) => _selectedPetId.value = value,
            );
          }),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Obx(() {
              return ElevatedButton(
                onPressed: _reminderController.isSubmitting.value ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _reminderController.isSubmitting.value
                    ? const CircularProgressIndicator()
                    : const Text('Add Reminder'),
              );
            }),
          ),
        ],
      ),
    );
  }
}

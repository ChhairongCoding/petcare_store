import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:petcare_store/src/features/reminder_views/models/reminder_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class ReminderController extends GetxController {
  final _client = Supabase.instance.client;

  final RxList<ReminderModel> reminders = <ReminderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final Rxn<String> errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetchReminders();
  }

  Future<void> fetchReminders() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      errorMessage.value = 'User is not authenticated.';
      reminders.clear();
      return;
    }

    try {
      isLoading(true);
      errorMessage.value = null;

      final List<dynamic> response = await _client
          .from('reminders')
          .select()
          .eq('user_id', user.id)
          .order('reminder_date', ascending: true);

      final fetched = response
          .map((item) => ReminderModel.fromJson(
              Map<String, dynamic>.from(item as Map<String, dynamic>)))
          .toList();

      reminders.assignAll(fetched);
    } on PostgrestException catch (e, stack) {
      developer.log('PostgREST fetch error', error: e, stackTrace: stack);
      errorMessage.value = e.message;
    } on SocketException catch (e, stack) {
      developer.log('Network error fetching reminders', error: e, stackTrace: stack);
      errorMessage.value = 'No internet connection. Pull to retry.';
    } catch (e, stack) {
      developer.log('Failed to fetch reminders', error: e, stackTrace: stack);
      errorMessage.value = 'Unable to load reminders right now.';
    } finally {
      isLoading(false);
    }
  }

  Future<bool> addReminder({
    required String title,
    String? description,
    String? reminderType,
    DateTime? reminderDate,
    String? petId,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      errorMessage.value = 'User is not authenticated.';
      return false;
    }

    try {
      isSubmitting(true);
      final payload = <String, dynamic>{
        'user_id': user.id,
        'title': title,
        'description': description,
        'reminder_type': reminderType,
        'reminder_date': reminderDate?.toUtc().toIso8601String(),
        'is_completed': false,
      };

      if (petId != null && petId.isNotEmpty) {
        payload['pet_id'] = petId;
      }

      final Map<String, dynamic> response = await _client
          .from('reminders')
          .insert(payload)
          .select()
          .single();

      reminders.insert(
        0,
        ReminderModel.fromJson(Map<String, dynamic>.from(response)),
      );
      return true;
    } on PostgrestException catch (e, stack) {
      developer.log('PostgREST insert error', error: e, stackTrace: stack);
      errorMessage.value = e.message;
      return false;
    } on SocketException catch (e, stack) {
      developer.log('Network error adding reminder', error: e, stackTrace: stack);
      errorMessage.value = 'No internet connection. Please try again.';
      return false;
    } catch (e, stack) {
      developer.log('Failed to add reminder', error: e, stackTrace: stack);
      errorMessage.value = 'Could not add reminder. Please try again.';
      return false;
    } finally {
      isSubmitting(false);
    }
  }

  Future<void> toggleCompletion(ReminderModel reminder) async {
    try {
      final Map<String, dynamic> updated = await _client
          .from('reminders')
          .update({'is_completed': !reminder.isCompleted})
          .eq('id', reminder.id)
          .select()
          .single();

      final updatedReminder =
          ReminderModel.fromJson(Map<String, dynamic>.from(updated));
      final index =
          reminders.indexWhere((existing) => existing.id == reminder.id);
      if (index != -1) {
        reminders[index] = updatedReminder;
      }
    } on PostgrestException catch (e, stack) {
      developer.log('PostgREST update error', error: e, stackTrace: stack);
      errorMessage.value = e.message;
    } on SocketException catch (e, stack) {
      developer.log('Network error updating reminder', error: e, stackTrace: stack);
      errorMessage.value = 'No internet connection. Please try again.';
    } catch (e, stack) {
      developer.log('Failed to toggle reminder', error: e, stackTrace: stack);
      errorMessage.value = 'Unable to update reminder.';
    }
  }

  Future<void> deleteReminder(ReminderModel reminder) async {
    try {
      await _client.from('reminders').delete().eq('id', reminder.id);
      reminders.removeWhere((existing) => existing.id == reminder.id);
    } on PostgrestException catch (e, stack) {
      developer.log('PostgREST delete error', error: e, stackTrace: stack);
      errorMessage.value = e.message;
    } on SocketException catch (e, stack) {
      developer.log('Network error deleting reminder', error: e, stackTrace: stack);
      errorMessage.value = 'No internet connection. Please try again.';
    } catch (e, stack) {
      developer.log('Failed to delete reminder', error: e, stackTrace: stack);
      errorMessage.value = 'Unable to delete reminder.';
    }
  }
}

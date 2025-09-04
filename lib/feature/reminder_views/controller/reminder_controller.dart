import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/feature/reminder_views/models/reminder_model.dart';

class ReminderController extends GetxController {
  RxList<ReminderModel> listReminder = <ReminderModel>[
    ReminderModel(
      title: "Paracetamol",
      description: "Paracetamol",
      date: "2022-02-02",
      time: "2:00 PM",
      icon: Icons.circle,
    ),
    ReminderModel(
      title: "Grooming",
      description: "Grooming",
      date: "2022-02-02",
      time: "3:00 PM",
      icon: Icons.circle,
    ),
  ].obs;

  void changeCheck(int index) {
    final current = listReminder[index];
    listReminder[index] = current.copyWith(isCheck: !current.isCheck);
  }
}

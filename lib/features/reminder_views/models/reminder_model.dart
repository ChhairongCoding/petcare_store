import 'package:flutter/material.dart';

class ReminderModel {
  String? title;
  String? description;
  String? date;
  String? time;
  IconData? icon;
  bool isCheck;

  ReminderModel({
    this.title,
    this.description,
    this.date,
    this.time,
    this.icon,
    this.isCheck = false, // default false
  });

  ReminderModel copyWith({
    String? title,
    String? description,
    String? date,
    String? time,
    IconData? icon,
    bool? isCheck,
  }) {
    return ReminderModel(
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      icon: icon ?? this.icon,
      isCheck: isCheck ?? this.isCheck,
    );
  }
}

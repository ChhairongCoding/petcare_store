class ReminderModel {
  final String id;
  final String userId;
  final String? petId;
  final String title;
  final String? description;
  final String? reminderType;
  final DateTime? reminderDate;
  final bool isCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ReminderModel({
    required this.id,
    required this.userId,
    required this.title,
    this.petId,
    this.description,
    this.reminderType,
    this.reminderDate,
    this.isCompleted = false,
    this.createdAt,
    this.updatedAt,
  });

  ReminderModel copyWith({
    String? id,
    String? userId,
    String? petId,
    String? title,
    String? description,
    String? reminderType,
    DateTime? reminderDate,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      petId: petId ?? this.petId,
      title: title ?? this.title,
      description: description ?? this.description,
      reminderType: reminderType ?? this.reminderType,
      reminderDate: reminderDate ?? this.reminderDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return ReminderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      petId: json['pet_id'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      reminderType: json['reminder_type'] as String?,
      reminderDate: parseDate(json['reminder_date']),
      isCompleted: json['is_completed'] as bool? ?? false,
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'pet_id': petId,
      'title': title,
      'description': description,
      'reminder_type': reminderType,
      'reminder_date': reminderDate?.toIso8601String(),
      'is_completed': isCompleted,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

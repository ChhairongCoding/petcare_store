import 'dart:convert';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String type; // 'order', 'reminder', 'promo', 'general'
  bool isRead;
  final Map<String, dynamic>? payload;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.payload,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? timestamp,
    String? type,
    bool? isRead,
    Map<String, dynamic>? payload,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'isRead': isRead,
      if (payload != null) 'payload': payload,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      type: map['type'] as String? ?? 'general',
      isRead: map['isRead'] as bool? ?? false,
      payload: map['payload'] != null ? Map<String, dynamic>.from(map['payload'] as Map) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

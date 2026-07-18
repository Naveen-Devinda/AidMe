import 'package:flutter/material.dart';

class Reminder {
  final String id;
  String title;
  String? description;
  TimeOfDay time;
  String? emoji;
  bool enabled;

  Reminder({
    required this.id,
    required this.title,
    this.description,
    required this.time,
    this.emoji,
    this.enabled = false,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    final timeParts = (json['time'] as String).split(':');
    return Reminder(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      time: TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])),
      emoji: json['emoji'] as String?,
      enabled: json['enabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'time': '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
        'emoji': emoji,
        'enabled': enabled,
      };
}

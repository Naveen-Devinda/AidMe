import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RecentActivityEntry {
  final String title;
  final DateTime timestamp;

  RecentActivityEntry({required this.title, required this.timestamp});

  String get formattedTime {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(timestamp.year, timestamp.month, timestamp.day);

    String dateStr;
    if (date == today) {
      dateStr = 'Today';
    } else if (date == yesterday) {
      dateStr = 'Yesterday';
    } else {
      dateStr =
          '${timestamp.day} ${_monthAbbr(timestamp.month)} ${timestamp.year}';
    }
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final amPm = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '$dateStr at $hour:$minute $amPm';
  }

  String _monthAbbr(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  factory RecentActivityEntry.fromJson(Map<String, dynamic> json) =>
      RecentActivityEntry(
        title: json['title'] as String,
        timestamp:
            DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      );
}

class RecentActivityService {
  static const _key = 'recent_activities';

  static Future<List<RecentActivityEntry>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((e) => RecentActivityEntry.fromJson(
            Map<String, dynamic>.from(jsonDecode(e))))
        .toList();
  }

  static Future<void> add(String title) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final entry = RecentActivityEntry(title: title, timestamp: DateTime.now());
    raw.insert(0, jsonEncode(entry.toJson()));
    if (raw.length > 10) raw.removeLast();
    await prefs.setStringList(_key, raw);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

import 'package:aidme/models/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WellnessService {
  static const String _keyActivityLogs = "wellness_activity_logs";
  static const String _keyReminders = "wellness_reminders";

  // Calculate Health Scores
  // Mental: mood & sleep & stress level & screen time
  // Physical: water, sleep, exercise, food (healthy vs junk)
  static Map<String, double> calculateDailyHealthScore({
    required String mood,
    required double sleepHours,
    required double waterMl,
    required double exerciseMin,
    required String eatingHabit,
    required double screenTimeHours,
    required String stressLevel,
  }) {
    // Mental Score Calculation
    double moodPoints = 70;
    if (mood == "Happy") {
      moodPoints = 100;
    } else if (mood == "Calm")
      moodPoints = 90;
    else if (mood == "Tired")
      moodPoints = 50;
    else if (mood == "Sad")
      moodPoints = 40;
    else if (mood == "Stressed")
      moodPoints = 30;

    double stressPoints = 50;
    if (stressLevel == "Low") {
      stressPoints = 100;
    } else if (stressLevel == "Medium")
      stressPoints = 65;
    else if (stressLevel == "High")
      stressPoints = 30;

    double sleepMentalPoints = 50;
    if (sleepHours >= 7 && sleepHours <= 9) {
      sleepMentalPoints = 100;
    } else if (sleepHours >= 6)
      sleepMentalPoints = 80;
    else if (sleepHours > 4)
      sleepMentalPoints = 50;
    else
      sleepMentalPoints = 20;

    double screenTimePoints = 100 - (screenTimeHours * 10).clamp(0, 70);

    double mentalScore =
        (moodPoints * 0.4) +
        (stressPoints * 0.3) +
        (sleepMentalPoints * 0.2) +
        (screenTimePoints * 0.1);

    // Physical Score Calculation
    double waterPoints = (waterMl / 2000.0 * 100.0).clamp(0.0, 100.0);

    double exercisePoints = (exerciseMin / 30.0 * 100.0).clamp(0.0, 100.0);

    double sleepPhysicalPoints = sleepMentalPoints; // same scale

    double foodPoints = 50;
    if (eatingHabit == "Healthy") {
      foodPoints = 100;
    } else if (eatingHabit == "Average")
      foodPoints = 70;
    else if (eatingHabit == "Junk")
      foodPoints = 30;

    double physicalScore =
        (waterPoints * 0.3) +
        (exercisePoints * 0.3) +
        (sleepPhysicalPoints * 0.2) +
        (foodPoints * 0.2);

    return {
      "mental": double.parse(mentalScore.toStringAsFixed(1)),
      "physical": double.parse(physicalScore.toStringAsFixed(1)),
    };
  }

  static Future<void> saveDailyLog({
    required String mood,
    required double sleepHours,
    required double waterMl,
    required double exerciseMin,
    required String eatingHabit,
    required double screenTimeHours,
    required String stressLevel,
    DateTime? date,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final today = _formatDateKey(date ?? DateTime.now());

    // Calculate score
    final scores = calculateDailyHealthScore(
      mood: mood,
      sleepHours: sleepHours,
      waterMl: waterMl,
      exerciseMin: exerciseMin,
      eatingHabit: eatingHabit,
      screenTimeHours: screenTimeHours,
      stressLevel: stressLevel,
    );

    final logData = {
      "date": today,
      "mood": mood,
      "sleepHours": sleepHours,
      "waterMl": waterMl,
      "exerciseMin": exerciseMin,
      "eatingHabit": eatingHabit,
      "screenTimeHours": screenTimeHours,
      "stressLevel": stressLevel,
      "mentalScore": scores["mental"],
      "physicalScore": scores["physical"],
    };

    // Save under current date key in history list
    List<Map<String, dynamic>> logs = await getLogsHistory();
    logs.removeWhere((l) => l["date"] == today);
    logs.insert(0, logData);

    await prefs.setString(_keyActivityLogs, jsonEncode(logs));

    // Update streaks & achievements
    await _updateStreaks(logs);
  }

  static Future<List<Map<String, dynamic>>> getLogsHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyActivityLogs);
    if (data == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((l) => Map<String, dynamic>.from(l)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getTodayLog() async {
    final logs = await getLogsHistory();
    final today = _formatDateKey(DateTime.now());
    for (var log in logs) {
      if (log["date"] == today) return log;
    }
    return null;
  }

  static String _formatDateKey(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  // Streaks & Achievements calculation
  static Future<void> _updateStreaks(List<Map<String, dynamic>> logs) async {
    final prefs = await SharedPreferences.getInstance();
    if (logs.isEmpty) return;

    // Sort logs descending by date
    logs.sort((a, b) => b["date"].toString().compareTo(a["date"].toString()));

    int streak = 0;
    DateTime checkDate = DateTime.now();

    for (int i = 0; i < logs.length; i++) {
      final logDateStr = logs[i]["date"] as String;
      final expectedDateStr = _formatDateKey(checkDate);
      final expectedYesterdayStr = _formatDateKey(
        checkDate.subtract(const Duration(days: 1)),
      );

      if (logDateStr == expectedDateStr) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (logDateStr == expectedYesterdayStr) {
        if (i == 0) {
          // today is not logged yet, streak is active due to yesterday's log
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 2));
        } else {
          break;
        }
      } else {
        break;
      }
    }

    await prefs.setInt("wellness_streak", streak);

    // Total Points Logic
    int totalPoints = logs.length * 10;

    // Achievements unlocking
    if (logs.isNotEmpty) {
      await prefs.setBool("achievement_first_step", true);
    }

    if (streak >= 7) {
      await prefs.setBool("achievement_7day_streak", true);
      totalPoints += 50; // Bonus
    } else if (streak >= 3) {
      totalPoints += 20; // Bonus
    }

    await prefs.setInt("total_wellness_points", totalPoints);

    final todayLog = logs.first;
    if ((todayLog["mood"] == "Happy" || todayLog["mood"] == "Calm") &&
        todayLog["stressLevel"] == "Low") {
      await prefs.setBool("achievement_stress_free_day", true);
    }

    int healthyWaterDays = 0;
    int checkCount = logs.length > 7 ? 7 : logs.length;
    for (int i = 0; i < checkCount; i++) {
      if ((logs[i]["waterMl"] as num).toDouble() >= 2000.0) {
        healthyWaterDays++;
      }
    }
    if (healthyWaterDays >= 5) {
      await prefs.setBool("achievement_healthy_week", true);
    }
  }

  static Future<Map<String, dynamic>> getAchievementsAndStreaks() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "streak": prefs.getInt("wellness_streak") ?? 0,
      "total_points": prefs.getInt("total_wellness_points") ?? 0,
      "achievement_first_step":
          prefs.getBool("achievement_first_step") ?? false,
      "achievement_7day_streak":
          prefs.getBool("achievement_7day_streak") ?? false,
      "achievement_stress_free_day":
          prefs.getBool("achievement_stress_free_day") ?? false,
      "achievement_healthy_week":
          prefs.getBool("achievement_healthy_week") ?? false,
    };
  }

  // Reminders configuration
  static Future<Map<String, bool>> getReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyReminders);
    if (data == null) {
      return {
        "water": true,
        "medicine": false,
        "exercise": true,
        "sleep": true,
      };
    }
    try {
      final Map<String, dynamic> decoded = jsonDecode(data);
      return decoded.map((k, v) => MapEntry(k, v as bool));
    } catch (_) {
      return {
        "water": true,
        "medicine": false,
        "exercise": true,
        "sleep": true,
      };
    }
  }

  static Future<void> saveReminders(Map<String, bool> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyReminders, jsonEncode(reminders));
  }

  // New: List based custom reminders
  static const String _keyCustomReminders = "wellness_custom_reminders";
  static const String _keyRemindersLastCleared =
      "wellness_reminders_last_cleared";

  static Future<List<Reminder>> getCustomReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyCustomReminders);
    if (data == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(data) as List<dynamic>;
      return decoded
          .map((e) => Reminder.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveCustomReminders(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = reminders.map((r) => r.toJson()).toList();
    await prefs.setString(_keyCustomReminders, jsonEncode(jsonList));
  }

  // Clear enabled flags at start of a new day
  static Future<void> clearEnabledIfNewDay() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final last = prefs.getString(_keyRemindersLastCleared) ?? "";
    if (last != today) {
      final reminders = await getCustomReminders();
      for (var r in reminders) {
        r.enabled = false;
      }
      await saveCustomReminders(reminders);
      await prefs.setString(_keyRemindersLastCleared, today);
    }
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stats.dart';

class StorageService {
  static const String _statsKey = 'workout_stats';

  Future<void> saveStats(WorkoutStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, jsonEncode(stats.toJson()));
  }

  Future<WorkoutStats?> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_statsKey);
    if (statsJson != null) {
      return WorkoutStats.fromJson(jsonDecode(statsJson) as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateProgress(int minutes, int calories) async {
    final stats = await loadStats() ?? _getDefaultStats();
    final updatedStats = WorkoutStats(
      todayProgress: (stats.todayMinutes + minutes) / 60.0 * 100,
      todayMinutes: stats.todayMinutes + minutes,
      todayCalories: stats.todayCalories + calories,
      todayHeartRate: stats.todayHeartRate,
      totalAchievements: stats.totalAchievements,
      totalHours: stats.totalHours + (minutes / 60.0),
      recentWorkouts: stats.recentWorkouts,
    );
    await saveStats(updatedStats);
  }

  WorkoutStats _getDefaultStats() {
    return WorkoutStats(
      todayProgress: 75.0,
      todayMinutes: 45,
      todayCalories: 320,
      todayHeartRate: 118,
      totalAchievements: 12,
      totalHours: 18.5,
      recentWorkouts: [
        WorkoutHistory(
          title: '户外跑步',
          time: '昨天, 18:00',
          value: '5.2 km',
          icon: 'map',
        ),
        WorkoutHistory(
          title: '燃脂训练',
          time: '昨天, 18:00',
          value: '350 kcal',
          icon: 'flame',
        ),
      ],
    );
  }
}

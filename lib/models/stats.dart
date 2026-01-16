class WorkoutStats {
  final double todayProgress;
  final int todayMinutes;
  final int todayCalories;
  final int todayHeartRate;
  final int totalAchievements;
  final double totalHours;
  final List<WorkoutHistory> recentWorkouts;

  WorkoutStats({
    required this.todayProgress,
    required this.todayMinutes,
    required this.todayCalories,
    required this.todayHeartRate,
    required this.totalAchievements,
    required this.totalHours,
    required this.recentWorkouts,
  });

  Map<String, dynamic> toJson() {
    return {
      'todayProgress': todayProgress,
      'todayMinutes': todayMinutes,
      'todayCalories': todayCalories,
      'todayHeartRate': todayHeartRate,
      'totalAchievements': totalAchievements,
      'totalHours': totalHours,
      'recentWorkouts': recentWorkouts.map((w) => w.toJson()).toList(),
    };
  }

  factory WorkoutStats.fromJson(Map<String, dynamic> json) {
    return WorkoutStats(
      todayProgress: (json['todayProgress'] as num).toDouble(),
      todayMinutes: json['todayMinutes'] as int,
      todayCalories: json['todayCalories'] as int,
      todayHeartRate: json['todayHeartRate'] as int,
      totalAchievements: json['totalAchievements'] as int,
      totalHours: (json['totalHours'] as num).toDouble(),
      recentWorkouts: (json['recentWorkouts'] as List)
          .map((w) => WorkoutHistory.fromJson(w as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WorkoutHistory {
  final String title;
  final String time;
  final String value;
  final String icon;

  WorkoutHistory({
    required this.title,
    required this.time,
    required this.value,
    required this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'value': value,
      'icon': icon,
    };
  }

  factory WorkoutHistory.fromJson(Map<String, dynamic> json) {
    return WorkoutHistory(
      title: json['title'] as String,
      time: json['time'] as String,
      value: json['value'] as String,
      icon: json['icon'] as String,
    );
  }
}

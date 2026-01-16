import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_icons.dart';
import '../models/workout.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;
  const WorkoutDetailScreen({super.key, required this.workout});
  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  bool _isFavorite = false;

  bool get _isCardio {
    final category = widget.workout.category.toLowerCase();
    final title = widget.workout.title.toLowerCase();
    return category.contains('cardio') || category == 'hiit' || 
           title.contains('跑步') || title.contains('慢跑') || title.contains('燃脂');
  }

  bool get _isStrength {
    final category = widget.workout.category.toLowerCase();
    return category.contains('strength') || category == '力量增肌';
  }

  bool get _isRelax {
    final category = widget.workout.category.toLowerCase();
    return category.contains('yoga') || category.contains('stretch') || 
           category.contains('meditation') || category == '保持健康';
  }

  @override
  Widget build(BuildContext context) {
    if (_isCardio) return _buildCardioLayout();
    else if (_isStrength) return _buildStrengthLayout();
    else if (_isRelax) return _buildRelaxLayout();
    return _buildDefaultLayout();
  }

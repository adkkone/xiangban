import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/workout_data.dart';
import '../widgets/quick_action_card.dart';
import 'workout_detail_screen_simple.dart';

class QuickActionsListScreen extends StatelessWidget {
  const QuickActionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quickActions = WorkoutData.getQuickActions();
    final allWorkouts = WorkoutData.getAllWorkouts();

    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.darkGray),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '快速动作',
          style: TextStyle(
            color: AppTheme.darkGray,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            '推荐动作',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 16),
          ...quickActions.map((workout) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: QuickActionCard(
                workout: workout,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutDetailScreenSimple(
                        workout: workout,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 24),
          const Text(
            '全部训练',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 16),
          ...allWorkouts.map((workout) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: QuickActionCard(
                workout: workout,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutDetailScreenSimple(
                        workout: workout,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

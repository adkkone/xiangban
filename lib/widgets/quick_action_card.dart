import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../theme/app_theme.dart';
import 'custom_icons.dart';

class QuickActionCard extends StatelessWidget {
  final Workout workout;
  final VoidCallback? onTap;

  const QuickActionCard({
    super.key,
    required this.workout,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[100]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: workout.category == 'stretch'
                    ? Colors.purple[50]
                    : Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIcons.zap(
                  size: 24,
                  color: workout.category == 'stretch'
                      ? Colors.purple
                      : Colors.blue,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${workout.description} · ${workout.duration} min',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.softGray,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[100]!, width: 2),
              ),
              child: Center(
                child: CustomIcons.chevronRight(
                  size: 16,
                  color: Colors.grey[300],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/achievement_data.dart';
import '../models/achievement.dart';
import '../widgets/custom_icons.dart';
import 'package:intl/intl.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = AchievementData.getAllAchievements();
    final unlockedAchievements = achievements.where((a) => a.isUnlocked).toList();
    final lockedAchievements = achievements.where((a) => !a.isUnlocked).toList();

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
          '成就勋章',
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
          // 统计卡片
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.vitalOrange,
                  AppTheme.vitalOrange.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.vitalOrange.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIcons.trophy(
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '已解锁 ${unlockedAchievements.length}/${achievements.length}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '继续努力，解锁更多成就！',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // 已解锁成就
          const Text(
            '已解锁',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 16),
          ...unlockedAchievements.map((achievement) => 
            _buildAchievementCard(achievement, true)
          ),
          
          const SizedBox(height: 32),
          
          // 未解锁成就
          const Text(
            '待解锁',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 16),
          ...lockedAchievements.map((achievement) => 
            _buildAchievementCard(achievement, false)
          ),
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement, bool isUnlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnlocked 
            ? AppTheme.vitalOrange.withValues(alpha: 0.2)
            : Colors.grey[200]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 图标
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isUnlocked 
                ? AppTheme.vitalOrange.withValues(alpha: 0.1)
                : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: _getIcon(
                achievement.icon,
                isUnlocked ? AppTheme.vitalOrange : Colors.grey[400]!,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // 内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        achievement.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? AppTheme.darkGray : Colors.grey[400],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isUnlocked 
                          ? AppTheme.vitalOrange.withValues(alpha: 0.1)
                          : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        achievement.category,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isUnlocked ? AppTheme.vitalOrange : Colors.grey[400],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isUnlocked ? AppTheme.softGray : Colors.grey[400],
                  ),
                ),
                
                if (isUnlocked && achievement.unlockedDate != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: AppTheme.vitalOrange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '解锁于 ${DateFormat('yyyy年M月d日').format(achievement.unlockedDate!)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.vitalOrange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                
                if (!isUnlocked) ...[
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${achievement.progress}/${achievement.target}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${((achievement.progress / achievement.target) * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: achievement.progress / achievement.target,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.vitalOrange.withValues(alpha: 0.6),
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getIcon(String iconName, Color color) {
    switch (iconName) {
      case 'star':
        return Icon(Icons.star, color: color, size: 28);
      case 'calendar':
        return Icon(Icons.calendar_today, color: color, size: 24);
      case 'flame':
        return CustomIcons.flame(size: 28, color: color);
      case 'sunrise':
        return Icon(Icons.wb_sunny, color: color, size: 28);
      case 'map':
        return CustomIcons.mapPin(size: 28, color: color);
      case 'dumbbell':
        return Icon(Icons.fitness_center, color: color, size: 28);
      case 'heart':
        return CustomIcons.heart(size: 28, color: color);
      case 'trophy':
        return CustomIcons.trophy(size: 28, color: color);
      case 'clock':
        return CustomIcons.clock(size: 28, color: color);
      case 'share':
        return Icon(Icons.share, color: color, size: 24);
      case 'check':
        return Icon(Icons.check_circle, color: color, size: 28);
      case 'apple':
        return Icon(Icons.apple, color: color, size: 28);
      default:
        return Icon(Icons.emoji_events, color: color, size: 28);
    }
  }
}

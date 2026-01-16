import 'package:flutter/material.dart';
import '../data/workout_data.dart';
import '../models/workout.dart';
import '../widgets/workout_card.dart';
import '../widgets/quick_action_card.dart';
import '../theme/app_theme.dart';
import 'workout_detail_screen_simple.dart';
import 'quick_actions_list_screen.dart';
import 'running_training_detail_screen.dart';
import 'general_training_detail_screen.dart';

class PlanView extends StatelessWidget {
  const PlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredWorkouts = WorkoutData.getFeaturedWorkouts();
    final quickActions = WorkoutData.getQuickActions();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '推荐计划',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGray,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '今天有 2 个推荐训练计划。',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.softGray,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 360,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: featuredWorkouts.length,
              itemBuilder: (context, index) {
                return WorkoutCard(
                  workout: featuredWorkouts[index],
                  onTap: () {
                    // 推荐训练使用简洁的详情页
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutDetailScreenSimple(
                          workout: featuredWorkouts[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '快速动作',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGray,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuickActionsListScreen(),
                      ),
                    );
                  },
                  child: Text(
                    '全部',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.vitalOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: quickActions.map((workout) {
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
              }).toList(),
            ),
          ),
          const SizedBox(height: 40),
          _buildTopicSection(
            context: context,
            title: '跑步特训',
            color: Colors.blue,
            cards: [
              {
                'title': '5公里挑战',
                'subtitle': '30分钟完成',
                'image': 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
              },
              {
                'title': '间歇跑训练',
                'subtitle': '提升速度',
                'image': 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
              },
              {
                'title': '长距离耐力',
                'subtitle': '10公里进阶',
                'image': 'https://images.unsplash.com/photo-1483721310020-03333e577078?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
              },
            ],
          ),
          const SizedBox(height: 32),
          _buildTopicSection(
            context: context,
            title: '保持健康',
            color: Colors.green,
            cards: [
              {
                'title': '瑜伽放松',
                'subtitle': '身心平衡',
                'image': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
              },
              {
                'title': '普拉提核心',
                'subtitle': '增强稳定',
                'image': 'https://images.unsplash.com/photo-1518611012118-696072aa579a?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
              },
              {
                'title': '拉伸恢复',
                'subtitle': '缓解疲劳',
                'image': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
              },
            ],
          ),
          const SizedBox(height: 32),
          _buildTopicSection(
            context: context,
            title: '力量增肌',
            color: Colors.purple,
            cards: [
              {
                'title': '上肢训练',
                'subtitle': '胸背肩臂',
                'image': 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
              },
              {
                'title': '下肢强化',
                'subtitle': '腿部塑形',
                'image': 'https://images.unsplash.com/photo-1434682881908-b43d0467b798?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
              },
              {
                'title': '核心力量',
                'subtitle': '腹肌训练',
                'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
              },
            ],
          ),
          const SizedBox(height: 100), // 增加底部间距，避免被导航栏遮盖
        ],
      ),
    );
  }

  Widget _buildTopicSection({
    required BuildContext context,
    required String title,
    required Color color,
    required List<Map<String, String>> cards,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return GestureDetector(
                onTap: () {
                  final workout = _createWorkoutFromCard(card, title);
                  // 跑步特训模块使用专门的详情页
                  if (title == '跑步特训') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RunningTrainingDetailScreen(
                          workout: workout,
                        ),
                      ),
                    );
                  } else if (title == '保持健康' || title == '力量增肌') {
                    // 保持健康和力量增肌使用通用训练详情页
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GeneralTrainingDetailScreen(
                          workout: workout,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutDetailScreenSimple(
                          workout: workout,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 160,
                  margin: EdgeInsets.only(right: index < cards.length - 1 ? 16 : 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Image.network(
                          card['image']!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.image, size: 40, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                card['subtitle']!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Workout _createWorkoutFromCard(Map<String, String> card, String category) {
    // 使用固定的ID映射，确保收藏功能正常工作
    final ids = {
      '5公里挑战': 'running_5k',
      '间歇跑训练': 'running_interval',
      '长距离耐力': 'running_long',
      '瑜伽放松': 'health_yoga',
      '普拉提核心': 'health_pilates',
      '拉伸恢复': 'health_stretch',
      '上肢训练': 'strength_upper',
      '下肢强化': 'strength_lower',
      '核心力量': 'strength_core',
    };
    
    final descriptions = {
      '5公里挑战': '通过科学的配速策略，在30分钟内完成5公里跑步。适合有一定跑步基础的训练者，帮助提升速度和耐力。',
      '间歇跑训练': '高强度间歇跑训练，通过快慢交替提升心肺功能和速度。每组包含冲刺和恢复阶段，有效提升跑步表现。',
      '长距离耐力': '10公里进阶训练计划，专注于提升长距离跑步的耐力和稳定性。适合准备参加长跑比赛的训练者。',
      '瑜伽放松': '温和的瑜伽流动序列，通过呼吸和体式的结合，帮助放松身心，缓解压力，提升身体柔韧性和平衡感。',
      '普拉提核心': '专注于核心肌群的普拉提训练，通过精准的动作控制，增强核心稳定性，改善体态，预防运动损伤。',
      '拉伸恢复': '全身系统拉伸训练，帮助缓解肌肉紧张和疲劳，促进血液循环，加速运动后的身体恢复。',
      '上肢训练': '针对胸部、背部、肩部和手臂的综合力量训练，使用多种训练方式，打造强壮有型的上肢肌肉。',
      '下肢强化': '腿部力量和塑形训练，包括深蹲、弓步等经典动作，提升下肢力量，塑造紧致腿部线条。',
      '核心力量': '专注于腹部核心的高强度训练，通过多角度刺激腹肌，帮助打造清晰的腹肌线条和强大的核心力量。',
    };

    final durations = {
      '5公里挑战': 30,
      '间歇跑训练': 25,
      '长距离耐力': 60,
      '瑜伽放松': 45,
      '普拉提核心': 35,
      '拉伸恢复': 20,
      '上肢训练': 40,
      '下肢强化': 35,
      '核心力量': 30,
    };

    final intensities = {
      '5公里挑战': '中等',
      '间歇跑训练': '高强度',
      '长距离耐力': '中等',
      '瑜伽放松': '低强度',
      '普拉提核心': '中等',
      '拉伸恢复': '低强度',
      '上肢训练': '高强度',
      '下肢强化': '高强度',
      '核心力量': '高强度',
    };

    return Workout(
      id: ids[card['title']] ?? card['title']!.hashCode.toString(),
      title: card['title']!,
      description: descriptions[card['title']] ?? card['subtitle']!,
      duration: durations[card['title']] ?? 30,
      intensity: intensities[card['title']] ?? '中等',
      imageUrl: card['image']!,
      category: category,
    );
  }
}

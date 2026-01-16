import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/workout_data.dart';
import '../models/workout.dart';
import '../services/favorites_service.dart';
import 'workout_detail_screen_simple.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<dynamic> _favoriteWorkouts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favService = await FavoritesService.getInstance();
    final favoriteIds = await favService.getFavoriteIds();
    
    // 获取所有训练（包括快速动作和特殊训练）
    final allWorkouts = [
      ...WorkoutData.getFeaturedWorkouts(),
      ...WorkoutData.getQuickActions(),
      ...WorkoutData.getAllWorkouts(),
      ..._getSpecialTrainingWorkouts(), // 添加跑步特训、保持健康、力量增肌
    ];
    
    // 筛选出收藏的训练
    final favorites = allWorkouts.where((workout) {
      return favoriteIds.contains(workout.id);
    }).toList();
    
    if (mounted) {
      setState(() {
        _favoriteWorkouts = favorites;
        _isLoading = false;
      });
    }
  }

  // 获取跑步特训、保持健康、力量增肌的训练数据
  List<dynamic> _getSpecialTrainingWorkouts() {
    final specialWorkouts = <Map<String, dynamic>>[];
    
    // 跑步特训
    specialWorkouts.addAll([
      {
        'id': 'running_5k',
        'title': '5公里挑战',
        'description': '通过科学的配速策略，在30分钟内完成5公里跑步。适合有一定跑步基础的训练者，帮助提升速度和耐力。',
        'duration': 30,
        'intensity': '中等',
        'image': 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'category': '跑步特训',
      },
      {
        'id': 'running_interval',
        'title': '间歇跑训练',
        'description': '高强度间歇跑训练，通过快慢交替提升心肺功能和速度。每组包含冲刺和恢复阶段，有效提升跑步表现。',
        'duration': 25,
        'intensity': '高强度',
        'image': 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'category': '跑步特训',
      },
      {
        'id': 'running_long',
        'title': '长距离耐力',
        'description': '10公里进阶训练计划，专注于提升长距离跑步的耐力和稳定性。适合准备参加长跑比赛的训练者。',
        'duration': 60,
        'intensity': '中等',
        'image': 'https://images.unsplash.com/photo-1483721310020-03333e577078?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'category': '跑步特训',
      },
    ]);
    
    // 保持健康
    specialWorkouts.addAll([
      {
        'id': 'health_yoga',
        'title': '瑜伽放松',
        'description': '温和的瑜伽流动序列，通过呼吸和体式的结合，帮助放松身心，缓解压力，提升身体柔韧性和平衡感。',
        'duration': 45,
        'intensity': '低强度',
        'image': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'category': '保持健康',
      },
      {
        'id': 'health_pilates',
        'title': '普拉提核心',
        'description': '专注于核心肌群的普拉提训练，通过精准的动作控制，增强核心稳定性，改善体态，预防运动损伤。',
        'duration': 35,
        'intensity': '中等',
        'image': 'https://images.unsplash.com/photo-1518611012118-696072aa579a?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'category': '保持健康',
      },
      {
        'id': 'health_stretch',
        'title': '拉伸恢复',
        'description': '全身系统拉伸训练，帮助缓解肌肉紧张和疲劳，促进血液循环，加速运动后的身体恢复。',
        'duration': 20,
        'intensity': '低强度',
        'image': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'category': '保持健康',
      },
    ]);
    
    // 力量增肌
    specialWorkouts.addAll([
      {
        'id': 'strength_upper',
        'title': '上肢训练',
        'description': '针对胸部、背部、肩部和手臂的综合力量训练，使用多种训练方式，打造强壮有型的上肢肌肉。',
        'duration': 40,
        'intensity': '高强度',
        'image': 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'category': '力量增肌',
      },
      {
        'id': 'strength_lower',
        'title': '下肢强化',
        'description': '腿部力量和塑形训练，包括深蹲、弓步等经典动作，提升下肢力量，塑造紧致腿部线条。',
        'duration': 35,
        'intensity': '高强度',
        'image': 'https://images.unsplash.com/photo-1434682881908-b43d0467b798?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'category': '力量增肌',
      },
      {
        'id': 'strength_core',
        'title': '核心力量',
        'description': '专注于腹部核心的高强度训练，通过多角度刺激腹肌，帮助打造清晰的腹肌线条和强大的核心力量。',
        'duration': 30,
        'intensity': '高强度',
        'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'category': '力量增肌',
      },
    ]);
    
    // 转换为Workout对象
    return specialWorkouts.map((data) {
      return Workout(
        id: data['id'] as String,
        title: data['title'] as String,
        description: data['description'] as String,
        duration: data['duration'] as int,
        intensity: data['intensity'] as String,
        imageUrl: data['image'] as String,
        category: data['category'] as String,
      );
    }).toList();
  }

  Future<void> _removeFavorite(String workoutId, int index) async {
    final favService = await FavoritesService.getInstance();
    await favService.removeFavorite(workoutId);
    
    if (mounted) {
      setState(() {
        _favoriteWorkouts.removeAt(index);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已取消收藏')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          '我的收藏',
          style: TextStyle(
            color: AppTheme.darkGray,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.vitalOrange,
              ),
            )
          : _favoriteWorkouts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '暂无收藏',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '快去收藏你喜欢的训练计划吧',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  '共 ${_favoriteWorkouts.length} 个训练计划',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ..._favoriteWorkouts.asMap().entries.map((entry) {
                  final index = entry.key;
                  final workout = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Stack(
                      children: [
                        GestureDetector(
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
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: [
                                  // 背景图片
                                  workout.imageUrl.startsWith('http')
                                      ? Image.network(
                                          workout.imageUrl,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          workout.imageUrl,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                  // 渐变遮罩
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
                                  // 内容
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          workout.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(alpha: 0.2),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '${workout.duration}分钟',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(alpha: 0.2),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                workout.intensity,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // 取消收藏按钮
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => _removeFavorite(workout.id, index),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: AppTheme.vitalOrange,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
    );
  }
}

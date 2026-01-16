import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/workout.dart';
import '../services/favorites_service.dart';
import 'running_training_session_screen.dart';

class GeneralTrainingDetailScreen extends StatefulWidget {
  final Workout workout;

  const GeneralTrainingDetailScreen({super.key, required this.workout});

  @override
  State<GeneralTrainingDetailScreen> createState() => _GeneralTrainingDetailScreenState();
}

class _GeneralTrainingDetailScreenState extends State<GeneralTrainingDetailScreen> {
  bool _isFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final favService = await FavoritesService.getInstance();
    final isFav = await favService.isFavorite(widget.workout.id);
    
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    HapticFeedback.lightImpact();
    
    final favService = await FavoritesService.getInstance();
    final newStatus = await favService.toggleFavorite(widget.workout.id);
    
    if (mounted) {
      setState(() {
        _isFavorite = newStatus;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newStatus ? '已添加到收藏' : '已取消收藏'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题
                      Text(
                        widget.workout.title,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // 核心数据卡片
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              '耗时',
                              '${widget.workout.duration}分钟',
                              Icons.schedule,
                              _getThemeColor(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              '难度',
                              widget.workout.intensity,
                              Icons.trending_up,
                              Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              '卡路里',
                              '${widget.workout.duration * 8}',
                              Icons.local_fire_department,
                              Colors.red,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      const Text(
                        '训练说明',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.workout.description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppTheme.softGray,
                          height: 1.6,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      const Text(
                        '训练器材',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildEquipmentSection(),
                      
                      const SizedBox(height: 32),
                      const Text(
                        '动作示意',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildExerciseList(),
                      
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildStartButton(),
        ],
      ),
    );
  }

  Color _getThemeColor() {
    final category = widget.workout.category.toLowerCase();
    if (category.contains('健康') || category.contains('瑜伽') || category.contains('拉伸')) {
      return Colors.green;
    } else if (category.contains('力量') || category.contains('增肌')) {
      return Colors.purple;
    }
    return Colors.blue;
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.darkGray),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : AppTheme.darkGray,
              ),
              onPressed: _isLoading ? null : _toggleFavorite,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            widget.workout.imageUrl.isNotEmpty
                ? Image.network(
                    widget.workout.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey[300]);
                    },
                  )
                : Container(color: Colors.grey[300]),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.softGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentSection() {
    final equipment = _getEquipmentList();
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: equipment.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item['icon'] as IconData, size: 20, color: _getThemeColor()),
              const SizedBox(width: 8),
              Text(
                item['name'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkGray,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExerciseList() {
    final exercises = _getExerciseList();
    
    return Column(
      children: exercises.asMap().entries.map((entry) {
        final index = entry.key;
        final exercise = entry.value;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[100]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 动作图片
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  exercise['image'] as String,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _getThemeColor().withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _getThemeColor(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            exercise['name'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      exercise['description'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildExerciseDetail(
                          Icons.repeat,
                          exercise['sets'] as String,
                          _getThemeColor(),
                        ),
                        const SizedBox(width: 20),
                        _buildExerciseDetail(
                          Icons.fitness_center,
                          exercise['reps'] as String,
                          Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExerciseDetail(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppTheme.vitalOrange.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RunningTrainingSessionScreen(
                    workout: widget.workout,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(28),
            child: const Center(
              child: Text(
                '开始训练',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getEquipmentList() {
    final title = widget.workout.title;
    final category = widget.workout.category;
    
    // 瑜伽/拉伸类
    if (title.contains('瑜伽') || title.contains('拉伸') || title.contains('普拉提')) {
      return [
        {'name': '瑜伽垫', 'icon': Icons.grid_4x4},
        {'name': '瑜伽砖', 'icon': Icons.square},
        {'name': '拉伸带', 'icon': Icons.linear_scale},
      ];
    }
    
    // 力量训练类
    if (category.contains('力量') || title.contains('上肢') || title.contains('下肢') || title.contains('核心')) {
      return [
        {'name': '哑铃', 'icon': Icons.fitness_center},
        {'name': '杠铃', 'icon': Icons.horizontal_rule},
        {'name': '训练垫', 'icon': Icons.grid_4x4},
        {'name': '阻力带', 'icon': Icons.linear_scale},
      ];
    }
    
    return [
      {'name': '瑜伽垫', 'icon': Icons.grid_4x4},
      {'name': '运动服', 'icon': Icons.checkroom},
    ];
  }

  List<Map<String, String>> _getExerciseList() {
    final title = widget.workout.title;
    
    // 瑜伽放松
    if (title.contains('瑜伽')) {
      return [
        {
          'name': '山式站立',
          'description': '双脚并拢站立，身体挺直，双臂自然垂放，感受身体的平衡和稳定。',
          'sets': '3组',
          'reps': '30秒',
          'image': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '下犬式',
          'description': '双手双脚着地，臀部向上抬起，形成倒V字形，拉伸背部和腿部肌肉。',
          'sets': '3组',
          'reps': '45秒',
          'image': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '战士式',
          'description': '前腿弯曲，后腿伸直，双臂向两侧伸展，增强腿部力量和平衡感。',
          'sets': '3组',
          'reps': '每侧30秒',
          'image': 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '婴儿式',
          'description': '跪坐在地上，上身前倾，额头触地，双臂向前伸展，放松全身。',
          'sets': '1组',
          'reps': '60秒',
          'image': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
      ];
    }
    
    // 普拉提核心
    if (title.contains('普拉提')) {
      return [
        {
          'name': '百式呼吸',
          'description': '仰卧，双腿抬起，上身微抬，双臂上下摆动，配合呼吸节奏。',
          'sets': '3组',
          'reps': '100次',
          'image': 'https://images.unsplash.com/photo-1518611012118-696072aa579a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '卷腹',
          'description': '仰卧，双手抱头，上身缓慢卷起，感受腹部肌肉收缩。',
          'sets': '4组',
          'reps': '15次',
          'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '平板支撑',
          'description': '俯卧撑姿势，用前臂支撑身体，保持身体呈一条直线。',
          'sets': '3组',
          'reps': '45秒',
          'image': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
      ];
    }
    
    // 拉伸恢复
    if (title.contains('拉伸')) {
      return [
        {
          'name': '颈部拉伸',
          'description': '缓慢转动头部，向左右两侧倾斜，放松颈部肌肉。',
          'sets': '2组',
          'reps': '每侧20秒',
          'image': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '肩部拉伸',
          'description': '双臂交叉胸前，用另一只手轻压，拉伸肩部和上背部。',
          'sets': '2组',
          'reps': '每侧30秒',
          'image': 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '腿部拉伸',
          'description': '坐姿前屈，双腿伸直，上身前倾，拉伸腿后侧肌肉。',
          'sets': '2组',
          'reps': '40秒',
          'image': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
      ];
    }
    
    // 上肢训练
    if (title.contains('上肢')) {
      return [
        {
          'name': '哑铃推举',
          'description': '站立或坐姿，双手持哑铃，从肩部向上推举至手臂伸直。',
          'sets': '4组',
          'reps': '12次',
          'image': 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '俯卧撑',
          'description': '双手撑地，身体保持一条直线，屈臂下降后推起。',
          'sets': '4组',
          'reps': '15次',
          'image': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '哑铃弯举',
          'description': '站立，双手持哑铃，屈肘将哑铃举至肩部，锻炼肱二头肌。',
          'sets': '4组',
          'reps': '12次',
          'image': 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
      ];
    }
    
    // 下肢强化
    if (title.contains('下肢')) {
      return [
        {
          'name': '深蹲',
          'description': '双脚与肩同宽，屈膝下蹲至大腿与地面平行，然后站起。',
          'sets': '4组',
          'reps': '15次',
          'image': 'https://images.unsplash.com/photo-1434682881908-b43d0467b798?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '弓步蹲',
          'description': '一腿向前迈出，屈膝下蹲，后腿膝盖接近地面。',
          'sets': '4组',
          'reps': '每腿12次',
          'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '提踵',
          'description': '站立，脚跟抬起，用脚尖支撑身体，锻炼小腿肌肉。',
          'sets': '4组',
          'reps': '20次',
          'image': 'https://images.unsplash.com/photo-1434682881908-b43d0467b798?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
      ];
    }
    
    // 核心力量
    if (title.contains('核心')) {
      return [
        {
          'name': '平板支撑',
          'description': '俯卧撑姿势，用前臂支撑身体，保持身体呈一条直线。',
          'sets': '4组',
          'reps': '60秒',
          'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '俄罗斯转体',
          'description': '坐姿，上身后仰，双脚离地，转动上身左右触地。',
          'sets': '4组',
          'reps': '20次',
          'image': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '登山者',
          'description': '俯卧撑姿势，交替将膝盖向胸部提拉，快速切换。',
          'sets': '4组',
          'reps': '30秒',
          'image': 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
      ];
    }
    
    // 燃脂训练
    if (title.contains('燃脂')) {
      return [
        {
          'name': '开合跳',
          'description': '双脚跳跃同时张开，双臂向上击掌，快速激活全身。',
          'sets': '3组',
          'reps': '30次',
          'image': 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '波比跳',
          'description': '俯卧撑后跳起，全身爆发力训练，高效燃烧卡路里。',
          'sets': '4组',
          'reps': '12次',
          'image': 'https://images.unsplash.com/photo-1601422407692-ec4eeec1d9b3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '高抬腿',
          'description': '原地快速高抬腿，提升心率，增强下肢力量。',
          'sets': '4组',
          'reps': '30秒',
          'image': 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '登山跑',
          'description': '俯卧撑姿势，快速交替提膝，核心发力保持稳定。',
          'sets': '4组',
          'reps': '45秒',
          'image': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
      ];
    }
    
    return [];
  }
}

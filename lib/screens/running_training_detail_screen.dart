import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/workout.dart';
import '../services/favorites_service.dart';
import 'running_training_session_screen.dart';

class RunningTrainingDetailScreen extends StatefulWidget {
  final Workout workout;

  const RunningTrainingDetailScreen({super.key, required this.workout});

  @override
  State<RunningTrainingDetailScreen> createState() => _RunningTrainingDetailScreenState();
}

class _RunningTrainingDetailScreenState extends State<RunningTrainingDetailScreen> {
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
                              Colors.blue,
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
                              '${widget.workout.duration * 12}',
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
              Icon(item['icon'] as IconData, size: 20, color: Colors.blue),
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
                            color: Colors.blue.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
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
                          Colors.orange,
                        ),
                        const SizedBox(width: 20),
                        _buildExerciseDetail(
                          Icons.timer,
                          exercise['duration'] as String,
                          Colors.green,
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
    
    if (title.contains('5公里') || title.contains('长距离')) {
      return [
        {'name': '跑鞋', 'icon': Icons.directions_run},
        {'name': '运动手表', 'icon': Icons.watch},
        {'name': '水壶', 'icon': Icons.water_drop},
      ];
    } else if (title.contains('间歇')) {
      return [
        {'name': '跑鞋', 'icon': Icons.directions_run},
        {'name': '运动手表', 'icon': Icons.watch},
        {'name': '计时器', 'icon': Icons.timer},
        {'name': '水壶', 'icon': Icons.water_drop},
      ];
    }
    
    return [
      {'name': '跑鞋', 'icon': Icons.directions_run},
      {'name': '运动服', 'icon': Icons.checkroom},
    ];
  }

  List<Map<String, String>> _getExerciseList() {
    final title = widget.workout.title;
    
    if (title.contains('5公里')) {
      return [
        {
          'name': '热身慢跑',
          'description': '以轻松的配速开始，逐渐提升心率，激活腿部肌肉，为正式训练做好准备。',
          'sets': '1组',
          'duration': '5分钟',
          'image': 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '匀速跑',
          'description': '保持稳定配速，控制呼吸节奏，专注于跑步姿态和步频，维持在目标配速区间。',
          'sets': '1组',
          'duration': '20分钟',
          'image': 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '放松慢跑',
          'description': '降低配速，让心率逐渐恢复，放松腿部肌肉，为训练画上完美句号。',
          'sets': '1组',
          'duration': '5分钟',
          'image': 'https://images.unsplash.com/photo-1483721310020-03333e577078?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
      ];
    } else if (title.contains('间歇')) {
      return [
        {
          'name': '热身跑',
          'description': '轻松慢跑，逐步提升体温和心率，为高强度间歇做好充分准备。',
          'sets': '1组',
          'duration': '5分钟',
          'image': 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '快速冲刺',
          'description': '以80-90%的最大速度冲刺，全力以赴，提升速度和爆发力。',
          'sets': '6组',
          'duration': '1分钟',
          'image': 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '恢复慢跑',
          'description': '在每组冲刺之间进行慢跑恢复，让心率下降，为下一组做准备。',
          'sets': '6组',
          'duration': '2分钟',
          'image': 'https://images.unsplash.com/photo-1483721310020-03333e577078?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '整理放松',
          'description': '轻松慢跑结束训练，让身体逐渐恢复到静息状态。',
          'sets': '1组',
          'duration': '5分钟',
          'image': 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
      ];
    } else if (title.contains('长距离')) {
      return [
        {
          'name': '热身准备',
          'description': '从慢跑开始，逐步提升配速，让身体适应长距离跑步的节奏。',
          'sets': '1组',
          'duration': '10分钟',
          'image': 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '稳定配速跑',
          'description': '保持舒适的配速，专注于呼吸和步频，培养长距离跑步的耐力和节奏感。',
          'sets': '1组',
          'duration': '45分钟',
          'image': 'https://images.unsplash.com/photo-1483721310020-03333e577078?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
        {
          'name': '冷却放松',
          'description': '逐渐降低速度，让心率平稳下降，帮助身体从长距离跑步中恢复。',
          'sets': '1组',
          'duration': '5分钟',
          'image': 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        },
      ];
    }
    
    return [];
  }
}

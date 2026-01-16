import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/workout.dart';
import '../services/favorites_service.dart';
import 'workout_session_screen.dart';

class WorkoutDetailScreenSimple extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailScreenSimple({super.key, required this.workout});

  @override
  State<WorkoutDetailScreenSimple> createState() => _WorkoutDetailScreenSimpleState();
}

class _WorkoutDetailScreenSimpleState extends State<WorkoutDetailScreenSimple> {
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 简洁的头部图片
              SliverAppBar(
                expandedHeight: 320,
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
                      icon: const Icon(Icons.arrow_back, color: AppTheme.darkGray, size: 20),
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
                          size: 20,
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
                          ? (widget.workout.imageUrl.startsWith('http')
                              ? Image.network(
                                  widget.workout.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(color: Colors.grey[300]);
                                  },
                                )
                              : Image.asset(
                                  widget.workout.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(color: Colors.grey[300]);
                                  },
                                ))
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
              ),
              
              // 简洁的内容区域
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
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // 描述
                      Text(
                        widget.workout.description,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // 关键数据
                      Row(
                        children: [
                          Expanded(
                            child: _buildSimpleStatCard(
                              Icons.schedule,
                              '${widget.workout.duration}',
                              '分钟',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSimpleStatCard(
                              Icons.local_fire_department,
                              '${widget.workout.duration * 8}',
                              '卡路里',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSimpleStatCard(
                              Icons.trending_up,
                              widget.workout.intensity,
                              '',
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // 训练亮点
                      const Text(
                        '训练亮点',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildHighlightItem(Icons.check_circle, '科学配速，循序渐进'),
                      const SizedBox(height: 12),
                      _buildHighlightItem(Icons.check_circle, '适合各个水平的训练者'),
                      const SizedBox(height: 12),
                      _buildHighlightItem(Icons.check_circle, '有效提升心肺功能'),
                      
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // 开始训练按钮
          _buildStartButton(),
        ],
      ),
    );
  }

  Widget _buildSimpleStatCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.offWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.vitalOrange, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          if (label.isNotEmpty)
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.successGreen, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.darkGray,
            ),
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
                  builder: (context) => WorkoutSessionScreen(
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
}

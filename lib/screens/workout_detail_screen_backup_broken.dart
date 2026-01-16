import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/workout.dart';
import 'workout_session_screen.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  bool _isFavorite = false;
  bool _showMoreInfo = false;

  bool get _isRunning {
    // 推荐训练（日落慢跑、燃脂燃烧）不使用特殊布局
    // 只有跑步特训模块的训练才使用running layout
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isRunning) {
      return _buildRunningLayout();
    }
    return _buildDefaultLayout();
  }

  Widget _buildRunningLayout() {
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
                      // 标签
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.vitalOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.directions_run, size: 16, color: AppTheme.vitalOrange),
                            const SizedBox(width: 4),
                            Text(
                              '户外跑步',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.vitalOrange),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // 标题
                      Text(
                        widget.workout.title,
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.darkGray),
                      ),
                      const SizedBox(height: 8),
                      
                      // 副标题
                      Text(
                        '在夕阳下奔跑，感受自由与活力',
                        style: TextStyle(fontSize: 15, color: Colors.grey[600], fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 24),
                      
                      // 核心数据卡片
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.vitalOrange.withValues(alpha: 0.15),
                              AppTheme.vitalOrange.withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppTheme.vitalOrange.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: _buildStatCard('时长', '${widget.workout.duration}分钟', Icons.schedule)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildStatCard('难度', widget.workout.intensity, Icons.trending_up)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(child: _buildStatCard('配速', '5:30/km', Icons.speed)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildStatCard('卡路里', '${widget.workout.duration * 10}', Icons.local_fire_department)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      const Text('训练亮点', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkGray)),
                      const SizedBox(height: 16),
                      _buildHighlights(),
                      
                      const SizedBox(height: 32),
                      const Text('推荐路线', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkGray)),
                      const SizedBox(height: 16),
                      _buildRouteCard(),
                      const SizedBox(height: 12),
                      _buildRouteDetails(),
                      
                      const SizedBox(height: 32),
                      const Text('训练说明', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkGray)),
                      const SizedBox(height: 12),
                      Text(
                        '日落时分是跑步的黄金时段，气温适宜，空气清新。通过科学的配速策略，在享受美景的同时提升跑步耐力和速度。适合有一定跑步基础的训练者，建议每周进行2-3次训练。',
                        style: const TextStyle(fontSize: 15, color: AppTheme.softGray, height: 1.6),
                      ),
                      
                      const SizedBox(height: 32),
                      _buildTipsCard(),
                      
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildStartButton('开始跑步'),
        ],
      ),
    );
  }

  Widget _buildDefaultLayout() {
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
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() => _isFavorite = !_isFavorite);
                        },
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
          _buildStartButton('开始训练'),
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
      backgroundColor: AppTheme.offWhite,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() => _isFavorite = !_isFavorite);
                },
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 头图背景
                Stack(
                  children: [
                    Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: widget.workout.imageUrl.isNotEmpty
                            ? DecorationImage(
                                image: widget.workout.imageUrl.startsWith('http')
                                    ? NetworkImage(widget.workout.imageUrl)
                                    : AssetImage(widget.workout.imageUrl) as ImageProvider,
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: widget.workout.imageUrl.isEmpty ? Colors.grey[300] : null,
                      ),
                    ),
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                    // 训练标题和基本信息
                    Positioned(
                      bottom: 24,
                      left: 24,
                      right: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.workout.title,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildHeaderStat(Icons.schedule, '${widget.workout.duration}分钟'),
                              const SizedBox(width: 16),
                              _buildHeaderStat(Icons.trending_up, widget.workout.intensity),
                              const SizedBox(width: 16),
                              _buildHeaderStat(Icons.local_fire_department, '${widget.workout.duration * 8}卡'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // 内容区域
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 教练推荐
                      const Text(
                        '教练推荐',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCoachRecommendation(),
                      
                      const SizedBox(height: 32),
                      
                      // 加到日历
                      _buildAddToCalendarButton(),
                      
                      const SizedBox(height: 32),
                      
                      // 训练说明
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
                        widget.workout.description.isNotEmpty
                            ? widget.workout.description
                            : '这是一个精心设计的训练计划，帮助你达成健身目标。',
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppTheme.softGray,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildStartButton('开始训练'),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachRecommendation() {
    // 根据训练类型显示不同内容
    final isFatBurning = widget.workout.title.contains('燃脂');
    final isQuickAction = widget.workout.category == '快速动作';
    
    // 快速动作显示简化信息
    if (isQuickAction) {
      return _buildQuickActionInfo();
    }
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.vitalOrange.withValues(alpha: 0.05),
            AppTheme.vitalOrange.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.vitalOrange.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 教练信息和寄语
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.vitalOrange.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          isFatBurning ? '👩‍🏫' : '👨‍🏫',
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isFatBurning ? '王教练' : '李教练',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isFatBurning ? '燃脂训练专家 · 8年经验' : '资深跑步教练 · 10年经验',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.softGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.vitalOrange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, size: 12, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            '认证',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        child: const Icon(
                          Icons.format_quote,
                          size: 20,
                          color: AppTheme.vitalOrange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isFatBurning 
                              ? '高强度间歇训练是最有效的燃脂方式，坚持下去，你会爱上这种感觉'
                              : '日落时分是跑步的黄金时段，坚持训练，你会看到改变',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.darkGray,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 查看更多按钮
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _showMoreInfo = !_showMoreInfo;
                });
              },
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.vitalOrange.withValues(alpha: 0.1)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _showMoreInfo ? '收起详情' : '查看详细指导',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.vitalOrange,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      _showMoreInfo ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                      color: AppTheme.vitalOrange,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // 展开的详细信息
          if (_showMoreInfo)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: isFatBurning ? [
                  _buildInfoSection(
                    Icons.person_outline,
                    '教练简介',
                    '王教练专注于燃脂训练研究8年，擅长HIIT高强度间歇训练。帮助数百位学员成功减脂塑形，达成理想体态。',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    Icons.checklist_rounded,
                    '练前准备',
                    '• 穿着宽松透气的运动服装，准备毛巾\n• 训练前2小时避免大量进食\n• 充分热身10分钟，提高心率\n• 准备充足的饮用水，训练中及时补水',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    Icons.warning_amber_rounded,
                    '禁忌人群',
                    '• 心脏病、高血压等心血管疾病患者\n• 严重肥胖者（BMI>35）需医生评估\n• 孕妇及产后6个月内女性\n• 膝关节、腰椎有伤病者',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    Icons.fitness_center,
                    '训练要点',
                    '采用HIIT间歇训练模式，30秒高强度运动+15秒休息。包含开合跳、波比跳、高抬腿等动作。保持动作标准，控制呼吸节奏。训练后进行充分拉伸，促进恢复。',
                  ),
                ] : [
                  _buildInfoSection(
                    Icons.person_outline,
                    '教练简介',
                    '李教练拥有10年跑步教学经验，曾指导多位学员完成马拉松比赛。擅长制定个性化训练计划，帮助跑者突破瓶颈。',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    Icons.checklist_rounded,
                    '练前准备',
                    '• 穿着舒适透气的运动服装和专业跑鞋\n• 提前1-2小时进食，避免空腹或饱腹运动\n• 充分热身5-10分钟，活动关节和肌肉\n• 携带运动水壶，及时补充水分',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    Icons.warning_amber_rounded,
                    '���忌人群',
                    '• 心脏病、高血压等心血管疾病患者\n• 关节炎、骨质疏松等骨骼疾病患者\n• 孕妇及产后恢复期女性\n• 感冒发烧等身体不适者',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    Icons.route,
                    '推荐路线',
                    '滨江公园环线（5.2公里）\n路面平整，沿江风景优美，空气清新。适合配速训练，人流适中，安全舒适。建议逆时针方向跑步，可欣赏日落美景。',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(IconData icon, String title, String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.vitalOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: AppTheme.vitalOrange),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.softGray,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionInfo() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.vitalOrange.withValues(alpha: 0.08),
            AppTheme.vitalOrange.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.vitalOrange.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.vitalOrange.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.flash_on, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '快速动作',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '随时随地，高效训练',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.softGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 三个核心特点
            _buildQuickInfoItem(
              Icons.timer_outlined,
              '时间灵活',
              '5-15分钟即可完成',
              '利用碎片时间，随时开始训练',
            ),
            const SizedBox(height: 16),
            _buildQuickInfoItem(
              Icons.home_outlined,
              '无需器械',
              '徒手训练，零门槛',
              '不受场地限制，在家也能练',
            ),
            const SizedBox(height: 16),
            _buildQuickInfoItem(
              Icons.trending_up,
              '效果显著',
              '针对性强，快速见效',
              '科学动作设计，高效燃脂塑形',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfoItem(IconData icon, String title, String subtitle, String desc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.vitalOrange,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.softGray,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCalendarButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.vitalOrange.withValues(alpha: 0.08),
            AppTheme.vitalOrange.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.vitalOrange.withValues(alpha: 0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Text('已添加到运动日历'),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.vitalOrange.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.calendar_today, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '加到日历',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '设置训练提醒，养成运动习惯',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.softGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: AppTheme.vitalOrange,
                  ),
                ),
              ],
            ),
          ),
        ),
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
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() => _isFavorite = !_isFavorite);
              },
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
    );
  }

  Widget _buildStartButton(String text) {
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
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
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

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.vitalOrange, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkGray)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.softGray)),
        ],
      ),
    );
  }

  Widget _buildHighlights() {
    final highlights = [
      {'icon': Icons.wb_twilight, 'title': '黄金时段', 'desc': '日落时分最佳'},
      {'icon': Icons.air, 'title': '空气清新', 'desc': '氧气充足舒适'},
      {'icon': Icons.landscape, 'title': '风景优美', 'desc': '享受自然美景'},
    ];

    return Row(
      children: highlights.map((item) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[100]!),
            ),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.vitalOrange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item['icon'] as IconData, color: AppTheme.vitalOrange, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  item['title'] as String,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.darkGray),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  item['desc'] as String,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRouteCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[50]!, Colors.blue[25]!],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.map, color: Colors.blue, size: 30),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('滨江公园环线', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkGray)),
                SizedBox(height: 4),
                Text('5.2公里 · 平坦路线', style: TextStyle(fontSize: 13, color: AppTheme.softGray)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildRouteDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('路线特点', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.darkGray)),
          const SizedBox(height: 12),
          _buildFeature(Icons.check_circle, '路面平整，适合配速训练'),
          const SizedBox(height: 8),
          _buildFeature(Icons.check_circle, '沿江风景，视野开阔'),
          const SizedBox(height: 8),
          _buildFeature(Icons.check_circle, '人流适中，安全舒适'),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.green),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: AppTheme.softGray))),
      ],
    );
  }

  Widget _buildTipsCard() {
    final tips = [
      '跑前充分热身，避免运动损伤',
      '保持均匀呼吸，找到适合自己的节奏',
      '注意补充水分，携带运动水壶',
      '跑后及时拉伸，促进肌肉恢复',
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber[50]!,
            Colors.orange[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.vitalOrange.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lightbulb, color: AppTheme.vitalOrange, size: 18),
              ),
              const SizedBox(width: 12),
              const Text(
                '温馨提示',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: entry.key < tips.length - 1 ? 12 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppTheme.vitalOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.softGray,
                        height: 1.5,
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

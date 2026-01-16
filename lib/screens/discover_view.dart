import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_icons.dart';
import '../utils/blocked_users_manager.dart';
import '../utils/blocked_stories_manager.dart';
import 'community_stories_screen.dart';
import 'fitness_knowledge_screen.dart';
import 'healthy_diet_screen.dart';
import 'knowledge_article_detail_screen.dart';
import 'story_detail_screen.dart';
import 'monthly_challenge_screen.dart';

class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key});

  @override
  State<DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  Set<String> _blockedUsers = {};
  Set<String> _blockedStories = {};

  @override
  void initState() {
    super.initState();
    _loadBlockedUsers();
    _loadBlockedStories();
  }

  Future<void> _loadBlockedUsers() async {
    final manager = await BlockedUsersManager.getInstance();
    final blocked = await manager.getBlockedUsers();
    if (mounted) {
      setState(() {
        _blockedUsers = blocked;
      });
    }
  }

  Future<void> _loadBlockedStories() async {
    final manager = await BlockedStoriesManager.getInstance();
    final blocked = await manager.getBlockedStories();
    if (mounted) {
      setState(() {
        _blockedStories = blocked;
      });
    }
  }

  void _blockUser(String author) {
    // 先显示 SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text('已拉黑 $author，不会再看到TA的内容')),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
    
    // 延迟更新状态，让 SnackBar 有时间显示
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _blockedUsers.add(author);
        });
        
        // 保存到持久化存储
        BlockedUsersManager.getInstance().then((manager) {
          manager.blockUser(author);
        });
      }
    });
  }

  void _blockStory(String storyTitle) async {
    final manager = await BlockedStoriesManager.getInstance();
    await manager.blockStory(storyTitle);
    
    if (mounted) {
      setState(() {
        _blockedStories.add(storyTitle);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Expanded(child: Text('已屏蔽此内容')),
            ],
          ),
          backgroundColor: Colors.grey,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // 精选故事数据
  final List<Map<String, dynamic>> _featuredStories = const [
    {
      'title': '"我是如何在40岁跑完个马拉松的"',
      'author': '晨跑的小雨',
      'time': '2天前',
      'likes': 1240,
      'image': 'assets/images/fitness/group of people running on stadium.jpg',
      'avatar': 'assets/images/avatar/1@1x.png',
      'category': '跑步',
      'excerpt': '40岁那年，我决定挑战自己，完成人生第一个马拉松。这是一段充满汗水和泪水的旅程...',
    },
    {
      'title': '"从零开始的健身之旅"',
      'author': '健身小白',
      'time': '3天前',
      'likes': 856,
      'image': 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'avatar': 'assets/images/avatar/5@1x.png',
      'category': '力量训练',
      'excerpt': '一年前的我还是个从不运动的宅男，现在我已经可以深蹲100kg了...',
    },
    {
      'title': '"瑜伽改变了我的生活"',
      'author': '静心瑜伽',
      'time': '5天前',
      'likes': 2103,
      'image': 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'avatar': 'assets/images/avatar/3@1x.png',
      'category': '瑜伽',
      'excerpt': '瑜伽不仅让我的身体更柔软，更重要的是让我的心灵得到了平静...',
    },
    {
      'title': '"力量训练让我更自信"',
      'author': '铁人大卫',
      'time': '1周前',
      'likes': 1567,
      'image': 'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'avatar': 'assets/images/avatar/8@1x.png',
      'category': '力量训练',
      'excerpt': '通过系统的力量训练，我不仅改变了体型，更重要的是找回了自信...',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '社区故事',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunityStoriesScreen(),
                    ),
                  );
                  // 返回后重新加载拉黑列表
                  _loadBlockedUsers();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.vitalOrange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: AppTheme.vitalOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 256,
            child: Builder(
              builder: (context) {
                // 过滤被拉黑用户的故事和被屏蔽的故事
                final filteredStories = _featuredStories.where((story) {
                  return !_blockedUsers.contains(story['author']) &&
                         !_blockedStories.contains(story['title']);
                }).toList();

                if (filteredStories.isEmpty) {
                  return Center(
                    child: Text(
                      '暂无内容',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: filteredStories.length,
                  itemBuilder: (context, index) {
                    final story = filteredStories[index];
                    final isLast = index == filteredStories.length - 1;
                    final originalIndex = _featuredStories.indexOf(story);
                
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoryDetailScreen(
                              story: story,
                              storyIndex: originalIndex,
                              onBlockUser: _blockUser,
                              onHideStory: (index) {
                                _blockStory(story['title'].toString());
                              },
                            ),
                          ),
                        ).then((_) {
                          // 返回后重新加载拉黑列表和屏蔽列表
                          _loadBlockedUsers();
                          _loadBlockedStories();
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 80,
                        margin: EdgeInsets.only(
                          right: isLast ? 0 : 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Stack(
                            children: [
                              story['image'].toString().startsWith('http')
                                  ? Image.network(
                                      story['image'].toString(),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Icon(Icons.image, size: 50, color: Colors.grey),
                                          ),
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      story['image'].toString(),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Icon(Icons.image, size: 50, color: Colors.grey),
                                          ),
                                        );
                                      },
                                    ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.8),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 24,
                                left: 24,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Text(
                                    '精选故事',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 32,
                                left: 32,
                                right: 32,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      story['title'].toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundImage: AssetImage(story['avatar'].toString()),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          story['author'].toString(),
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
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
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '体能基础知识',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FitnessKnowledgeScreen(),
                    ),
                  );
                },
                child: const Text(
                  '查看全部',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.vitalOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KnowledgeArticleDetailScreen(
                          title: '肌肉生长的科学原理',
                          category: '体能科学',
                          imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                          content: _getFitnessContent(),
                        ),
                      ),
                    );
                  },
                  child: _buildKnowledgeCard(
                    title: '体能科学',
                    subtitle: '肌肉生长 101',
                    color: Colors.orange[50]!,
                    iconColor: AppTheme.vitalOrange,
                    icon: CustomIcons.zap(size: 20, color: AppTheme.vitalOrange),
                    imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
                    decorationColor: Colors.orange[200]!,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KnowledgeArticleDetailScreen(
                          title: '运动后的拉伸与放松技巧',
                          category: '运动恢复',
                          imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                          content: _getRecoveryContent(),
                        ),
                      ),
                    );
                  },
                  child: _buildKnowledgeCard(
                    title: '运动恢复',
                    subtitle: '拉伸与放松技巧',
                    color: Colors.blue[50]!,
                  iconColor: Colors.blue,
                  icon: CustomIcons.activity(size: 20, color: Colors.blue),
                  imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
                  decorationColor: Colors.blue[200]!,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '健康饮食',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HealthyDietScreen(),
                    ),
                  );
                },
                child: const Text(
                  '查看全部',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.vitalOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KnowledgeArticleDetailScreen(
                          title: '牛油果的营养价值与健康食谱',
                          category: '纯净饮食',
                          imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                          content: _getDietContent(),
                        ),
                      ),
                    );
                  },
                  child: _buildKnowledgeCard(
                    title: '纯净饮食',
                    subtitle: '牛油果食谱',
                    color: Colors.green[50]!,
                    iconColor: AppTheme.successGreen,
                    icon: CustomIcons.heart(size: 20, color: AppTheme.successGreen),
                    imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
                    decorationColor: Colors.green[200]!,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KnowledgeArticleDetailScreen(
                          title: '运动人群的蛋白质摄入指南',
                          category: '营养补充',
                          imageUrl: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                          content: _getProteinContent(),
                        ),
                      ),
                    );
                  },
                  child: _buildKnowledgeCard(
                    title: '营养补充',
                    subtitle: '蛋白质摄入指南',
                    color: Colors.purple[50]!,
                    iconColor: Colors.purple,
                    icon: CustomIcons.target(size: 20, color: Colors.purple),
                    imageUrl: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
                    decorationColor: Colors.purple[200]!,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MonthlyChallengeScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.darkGray,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1月挑战',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '已有 15,800+ 人加入',
                        style: TextStyle(
                          color: AppTheme.softGray,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.vitalOrange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '查看详情',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100), // 额外的底部空间，避免被导航栏遮盖
        ],
      ),
    );
  }

  Widget _buildKnowledgeCard({
    required String title,
    required String subtitle,
    required Color color,
    required Color iconColor,
    required Widget icon,
    required String imageUrl,
    required Color decorationColor,
  }) {
    return Container(
      height: 224,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(child: icon),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 64,
                    height: 64,
                    color: Colors.grey[300],
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: -16,
            right: -16,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: decorationColor.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFitnessContent() {
    return '''肌肉生长是一个复杂的生理过程，涉及多个生物学机制的协同作用。

**肌肉生长的基本原理**

当我们进行力量训练时，肌肉纤维会产生微小的撕裂。这些微损伤会触发身体的修复机制，在修复过程中，肌肉纤维会变得更粗更强，这就是肌肉生长的基本原理。

**三大关键要素**

1. 渐进式超负荷
持续增加训练强度是刺激肌肉生长的关键。可以通过增加重量、增加组数或减少休息时间来实现。

2. 充足的蛋白质摄入
蛋白质是肌肉修复和生长的原料。建议每天摄入体重（公斤）×1.6-2.2克的蛋白质。

3. 充分的休息恢复
肌肉在休息时生长，不是在训练时。确保每个肌群有48-72小时的恢复时间。

**训练建议**

- 每周进行3-4次力量训练
- 每次训练持续45-60分钟
- 重点训练大肌群（胸、背、腿）
- 保持正确的动作姿势

记住，肌肉生长需要时间和耐心。坚持科学的训练方法，配合合理的饮食和充足的休息，你一定能看到理想的效果。''';
  }

  String _getRecoveryContent() {
    return '''运动后的恢复与训练本身同样重要。正确的拉伸和放松技巧可以帮助你更快恢复，减少运动损伤的风险。

**为什么需要拉伸**

运动后肌肉处于紧张状态，如果不及时放松，可能导致肌肉僵硬、疼痛，甚至增加受伤风险。拉伸可以：
- 促进血液循环
- 减少肌肉酸痛
- 提高柔韧性
- 加速恢复过程

**拉伸的最佳时机**

运动后5-10分钟内是拉伸的黄金时间。此时肌肉温度较高，更容易伸展，效果最好。

**基础拉伸动作**

1. 大腿前侧拉伸
站立，一手扶墙保持平衡，另一手抓住同侧脚踝向臀部拉，保持30秒。

2. 大腿后侧拉伸
坐姿，一腿伸直，身体前倾，双手触摸脚尖，保持30秒。

3. 小腿拉伸
面对墙壁，一脚在前一脚在后，后脚跟着地，身体前倾，保持30秒。

4. 肩部拉伸
一臂横过胸前，另一手轻压肘部，保持30秒。

**注意事项**

- 拉伸时应感到轻微拉扯感，不应疼痛
- 保持自然呼吸，不要憋气
- 每个动作保持20-30秒
- 避免弹震式拉伸

配合深呼吸和放松的心态，让拉伸成为你运动后的必备环节。''';
  }

  String _getDietContent() {
    return '''牛油果被誉为"超级食物"，富含健康脂肪、纤维和多种维生素，是健康饮食的理想选择。

**牛油果的营养价值**

一个中等大小的牛油果含有：
- 健康单不饱和脂肪酸
- 丰富的钾元素（比香蕉还多）
- 维生素K、E、C和B族维生素
- 膳食纤维约7克

**健康益处**

1. 心血管健康
牛油果中的单不饱和脂肪酸有助于降低坏胆固醇，提高好胆固醇水平。

2. 促进营养吸收
脂肪可以帮助身体更好地吸收脂溶性维生素（A、D、E、K）。

3. 控制血糖
低碳水化合物和高纤维的特性有助于稳定血糖水平。

**简单美味食谱**

**牛油果吐司**
- 全麦面包烤至金黄
- 牛油果捣碎，加少许柠檬汁和盐
- 涂抹在面包上
- 可选：加水煮蛋、番茄片

**牛油果沙拉**
- 牛油果切块
- 混合生菜、樱桃番茄、黄瓜
- 橄榄油、柠檬汁调味
- 撒上黑胡椒和海盐

**牛油果奶昔**
- 半个牛油果
- 一根香蕉
- 250ml牛奶或植物奶
- 一勺蜂蜜
- 搅拌均匀即可

**选购与保存**

- 选择外皮深绿色、轻压有弹性的牛油果
- 未成熟的可在室温下放置2-3天
- 成熟后放入冰箱可保存3-5天
- 切开后撒柠檬汁可防止氧化变黑

将牛油果融入日常饮食，享受健康美味的同时，为身体补充优质营养。''';
  }

  String _getProteinContent() {
    return '''蛋白质是肌肉修复和生长的基础，对于运动人群来说，合理的蛋白质摄入至关重要。

**蛋白质的重要性**

蛋白质由氨基酸组成，是构成肌肉、骨骼、皮肤和其他组织的基本材料。对于运动人群：
- 修复运动造成的肌肉损伤
- 促进肌肉生长
- 维持免疫系统功能
- 提供能量（在必要时）

**每日摄入量建议**

根据运动强度和目标，蛋白质需求有所不同：

- 普通人群：0.8-1.0克/公斤体重
- 有氧运动者：1.2-1.4克/公斤体重
- 力量训练者：1.6-2.2克/公斤体重
- 增肌期：2.0-2.5克/公斤体重

例如，70公斤的力量训练者，每天需要112-154克蛋白质。

**优质蛋白质来源**

**动物性蛋白**
- 鸡胸肉：每100克含31克蛋白质
- 鸡蛋：每个含6克蛋白质
- 三文鱼：每100克含20克蛋白质
- 希腊酸奶：每100克含10克蛋白质

**植物性蛋白**
- 豆腐：每100克含8克蛋白质
- 扁豆：每100克含9克蛋白质
- 藜麦：每100克含4克蛋白质
- 坚果：每30克含5-7克蛋白质

**摄入时机**

1. 运动前（1-2小时）
摄入20-30克蛋白质，为训练提供能量。

2. 运动后（30分钟内）
这是"合成代谢窗口"，摄入20-40克蛋白质效果最佳。

3. 睡前
摄入20-30克缓释蛋白质（如酪蛋白），支持夜间肌肉修复。

**分配建议**

将每日蛋白质分配到3-5餐中，每餐20-40克，比一次性大量摄入更有效。

**常见误区**

1. "蛋白质越多越好"
过量摄入不会带来额外好处，反而增加肾脏负担。

2. "只能从肉类获取"
植物性蛋白同样优质，合理搭配即可满足需求。

3. "运动后必须立即补充"
虽然运动后补充效果好，但不必过分焦虑，2小时内补充都有效。

记住，蛋白质只是营养拼图的一部分。配合碳水化合物、健康脂肪和充足的蔬果，才能构建完整的运动营养方案。''';
  }
}

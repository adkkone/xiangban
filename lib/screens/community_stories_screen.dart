import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/blocked_users_manager.dart';
import 'story_detail_screen.dart';

class CommunityStoriesScreen extends StatefulWidget {
  CommunityStoriesScreen({super.key});

  @override
  State<CommunityStoriesScreen> createState() => _CommunityStoriesScreenState();
}

class _CommunityStoriesScreenState extends State<CommunityStoriesScreen> {
  // 拉黑的用户列表
  Set<String> _blockedUsers = {};
  
  // 屏蔽的故事ID列表
  final Set<int> _hiddenStories = {};

  @override
  void initState() {
    super.initState();
    _loadBlockedUsers();
  }

  Future<void> _loadBlockedUsers() async {
    final manager = await BlockedUsersManager.getInstance();
    final blocked = await manager.getBlockedUsers();
    setState(() {
      _blockedUsers = blocked;
    });
  }

  // 社区故事数据
  final List<Map<String, dynamic>> _allStories = const [
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
    {
      'title': '"骑行穿越城市的快乐"',
      'author': '单车少女',
      'time': '1周前',
      'likes': 923,
      'image': 'https://images.unsplash.com/photo-1541625602330-2277a4c46182?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'avatar': 'assets/images/avatar/12@1x.png',
      'category': '骑行',
      'excerpt': '每个周末，我都会骑着单车穿越城市的大街小巷，发现不一样的风景...',
    },
    {
      'title': '"游泳让我重获新生"',
      'author': '自由泳者',
      'time': '2周前',
      'likes': 1834,
      'image': 'https://images.unsplash.com/photo-1519315901367-f34ff9154487?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'avatar': 'assets/images/avatar/15@1x.png',
      'category': '游泳',
      'excerpt': '在水中的每一次呼吸，都让我感受到生命的力量和自由...',
    },
    {
      'title': '"普拉提塑造完美体态"',
      'author': '优雅艾玛',
      'time': '2周前',
      'likes': 1456,
      'image': 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'avatar': 'assets/images/avatar/7@1x.png',
      'category': '普拉提',
      'excerpt': '坚持普拉提训练半年，我的体态变得更加优雅，核心力量也大大提升...',
    },
    {
      'title': '"晨跑改变了我的作息"',
      'author': '早起的鸟儿',
      'time': '3周前',
      'likes': 2187,
      'image': 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'avatar': 'assets/images/avatar/18@1x.png',
      'category': '跑步',
      'excerpt': '从夜猫子到晨跑爱好者，这个转变让我的生活变得更加健康和充实...',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 过滤被拉黑用户和屏蔽的内容
    final filteredStories = _allStories.asMap().entries.where((entry) {
      final index = entry.key;
      final story = entry.value;
      return !_blockedUsers.contains(story['author']) && !_hiddenStories.contains(index);
    }).map((entry) => entry.value).toList();

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
          '社区故事',
          style: TextStyle(
            color: AppTheme.darkGray,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: filteredStories.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    '暂无内容',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: filteredStories.length,
              itemBuilder: (context, index) {
                final story = filteredStories[index];
                final originalIndex = _allStories.indexOf(story);
                return _buildStoryCard(story, originalIndex, index == filteredStories.length - 1);
              },
            ),
    );
  }

  Widget _buildStoryCard(Map<String, dynamic> story, int storyIndex, bool isLast) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDetailScreen(
              story: story,
              storyIndex: storyIndex,
              onBlockUser: _blockUser,
              onHideStory: _hideStory,
            ),
          ),
        );
      },
      child: Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头图
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                story['image'].toString().startsWith('http')
                    ? Image.network(
                        story['image'],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image, size: 50, color: Colors.grey),
                            ),
                          );
                        },
                      )
                    : Image.asset(
                        story['image'],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image, size: 50, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                Container(
                  height: 200,
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
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.vitalOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      story['category'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 内容
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGray,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  story['excerpt'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.softGray,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage(story['avatar']),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story['author'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkGray,
                            ),
                          ),
                          Text(
                            story['time'],
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.softGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.favorite_border, size: 18, color: AppTheme.softGray),
                        const SizedBox(width: 4),
                        Text(
                          '${story['likes']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.softGray,
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            _showMoreOptions(context, story['author'], storyIndex);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.more_horiz,
                              size: 20,
                              color: AppTheme.softGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  void _showMoreOptions(BuildContext context, String author, int storyIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionItem(
                context,
                icon: Icons.block,
                title: '拉黑用户',
                subtitle: '不再看到 $author 的内容',
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(author);
                },
              ),
              _buildDivider(),
              _buildOptionItem(
                context,
                icon: Icons.visibility_off,
                title: '屏蔽此内容',
                subtitle: '减少看到类似内容',
                color: Colors.grey[700]!,
                onTap: () {
                  Navigator.pop(context);
                  _hideStory(storyIndex);
                },
              ),
              _buildDivider(),
              _buildOptionItem(
                context,
                icon: Icons.flag,
                title: '举报',
                subtitle: '举报不当内容',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(context, author, storyIndex);
                },
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.offWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '取消',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkGray,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _blockUser(String author) {
    // 先显示 SnackBar
    final snackBar = ScaffoldMessenger.of(context).showSnackBar(
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

  void _hideStory(int storyIndex) {
    // 先显示 SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Expanded(child: Text('已屏蔽此内容')),
          ],
        ),
        backgroundColor: Colors.grey,
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
          _hiddenStories.add(storyIndex);
        });
      }
    });
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGray,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.softGray,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: AppTheme.softGray),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Divider(height: 1, color: Colors.grey[200]),
    );
  }

  void _showReportDialog(BuildContext context, String author, int storyIndex) {
    final reasons = [
      {'title': '垃圾广告', 'icon': Icons.shopping_bag_outlined},
      {'title': '色情低俗', 'icon': Icons.warning_amber_outlined},
      {'title': '虚假信息', 'icon': Icons.info_outline},
      {'title': '侵权内容', 'icon': Icons.copyright_outlined},
      {'title': '其他', 'icon': Icons.more_horiz},
    ];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(
                      '举报原因',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGray,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '请选择举报此内容的原因，我们会尽快处理',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...reasons.map((reason) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _submitReport(context, reason['title'] as String, author, storyIndex);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: reasons.last == reason ? Colors.transparent : Colors.grey[200]!,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            reason['icon'] as IconData,
                            size: 20,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            reason['title'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppTheme.darkGray,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 20, color: AppTheme.softGray),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.offWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '取消',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkGray,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _submitReport(BuildContext context, String reason, String author, int storyIndex) {
    // 举报后只提示，不自动屏蔽内容
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '举报已提交',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '原因：$reason，我们会尽快处理',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

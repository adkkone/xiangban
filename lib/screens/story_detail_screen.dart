import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StoryDetailScreen extends StatefulWidget {
  final Map<String, dynamic> story;
  final int storyIndex;
  final Function(String) onBlockUser;
  final Function(int) onHideStory;

  const StoryDetailScreen({
    super.key,
    required this.story,
    required this.storyIndex,
    required this.onBlockUser,
    required this.onHideStory,
  });

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  bool _isLiked = false;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _likes = widget.story['likes'] as int;
  }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _likes--;
        _isLiked = false;
      } else {
        _likes++;
        _isLiked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 头部图片和AppBar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: AppTheme.darkGray, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.more_horiz, color: AppTheme.darkGray, size: 20),
                ),
                onPressed: () => _showMoreOptions(context),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.story['image'].toString().startsWith('http')
                      ? Image.network(
                          widget.story['image'],
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
                          widget.story['image'],
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
          
          // 内容区域
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 分类标签
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.vitalOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.story['category'],
                      style: const TextStyle(
                        color: AppTheme.vitalOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 标题
                  Text(
                    widget.story['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGray,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 作者信息
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(widget.story['avatar']),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.story['author'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkGray,
                              ),
                            ),
                            Text(
                              widget.story['time'],
                              style: const TextStyle(
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
                  
                  // 正文内容
                  Text(
                    widget.story['excerpt'],
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppTheme.darkGray,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 扩展内容
                  Text(
                    _getFullContent(),
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppTheme.darkGray,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // 点赞按钮
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[200]!),
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _toggleLike,
                          child: Row(
                            children: [
                              Icon(
                                _isLiked ? Icons.favorite : Icons.favorite_border,
                                color: _isLiked ? Colors.red : AppTheme.softGray,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$_likes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _isLiked ? Colors.red : AppTheme.darkGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFullContent() {
    // 根据不同的故事返回不同的完整内容
    final title = widget.story['title'] as String;
    
    if (title.contains('马拉松')) {
      return '''
从决定参加马拉松的那一刻起，我就知道这将是一段艰难的旅程。40岁的年纪，身体机能已经不如年轻时，但我相信只要坚持训练，一切皆有可能。

最初的几周训练非常艰难，每次跑步都感觉双腿像灌了铅一样沉重。但我告诉自己，这只是开始，坚持下去就会看到改变。

三个月后，我已经可以轻松跑完10公里。半年后，我完成了人生第一个半程马拉松。那种成就感让我更加坚定了完成全马的决心。

比赛当天，站在起跑线上，我的心情既紧张又兴奋。42.195公里的征程开始了。前半程还算顺利，但到了30公里后，体能开始急剧下降。

最后的几公里是最艰难的，每一步都像是在与自己的极限作斗争。但当我冲过终点线的那一刻，所有的辛苦都值得了。

这段经历告诉我，年龄从来不是限制，只要有决心和毅力，任何目标都能实现。''';
    } else if (title.contains('健身')) {
      return '''
一年前的我，是个标准的宅男。每天除了上班就是回家躺着，体重一路飙升，身体状况也越来越差。

转变的契机是一次体检，医生严肃地告诉我，再不运动，身体会出大问题。那一刻，我决定改变。

刚开始去健身房时，我连最基本的动作都做不好。看着周围的人轻松举起杠铃，我只能从最轻的哑铃开始。那种挫败感让我几度想要放弃。

但教练告诉我，每个人都是从零开始的，重要的是坚持。于是我制定了详细的训练计划，每周三次，风雨无阻。

三个月后，我的体重开始下降，肌肉线条也慢慢显现。半年后，我已经可以深蹲100kg，这在以前是想都不敢想的。

现在的我，不仅身体变好了，整个人的精神状态也完全不同。健身不仅改变了我的身体，更改变了我的生活态度。''';
    } else if (title.contains('瑜伽')) {
      return '''
接触瑜伽之前，我是个急性子，做什么都追求快速和效率。工作压力大，经常失眠，整个人都处在焦虑的状态中。

朋友建议我试试瑜伽，说可以帮助放松身心。一开始我是拒绝的，觉得那些动作太慢，不适合我。

但第一次上课后，我的想法改变了。在舒缓的音乐中，跟随老师的指导做着各种体式，我感受到了前所未有的平静。

瑜伽教会我如何与自己的身体对话，如何在呼吸中找到内心的宁静。每次练习后，那种身心合一的感觉让我沉醉。

坚持练习半年后，我的身体变得更加柔软，睡眠质量也大大提高。更重要的是，我学会了如何在快节奏的生活中保持内心的平和。

瑜伽不仅是一种运动，更是一种生活方式。它让我重新认识了自己，找到了生活的平衡点。''';
    } else {
      return '''
这是一段充满挑战和收获的旅程。每一次训练都是对自己的突破，每一滴汗水都见证着成长。

运动改变的不仅是身体，更是整个人的精神面貌。它让我学会了坚持，懂得了自律，也收获了健康和快乐。

如果你也在犹豫是否要开始运动，我想告诉你：永远不要低估自己的潜力。只要迈出第一步，坚持下去，你一定会看到改变。

让我们一起，用运动书写更精彩的人生！''';
    }
  }

  void _showMoreOptions(BuildContext context) {
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
                subtitle: '不再看到 ${widget.story['author']} 的内容',
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(context); // 关闭底部菜单
                  widget.onBlockUser(widget.story['author']);
                  // 延迟关闭详情页，让 toast 有时间显示
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted && Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  });
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
                  Navigator.pop(context); // 关闭底部菜单
                  widget.onHideStory(widget.storyIndex);
                  // 延迟关闭详情页，让 toast 有时间显示
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted && Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  });
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
                  _showReportDialog(context);
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

  void _showReportDialog(BuildContext context) {
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
                    _submitReport(context, reason['title'] as String);
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

  void _submitReport(BuildContext context, String reason) {
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

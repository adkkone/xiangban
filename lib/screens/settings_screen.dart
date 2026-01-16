import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../utils/blocked_stories_manager.dart';
import '../services/teen_mode_service.dart';
import 'about_screen.dart';
import '../xiangbanIAP/UpdateNormalUtilCollection.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _autoPlayVideos = false;
  bool _dataSaverMode = false;
  bool _teenModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadTeenModeStatus();
  }

  Future<void> _loadTeenModeStatus() async {
    final service = await TeenModeService.getInstance();
    final isEnabled = await service.isTeenModeEnabled();
    if (mounted) {
      setState(() {
        _teenModeEnabled = isEnabled;
      });
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
          '设置',
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
          // 通知设置
          const Text(
            '通知设置',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.softGray,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsCard([
            _buildSwitchItem(
              icon: Icons.notifications_outlined,
              title: '推送通知',
              subtitle: '接收训练提醒和活动通知',
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
              },
            ),
            _buildDivider(),
            _buildSwitchItem(
              icon: Icons.volume_up_outlined,
              title: '声音',
              subtitle: '训练时播放提示音',
              value: _soundEnabled,
              onChanged: (value) {
                setState(() => _soundEnabled = value);
              },
            ),
            _buildDivider(),
            _buildSwitchItem(
              icon: Icons.vibration,
              title: '震动反馈',
              subtitle: '操作时提供触觉反馈',
              value: _vibrationEnabled,
              onChanged: (value) {
                setState(() => _vibrationEnabled = value);
              },
            ),
          ]),
          
          const SizedBox(height: 32),
          
          // 内容设置
          const Text(
            '内容设置',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.softGray,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsCard([
            _buildSwitchItem(
              icon: Icons.play_circle_outline,
              title: '自动播放视频',
              subtitle: '在发现页自动播放视频内容',
              value: _autoPlayVideos,
              onChanged: (value) {
                setState(() => _autoPlayVideos = value);
              },
            ),
            _buildDivider(),
            _buildSwitchItem(
              icon: Icons.data_saver_on,
              title: '省流量模式',
              subtitle: '降低图片和视频质量',
              value: _dataSaverMode,
              onChanged: (value) {
                setState(() => _dataSaverMode = value);
              },
            ),
          ]),
          
          const SizedBox(height: 32),
          
          // 金币商城
          const Text(
            '金币商城',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.softGray,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsCard([
            _buildNavigationItem(
              icon: Icons.shopping_bag_outlined,
              title: '购买金币',
              subtitle: '充值金币，解锁更多功能',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StartPrismaticCosineImplement(),
                  ),
                );
              },
            ),
          ]),
          
          const SizedBox(height: 32),
          
          // 隐私与安全
          const Text(
            '隐私与安全',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.softGray,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsCard([
            _buildNavigationItem(
              icon: Icons.child_care,
              title: '青少年模式',
              subtitle: _teenModeEnabled ? '已开启' : '限制使用时长，过滤不适宜内容',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TeenModeScreen(),
                  ),
                ).then((_) => _loadTeenModeStatus());
              },
            ),
            _buildDivider(),
            _buildNavigationItem(
              icon: Icons.block_outlined,
              title: '黑名单管理',
              subtitle: '管理已拉黑的用户',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BlockedUsersScreen(),
                  ),
                );
              },
            ),
            _buildDivider(),
            _buildNavigationItem(
              icon: Icons.visibility_off_outlined,
              title: '屏蔽内容',
              subtitle: '管理屏蔽的话题和内容',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BlockedContentScreen(),
                  ),
                );
              },
            ),
          ]),
          
          const SizedBox(height: 32),
          
          // 帮助与反馈
          const Text(
            '帮助与反馈',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.softGray,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsCard([
            _buildNavigationItem(
              icon: Icons.help_outline,
              title: '帮助中心',
              subtitle: '常见问题与使用指南',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpCenterScreen(),
                  ),
                );
              },
            ),
            _buildDivider(),
            _buildNavigationItem(
              icon: Icons.feedback_outlined,
              title: '意见反馈',
              subtitle: '告诉我们您的建议',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeedbackScreen(),
                  ),
                );
              },
            ),
            _buildDivider(),
            _buildNavigationItem(
              icon: Icons.info_outline,
              title: '关于我们',
              subtitle: '版本 1.0.0',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              },
            ),
          ]),
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.vitalOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppTheme.vitalOrange,
              size: 22,
            ),
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
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.vitalOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.vitalOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppTheme.vitalOrange,
                size: 22,
              ),
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
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkGray,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 72),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey[100],
      ),
    );
  }
}

// 黑名单管理页面
class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  final List<Map<String, String>> _blockedUsers = [
    {'name': '用户123', 'avatar': 'assets/images/avatar/1@1x.png'},
    {'name': '健身达人456', 'avatar': 'assets/images/avatar/2@1x.png'},
  ];

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
          '黑名单管理',
          style: TextStyle(
            color: AppTheme.darkGray,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _blockedUsers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.block_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '暂无拉黑用户',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _blockedUsers.length,
              itemBuilder: (context, index) {
                final user = _blockedUsers[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[100]!),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(user['avatar']!),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          user['name']!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.darkGray,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _blockedUsers.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已解除拉黑')),
                          );
                        },
                        child: const Text(
                          '解除',
                          style: TextStyle(
                            color: AppTheme.vitalOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// 屏蔽内容页面
class BlockedContentScreen extends StatefulWidget {
  const BlockedContentScreen({super.key});

  @override
  State<BlockedContentScreen> createState() => _BlockedContentScreenState();
}

class _BlockedContentScreenState extends State<BlockedContentScreen> {
  List<String> _blockedStories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBlockedStories();
  }

  Future<void> _loadBlockedStories() async {
    final manager = await BlockedStoriesManager.getInstance();
    final blocked = await manager.getBlockedStories();
    if (mounted) {
      setState(() {
        _blockedStories = blocked.toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _unblockStory(String storyTitle) async {
    final manager = await BlockedStoriesManager.getInstance();
    await manager.unblockStory(storyTitle);
    
    if (mounted) {
      setState(() {
        _blockedStories.remove(storyTitle);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已解除屏蔽')),
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
          '屏蔽内容',
          style: TextStyle(
            color: AppTheme.darkGray,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[100]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '屏蔽的社区故事将不会在发现页显示',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '已屏蔽的社区故事',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(height: 12),
                if (_blockedStories.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.visibility_off_outlined,
                            size: 60,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '暂无屏蔽内容',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ..._blockedStories.map((storyTitle) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[100]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.article_outlined, color: Colors.grey[400], size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              storyTitle,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.darkGray,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _unblockStory(storyTitle),
                            child: const Text(
                              '解除',
                              style: TextStyle(
                                color: AppTheme.vitalOrange,
                                fontWeight: FontWeight.w600,
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

// 帮助中心页面
class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': '如何开始我的第一次训练？',
        'answer': '在首页选择推荐的训练计划，点击"开始训练"即可开始。建议从轻松的训练开始，逐步提升强度。'
      },
      {
        'question': '如何记录我的训练数据？',
        'answer': '训练过程中，应用会自动记录您的时长、卡路里消耗等数据。训练结束后可在"我的"页面查看详细统计。'
      },
      {
        'question': '如何参加月度挑战？',
        'answer': '在发现页找到当月挑战，点击"立即参加"即可加入。完成挑战目标后将获得专属成就勋章。'
      },
      {
        'question': '如何解锁更多成就？',
        'answer': '坚持训练、完成挑战、分享记录等行为都能帮助您解锁成就。在"我的"页面可查看所有成就及解锁条件。'
      },
    ];

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
          '帮助中心',
          style: TextStyle(
            color: AppTheme.darkGray,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[100]!),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                title: Text(
                  faq['question']!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGray,
                  ),
                ),
                children: [
                  Text(
                    faq['answer']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// 意见反馈页面
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _feedbackController = TextEditingController();
  String _selectedType = '功能建议';

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
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
          '意见反馈',
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
          const Text(
            '反馈类型',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.softGray,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ['功能建议', '问题反馈', '其他'].map((type) {
              final isSelected = _selectedType == type;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedType = type);
                },
                selectedColor: AppTheme.vitalOrange.withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.vitalOrange : AppTheme.softGray,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? AppTheme.vitalOrange : Colors.grey[200]!,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            '详细描述',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.softGray,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: TextField(
              controller: _feedbackController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: '请详细描述您的建议或遇到的问题...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_feedbackController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('请输入反馈内容')),
                  );
                  return;
                }
                
                // 提交反馈
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('感谢您的反馈！')),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.vitalOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                '提交反馈',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// 青少年模式页面
class TeenModeScreen extends StatefulWidget {
  const TeenModeScreen({super.key});

  @override
  State<TeenModeScreen> createState() => _TeenModeScreenState();
}

class _TeenModeScreenState extends State<TeenModeScreen> {
  bool _teenModeEnabled = false;
  int _dailyTimeLimit = 40; // 默认40分钟
  bool _filterContent = true;
  bool _restrictPurchase = true;
  bool _hasPassword = false;
  String _password = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final service = await TeenModeService.getInstance();
    final isEnabled = await service.isTeenModeEnabled();
    final prefs = await SharedPreferences.getInstance();
    final savedPassword = prefs.getString('teen_mode_password') ?? '';
    
    if (mounted) {
      setState(() {
        _teenModeEnabled = isEnabled;
        _hasPassword = savedPassword.isNotEmpty;
        _password = savedPassword;
      });
    }
  }

  Future<void> _toggleTeenMode(bool value) async {
    // 如果要关闭青少年模式且设置了密码，需要验证密码
    if (!value && _hasPassword) {
      final verified = await _showPasswordVerification();
      if (!verified) return;
    }
    
    final service = await TeenModeService.getInstance();
    await service.setTeenMode(value);
    setState(() {
      _teenModeEnabled = value;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value ? '青少年模式已开启' : '青少年模式已关闭'),
          duration: const Duration(seconds: 2),
        ),
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
          '青少年模式',
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
          // 说明卡片
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '青少年模式可以帮助限制使用时长，过滤不适宜内容，为青少年提供更健康的使用环境',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[700],
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 开关
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[100]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.vitalOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.child_care,
                      color: AppTheme.vitalOrange,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '启用青少年模式',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.darkGray,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '开启后将应用所有限制',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CupertinoSwitch(
                    value: _teenModeEnabled,
                    onChanged: _toggleTeenMode,
                    activeColor: AppTheme.vitalOrange,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 功能设置
          const Text(
            '功能设置',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.softGray,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[100]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildTimeLimitItem(),
                Padding(
                  padding: const EdgeInsets.only(left: 72),
                  child: Divider(height: 1, thickness: 1, color: Colors.grey[100]),
                ),
                _buildPasswordSettingItem(),
                Padding(
                  padding: const EdgeInsets.only(left: 72),
                  child: Divider(height: 1, thickness: 1, color: Colors.grey[100]),
                ),
                _buildSwitchSettingItem(
                  icon: Icons.filter_alt_outlined,
                  title: '内容过滤',
                  subtitle: '过滤不适宜青少年的内容',
                  value: _filterContent,
                  onChanged: (value) {
                    setState(() => _filterContent = value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 72),
                  child: Divider(height: 1, thickness: 1, color: Colors.grey[100]),
                ),
                _buildSwitchSettingItem(
                  icon: Icons.shopping_cart_outlined,
                  title: '限制购买',
                  subtitle: '禁止应用内购买功能',
                  value: _restrictPurchase,
                  onChanged: (value) {
                    setState(() => _restrictPurchase = value);
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 使用统计
          const Text(
            '今日使用',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.softGray,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[100]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '已使用时长',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.softGray,
                      ),
                    ),
                    Text(
                      '15 分钟',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.vitalOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 15 / _dailyTimeLimit,
                    minHeight: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.vitalOrange),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '剩余 ${_dailyTimeLimit - 15} 分钟',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      '限制 $_dailyTimeLimit 分钟/天',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildTimeLimitItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.vitalOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.timer_outlined,
              color: AppTheme.vitalOrange,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '每日时长限制',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '当前限制 $_dailyTimeLimit 分钟/天',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showTimeLimitPicker(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.vitalOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$_dailyTimeLimit 分钟',
                style: const TextStyle(
                  color: AppTheme.vitalOrange,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.vitalOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppTheme.vitalOrange,
              size: 22,
            ),
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
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.vitalOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordSettingItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.vitalOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.lock_outline,
              color: AppTheme.vitalOrange,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '密码保护',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _hasPassword ? '已设置密码' : '设置密码以保护设置',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showPasswordSetting(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.vitalOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _hasPassword ? '修改' : '设置',
                style: const TextStyle(
                  color: AppTheme.vitalOrange,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPasswordSetting() async {
    // 如果已有密码，先验证旧密码
    if (_hasPassword) {
      final verified = await _showPasswordVerification();
      if (!verified) return;
    }

    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmController = TextEditingController();

    if (!mounted) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_hasPassword ? '修改密码' : '设置密码'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: passwordController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: '输入6位数字密码',
                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: '确认密码',
                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final password = passwordController.text;
              final confirm = confirmController.text;

              if (password.isEmpty || password.length != 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入6位数字密码')),
                );
                return;
              }

              if (password != confirm) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('两次密码输入不一致')),
                );
                return;
              }

              Navigator.pop(context, true);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('teen_mode_password', passwordController.text);
      
      setState(() {
        _hasPassword = true;
        _password = passwordController.text;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_hasPassword ? '密码已修改' : '密码已设置')),
        );
      }
    }

    passwordController.dispose();
    confirmController.dispose();
  }

  Future<bool> _showPasswordVerification() async {
    final TextEditingController controller = TextEditingController();

    if (!mounted) return false;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('验证密码'),
        content: TextField(
          controller: controller,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 6,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '请输入密码',
            border: OutlineInputBorder(),
            counterText: '',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text == _password) {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('密码错误')),
                );
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );

    controller.dispose();
    return result ?? false;
  }

  void _showTimeLimitPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '设置每日时长限制',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                    initialItem: (_dailyTimeLimit ~/ 10) - 1,
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _dailyTimeLimit = (index + 1) * 10;
                    });
                  },
                  children: List.generate(12, (index) {
                    final minutes = (index + 1) * 10;
                    return Center(
                      child: Text(
                        '$minutes 分钟',
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.vitalOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '确定',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../services/user_service.dart';
import '../services/favorites_service.dart';
import '../screens/edit_basic_info_screen.dart';
import '../screens/edit_interests_screen.dart';
import '../screens/favorites_screen.dart';

class UserProfileSheet extends StatefulWidget {
  const UserProfileSheet({super.key});

  @override
  State<UserProfileSheet> createState() => _UserProfileSheetState();
}

class _UserProfileSheetState extends State<UserProfileSheet> {
  String _nickname = '运动达人';
  String _height = '170-180cm';
  String _weight = '60-70kg';
  List<String> _interests = ['跑步', '力量训练', '瑜伽'];
  int _favoriteCount = 12;
  bool _isLoading = true;
  String? _avatarPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userService = await UserService.getInstance();
    final profile = await userService.getUserProfile();
    
    final favService = await FavoritesService.getInstance();
    final favCount = await favService.getFavoriteCount();
    
    if (mounted) {
      setState(() {
        _nickname = profile['nickname'];
        _height = profile['height'];
        _weight = profile['weight'];
        _interests = List<String>.from(profile['interests']);
        _favoriteCount = favCount;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppTheme.vitalOrange,
          ),
        ),
      );
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 顶部拖动条
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 头像和昵称
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.vitalOrange.withValues(alpha: 0.3),
                                  width: 3,
                                ),
                              ),
                              child: ClipOval(
                                child: _avatarPath != null
                                    ? Image.network(
                                        _avatarPath!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/avatar/1@1x.png',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppTheme.vitalOrange.withValues(alpha: 0.8),
                                              AppTheme.vitalOrange,
                                            ],
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.directions_run,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: _changeAvatar,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppTheme.vitalOrange,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: _editNickname,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _nickname,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkGray,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 个人信息
                  const Text(
                    '个人信息',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInfoItem(
                    icon: Icons.height,
                    label: '身高',
                    value: _height,
                    onTap: _editHeight,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem(
                    icon: Icons.monitor_weight_outlined,
                    label: '体重',
                    value: _weight,
                    onTap: _editWeight,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 运动兴趣
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '运动兴趣',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      GestureDetector(
                        onTap: _editInterests,
                        child: Text(
                          '编辑',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.vitalOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _interests.map((interest) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.vitalOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.vitalOrange.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          interest,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.vitalOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 收藏
                  GestureDetector(
                    onTap: _viewFavorites,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppTheme.vitalOrange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.favorite,
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
                                  '我的收藏',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.darkGray,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$_favoriteCount 个训练计划',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  },
);
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.vitalOrange,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkGray,
              ),
            ),
            const SizedBox(width: 8),
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

  void _changeAvatar() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null && mounted) {
        setState(() {
          _avatarPath = image.path;
        });
        
        // 这里可以保存头像路径到UserService
        // final userService = await UserService.getInstance();
        // await userService.saveUserProfile(avatarPath: image.path);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('头像已更新')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('选择图片失败: $e')),
        );
      }
    }
  }

  void _editNickname() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _nickname);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('修改昵称'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '请输入昵称',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                final newNickname = controller.text.trim();
                if (newNickname.isNotEmpty) {
                  final userService = await UserService.getInstance();
                  await userService.saveUserProfile(nickname: newNickname);
                  
                  if (mounted) {
                    setState(() {
                      _nickname = newNickname;
                    });
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  void _editHeight() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBasicInfoScreen(
          currentHeight: _height,
          currentWeight: _weight,
        ),
      ),
    );

    if (result != null && mounted) {
      final userService = await UserService.getInstance();
      await userService.saveUserProfile(
        height: result['height'],
        weight: result['weight'],
      );
      
      setState(() {
        _height = result['height'];
        _weight = result['weight'];
      });
    }
  }

  void _editWeight() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBasicInfoScreen(
          currentHeight: _height,
          currentWeight: _weight,
        ),
      ),
    );

    if (result != null && mounted) {
      final userService = await UserService.getInstance();
      await userService.saveUserProfile(
        height: result['height'],
        weight: result['weight'],
      );
      
      setState(() {
        _height = result['height'];
        _weight = result['weight'];
      });
    }
  }

  void _editInterests() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditInterestsScreen(
          currentInterests: _interests,
        ),
      ),
    );

    if (result != null && mounted) {
      final userService = await UserService.getInstance();
      await userService.saveUserProfile(
        interests: List<String>.from(result),
      );
      
      setState(() {
        _interests = List<String>.from(result);
      });
    }
  }

  void _viewFavorites() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoritesScreen(),
      ),
    );
    
    // 返回后重新加载收藏数量
    final favService = await FavoritesService.getInstance();
    final favCount = await favService.getFavoriteCount();
    
    if (mounted) {
      setState(() {
        _favoriteCount = favCount;
      });
    }
  }
}

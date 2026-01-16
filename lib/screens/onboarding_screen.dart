import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/user_service.dart';
import '../widgets/teen_mode_dialog.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // 用户选择的数据
  String? _selectedHeight;
  String? _selectedWeight;
  final Set<String> _selectedInterests = {};

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() async {
    final userService = await UserService.getInstance();
    
    // 保存用户选择的信息
    await userService.saveUserProfile(
      height: _selectedHeight,
      weight: _selectedWeight,
      interests: _selectedInterests.toList(),
    );
    
    // 标记引导已完成
    await userService.setOnboardingCompleted(true);
    
    if (mounted) {
      // 显示青少年模式弹窗
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => TeenModeDialog(
          onConfirm: () {
            // 进入主页
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.darkGray),
                onPressed: _previousPage,
              )
            : null,
        actions: [
          TextButton(
            onPressed: _skipOnboarding,
            child: const Text(
              '跳过',
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.softGray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 进度指示器
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                    decoration: BoxDecoration(
                      color: index <= _currentPage
                          ? AppTheme.vitalOrange
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          // 页面内容
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildHeightPage(),
                _buildWeightPage(),
                _buildInterestsPage(),
              ],
            ),
          ),
          
          // 底部按钮
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _canProceed() ? _nextPage : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.vitalOrange,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _currentPage < 2 ? '下一步' : '完成',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentPage) {
      case 0:
        return _selectedHeight != null;
      case 1:
        return _selectedWeight != null;
      case 2:
        return _selectedInterests.isNotEmpty;
      default:
        return false;
    }
  }

  Widget _buildHeightPage() {
    final heights = [
      '150cm以下',
      '150-160cm',
      '160-170cm',
      '170-180cm',
      '180-190cm',
      '190cm以上',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            '您的身高范围',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '帮助我们为您推荐更合适的训练计划',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),
          ...heights.map((height) {
            final isSelected = _selectedHeight == height;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedHeight = height;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.vitalOrange.withValues(alpha: 0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.vitalOrange
                        : Colors.grey[200]!,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        height,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? AppTheme.vitalOrange : AppTheme.darkGray,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: AppTheme.vitalOrange,
                        size: 24,
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeightPage() {
    final weights = [
      '40kg以下',
      '40-50kg',
      '50-60kg',
      '60-70kg',
      '70-80kg',
      '80-90kg',
      '90kg以上',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            '您的体重范围',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '帮助我们为您推荐更合适的训练强度',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),
          ...weights.map((weight) {
            final isSelected = _selectedWeight == weight;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedWeight = weight;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.vitalOrange.withValues(alpha: 0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.vitalOrange
                        : Colors.grey[200]!,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        weight,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? AppTheme.vitalOrange : AppTheme.darkGray,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: AppTheme.vitalOrange,
                        size: 24,
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInterestsPage() {
    final interests = [
      {'icon': Icons.directions_run, 'title': '跑步'},
      {'icon': Icons.fitness_center, 'title': '力量训练'},
      {'icon': Icons.self_improvement, 'title': '瑜伽'},
      {'icon': Icons.sports_martial_arts, 'title': '有氧运动'},
      {'icon': Icons.pool, 'title': '游泳'},
      {'icon': Icons.sports_basketball, 'title': '球类运动'},
      {'icon': Icons.hiking, 'title': '户外运动'},
      {'icon': Icons.spa, 'title': '拉伸放松'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            '您感兴趣的运动',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '可以选择多个，我们会为您推荐相关内容',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: interests.map((interest) {
              final title = interest['title'] as String;
              final isSelected = _selectedInterests.contains(title);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedInterests.remove(title);
                    } else {
                      _selectedInterests.add(title);
                    }
                  });
                },
                child: Container(
                  width: (MediaQuery.of(context).size.width - 60) / 2,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.vitalOrange.withValues(alpha: 0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.vitalOrange
                          : Colors.grey[200]!,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        interest['icon'] as IconData,
                        size: 32,
                        color: isSelected ? AppTheme.vitalOrange : Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? AppTheme.vitalOrange : AppTheme.darkGray,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

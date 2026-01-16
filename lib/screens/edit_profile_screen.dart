import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentHeight;
  final String currentWeight;
  final List<String> currentInterests;

  const EditProfileScreen({
    super.key,
    required this.currentHeight,
    required this.currentWeight,
    required this.currentInterests,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String _selectedHeight;
  late String _selectedWeight;
  late Set<String> _selectedInterests;

  @override
  void initState() {
    super.initState();
    _selectedHeight = widget.currentHeight;
    _selectedWeight = widget.currentWeight;
    _selectedInterests = widget.currentInterests.toSet();
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
          '编辑个人信息',
          style: TextStyle(
            color: AppTheme.darkGray,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, {
                'height': _selectedHeight,
                'weight': _selectedWeight,
                'interests': _selectedInterests.toList(),
              });
            },
            child: const Text(
              '保存',
              style: TextStyle(
                color: AppTheme.vitalOrange,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // 身高选择
          const Text(
            '身高',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 12),
          ..._buildHeightOptions(),
          
          const SizedBox(height: 32),
          
          // 体重选择
          const Text(
            '体重',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 12),
          ..._buildWeightOptions(),
          
          const SizedBox(height: 32),
          
          // 运动兴趣
          const Text(
            '运动兴趣',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _buildInterestOptions(),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  List<Widget> _buildHeightOptions() {
    final heights = [
      '150cm以下',
      '150-160cm',
      '160-170cm',
      '170-180cm',
      '180-190cm',
      '190cm以上',
    ];

    return heights.map((height) {
      final isSelected = _selectedHeight == height;
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedHeight = height;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.vitalOrange.withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
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
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? AppTheme.vitalOrange : AppTheme.darkGray,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.vitalOrange,
                  size: 22,
                ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildWeightOptions() {
    final weights = [
      '40kg以下',
      '40-50kg',
      '50-60kg',
      '60-70kg',
      '70-80kg',
      '80-90kg',
      '90kg以上',
    ];

    return weights.map((weight) {
      final isSelected = _selectedWeight == weight;
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedWeight = weight;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.vitalOrange.withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
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
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? AppTheme.vitalOrange : AppTheme.darkGray,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.vitalOrange,
                  size: 22,
                ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildInterestOptions() {
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

    return interests.map((interest) {
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.vitalOrange.withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
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
                size: 28,
                color: isSelected ? AppTheme.vitalOrange : Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppTheme.vitalOrange : AppTheme.darkGray,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

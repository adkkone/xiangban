import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EditInterestsScreen extends StatefulWidget {
  final List<String> currentInterests;

  const EditInterestsScreen({
    super.key,
    required this.currentInterests,
  });

  @override
  State<EditInterestsScreen> createState() => _EditInterestsScreenState();
}

class _EditInterestsScreenState extends State<EditInterestsScreen> {
  late Set<String> _selectedInterests;

  @override
  void initState() {
    super.initState();
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
          '编辑运动兴趣',
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
              Navigator.pop(context, _selectedInterests.toList());
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
          Text(
            '选择您感兴趣的运动',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
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

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class KnowledgeArticleDetailScreen extends StatelessWidget {
  final String title;
  final String category;
  final String imageUrl;
  final String content;

  const KnowledgeArticleDetailScreen({
    super.key,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.darkGray),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          category,
          style: const TextStyle(
            color: AppTheme.darkGray,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头图
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 240,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                );
              },
            ),
            
            Padding(
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
                      category,
                      style: const TextStyle(
                        color: AppTheme.vitalOrange,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 标题
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGray,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // 阅读时间
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '阅读时间 3 分钟',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // 分割线
                  Divider(color: Colors.grey[200], height: 1),
                  const SizedBox(height: 24),
                  
                  // 正文内容
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.darkGray,
                      height: 1.8,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // 相关推荐标签
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.offWhite,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.lightbulb_outline, size: 20, color: AppTheme.vitalOrange),
                            SizedBox(width: 8),
                            Text(
                              '小贴士',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkGray,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getTip(category),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTip(String category) {
    if (category.contains('体能') || category.contains('科学')) {
      return '建议在专业教练的指导下进行训练，避免运动损伤。记得在运动前做好热身，运动后进行拉伸放松。';
    } else if (category.contains('恢复')) {
      return '充足的休息和恢复对于提高运动表现至关重要。建议每周至少安排1-2天的完全休息日。';
    } else if (category.contains('饮食') || category.contains('营养')) {
      return '均衡饮食是健康的基础。建议多吃新鲜蔬果，适量摄入优质蛋白质，控制糖分和油脂的摄入。';
    } else {
      return '保持规律的运动习惯和健康的生活方式，是长期健康的关键。';
    }
  }
}

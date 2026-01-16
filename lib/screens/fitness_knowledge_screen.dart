import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'knowledge_article_detail_screen.dart';

class FitnessKnowledgeScreen extends StatelessWidget {
  const FitnessKnowledgeScreen({super.key});

  final List<Map<String, String>> _knowledgeList = const [
    {
      'title': '肌肉生长的科学原理',
      'content': '了解肌肉如何通过训练和恢复实现增长，掌握科学的训练方法让你的健身事半功倍。',
      'image': 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '体能科学',
    },
    {
      'title': '拉伸与放松技巧',
      'content': '正确的拉伸能有效预防运动损伤，促进肌肉恢复。学习专业的拉伸方法，让训练更安全。',
      'image': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '运动恢复',
    },
    {
      'title': '有氧运动的最佳心率区间',
      'content': '掌握不同心率区间的训练效果，科学控制运动强度，让有氧训练更高效。',
      'image': 'https://images.unsplash.com/photo-1483721310020-03333e577078?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '体能科学',
    },
    {
      'title': '核心力量训练指南',
      'content': '强大的核心是所有运动的基础。系统的核心训练能提升运动表现，改善体态。',
      'image': 'https://images.unsplash.com/photo-1599058917212-d750089bc07e?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '力量训练',
    },
    {
      'title': '运动后的恢复策略',
      'content': '科学的恢复与训练同样重要。了解冷身、补水、营养补充等恢复要点。',
      'image': 'https://images.unsplash.com/photo-1549060279-7e168fcee0c2?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '运动恢复',
    },
    {
      'title': '柔韧性训练的重要性',
      'content': '良好的柔韧性能提升运动表现，减少受伤风险。每天10分钟柔韧性训练很有必要。',
      'image': 'https://images.unsplash.com/photo-1588286840104-8957b019727f?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '体能科学',
    },
    {
      'title': '间歇训练的燃脂效果',
      'content': 'HIIT高强度间歇训练能在短时间内达到最佳燃脂效果，适合忙碌的现代人。',
      'image': 'https://images.unsplash.com/photo-1601422407692-ec4eeec1d9b3?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '燃脂训练',
    },
    {
      'title': '运动损伤的预防与处理',
      'content': '了解常见运动损伤的预防方法和应急处理，让你的运动之路更安全顺畅。',
      'image': 'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '运动恢复',
    },
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
          '体能基础知识',
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
        itemCount: _knowledgeList.length,
        itemBuilder: (context, index) {
          final item = _knowledgeList[index];
          return _buildKnowledgeItem(item, index == _knowledgeList.length - 1, context);
        },
      ),
    );
  }

  Widget _buildKnowledgeItem(Map<String, String> item, bool isLast, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KnowledgeArticleDetailScreen(
              title: item['title']!,
              category: item['category']!,
              imageUrl: item['image']!,
              content: _getArticleContent(item['title']!),
            ),
          ),
        );
      },
      child: Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 左侧配图
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item['image']!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 40, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          // 右侧内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.vitalOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item['category']!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.vitalOrange,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['title']!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGray,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  item['content']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.softGray,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  String _getArticleContent(String title) {
    if (title.contains('肌肉生长')) {
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
    } else if (title.contains('拉伸')) {
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
    } else if (title.contains('心率')) {
      return '''有氧运动的效果很大程度上取决于运动时的心率区间。了解并掌握不同心率区间的训练效果，能让你的有氧训练更加科学高效。

**最大心率的计算**

最大心率（MHR）= 220 - 年龄

例如，30岁的人最大心率约为190次/分钟。

**五大心率区间**

1. 热身区（50-60% MHR）
- 适合：热身、冷身、恢复训练
- 效果：促进血液循环，准备身体进入运动状态
- 感受：非常轻松，可以轻松交谈

2. 燃脂区（60-70% MHR）
- 适合：减脂、长时间有氧运动
- 效果：主要消耗脂肪供能
- 感受：轻松，可以持续较长时间

3. 有氧区（70-80% MHR）
- 适合：提升心肺功能
- 效果：增强心血管系统，提高耐力
- 感受：中等强度，呼吸加快但仍可交谈

4. 无氧区（80-90% MHR）
- 适合：提升速度和力量
- 效果：提高乳酸阈值，增强爆发力
- 感受：较困难，呼吸急促，难以交谈

5. 最大努力区（90-100% MHR）
- 适合：短时间冲刺训练
- 效果：提升最大摄氧量和爆发力
- 感受：非常困难，只能维持短时间

**如何监测心率**

- 使用心率带或运动手表
- 手动测量：运动中停下，测量10秒脉搏×6
- 感知强度：根据呼吸和说话能力判断

**训练建议**

- 初学者：主要在燃脂区和有氧区训练
- 进阶者：结合不同心率区间的间歇训练
- 每周至少3次，每次30-60分钟

根据自己的目标选择合适的心率区间，让每一次训练都更有针对性。''';
    } else {
      return '''这是一篇关于${title}的专业文章。

通过科学的训练方法和正确的理论指导，你可以更有效地达成健身目标。

**核心要点**

1. 了解基础理论
掌握运动科学的基本原理，能帮助你更好地理解训练的意义和效果。

2. 循序渐进
不要急于求成，给身体足够的适应时间，避免过度训练和运动损伤。

3. 持之以恒
健身是一个长期的过程，保持规律的训练习惯比短期的高强度训练更重要。

4. 注重恢复
充足的休息和恢复是训练效果的保证，不要忽视睡眠和营养的重要性。

**实践建议**

- 制定合理的训练计划
- 记录训练数据和身体变化
- 定期评估和调整训练方案
- 寻求专业指导

记住，科学的方法加上坚持不懈的努力，一定能让你达成健身目标。''';
    }
  }
}

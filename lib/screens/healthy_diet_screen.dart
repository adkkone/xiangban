import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'knowledge_article_detail_screen.dart';

class HealthyDietScreen extends StatelessWidget {
  const HealthyDietScreen({super.key});

  final List<Map<String, String>> _dietList = const [
    {
      'title': '牛油果的营养价值',
      'content': '富含健康脂肪和多种维生素，是健身人士的理想食物。了解如何将牛油果融入日常饮食。',
      'image': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '纯净饮食',
    },
    {
      'title': '蛋白质摄入完全指南',
      'content': '蛋白质是肌肉生长的关键。了解每日所需蛋白质量，以及优质蛋白质来源。',
      'image': 'https://images.unsplash.com/photo-1532550907401-a500c9a57435?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '营养补充',
    },
    {
      'title': '运动前后的饮食策略',
      'content': '正确的运动前后饮食能提升训练效果，加速恢复。掌握最佳进食时机和食物选择。',
      'image': 'https://images.unsplash.com/photo-1547592180-85f173990554?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '运动营养',
    },
    {
      'title': '碳水化合物的正确摄入',
      'content': '碳水不是敌人，关键在于选择和时机。了解优质碳水来源，为训练提供充足能量。',
      'image': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '营养补充',
    },
    {
      'title': '减脂期的饮食计划',
      'content': '科学的减脂饮食不是节食，而是合理控制热量摄入。学习制定适合自己的减脂餐单。',
      'image': 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '减脂饮食',
    },
    {
      'title': '增肌期的营养策略',
      'content': '增肌需要热量盈余和充足蛋白质。了解如何通过饮食支持肌肉生长。',
      'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '增肌饮食',
    },
    {
      'title': '健康脂肪的重要性',
      'content': '不要害怕脂肪，选择健康的脂肪来源对身体有益。坚果、鱼油都是好选择。',
      'image': 'https://images.unsplash.com/photo-1559181567-c3190ca9959b?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '纯净饮食',
    },
    {
      'title': '补剂的选择与使用',
      'content': '蛋白粉、肌酸等补剂能辅助训练，但不能替代正常饮食。了解如何正确使用补剂。',
      'image': 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
      'category': '营养补充',
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
          '健康饮食',
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
        itemCount: _dietList.length,
        itemBuilder: (context, index) {
          final item = _dietList[index];
          return _buildDietItem(item, index == _dietList.length - 1, context);
        },
      ),
    );
  }

  Widget _buildDietItem(Map<String, String> item, bool isLast, BuildContext context) {
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
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item['category']!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
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
    if (title.contains('牛油果')) {
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

将牛油果融入日常饮食，享受健康美味的同时，为身体补充优质营养。''';
    } else if (title.contains('蛋白质')) {
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

记住，蛋白质只是营养拼图的一部分。配合碳水化合物、健康脂肪和充足的蔬果，才能构建完整的运动营养方案。''';
    } else if (title.contains('运动前后')) {
      return '''正确的运动前后饮食策略能显著提升训练效果，加速身体恢复，让你的每一次训练都更有价值。

**运动前饮食（1-2小时前）**

**目标：**
- 提供充足能量
- 避免消化不适
- 稳定血糖水平

**推荐食物：**
- 香蕉+花生酱
- 燕麦+蓝莓
- 全麦面包+鸡蛋
- 希腊酸奶+水果

**注意事项：**
- 避免高脂肪食物（消化慢）
- 避免高纤维食物（可能引起不适）
- 充足补水

**运动后饮食（30分钟-2小时内）**

**目标：**
- 补充糖原储备
- 修复肌肉组织
- 促进恢复

**黄金比例：**
碳水化合物：蛋白质 = 3:1 或 4:1

**推荐食物：**
- 鸡胸肉+糙米+蔬菜
- 三文鱼+红薯+沙拉
- 蛋白奶昔+香蕉
- 希腊酸奶+燕麦+水果

**补水策略：**
- 运动前2小时：400-600ml水
- 运动中：每15-20分钟150-250ml
- 运动后：体重每减少0.5kg补充500-750ml

**不同训练类型的饮食调整**

**力量训练：**
- 运动前：中等碳水+适量蛋白质
- 运动后：高蛋白+中等碳水

**有氧训练：**
- 运动前：高碳水+低蛋白质
- 运动后：中等碳水+适量蛋白质

**HIIT训练：**
- 运动前：快速消化的碳水
- 运动后：高碳水+高蛋白质

掌握正确的运动营养时机，让你的训练效果事半功倍。''';
    } else {
      return '''这是一篇关于${title}的营养指南。

合理的饮食是健康生活和运动表现的基础。通过科学的营养搭配，你可以更好地支持训练目标。

**核心原则**

1. 均衡饮食
确保摄入足够的蛋白质、碳水化合物和健康脂肪，以及丰富的维生素和矿物质。

2. 适量摄入
根据自己的运动量和目标调整热量摄入，避免过量或不足。

3. 食物多样化
不同食物提供不同营养素，多样化的饮食能确保营养全面。

4. 注重时机
在正确的时间摄入正确的营养，能最大化训练效果。

**实践建议**

- 记录饮食日记，了解自己的摄入情况
- 提前准备健康餐食，避免临时选择不健康食物
- 多吃天然食物，少吃加工食品
- 保持充足水分摄入

**常见误区**

- 过度节食会降低代谢，影响训练表现
- 单一食物减肥法不可持续
- 补剂不能替代正常饮食
- 碳水化合物不是敌人，关键在于选择和时机

记住，健康饮食是一个长期的生活方式，不是短期的节食计划。找到适合自己的饮食模式，享受健康美食的同时达成健身目标。''';
    }
  }
}

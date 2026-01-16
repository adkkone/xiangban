# 相伴健身App - 快速参考

## 📁 完整文件列表

### 核心应用文件
```
lib/
├── main.dart                           # 应用入口
├── theme/
│   └── app_theme.dart                 # 主题配置
├── screens/
│   ├── home_screen.dart               # 主屏幕（导航）
│   ├── plan_view.dart                 # 计划页面
│   ├── discover_view.dart             # 发现页面
│   └── stats_view.dart                # 统计页面
├── widgets/
│   ├── workout_card.dart              # 训练卡片
│   ├── quick_action_card.dart         # 快速动作卡片
│   ├── energy_ring.dart               # 能量环
│   └── custom_icons.dart              # 图标封装
├── models/
│   ├── workout.dart                   # 训练模型
│   └── stats.dart                     # 统计模型
├── data/
│   └── workout_data.dart              # 数据源
└── services/
    └── storage_service.dart           # 存储服务
```

## 🎨 主题颜色

```dart
// 主色
vitalOrange: #FF8C42
energyRed: #FF3B30

// 背景
offWhite: #FAFAFA
pureWhite: #FFFFFF

// 文字
darkGray: #1F2937
softGray: #9CA3AF

// 功能色
successGreen: #10B981
```

## 📐 设计规范

### 圆角
- 大卡片: 32px
- 中等模块: 24px
- 按钮: 全圆角

### 字体大小
- H1: 30pt (Bold)
- H2: 24pt (Bold)
- H3: 18pt (Semibold)
- Body: 14pt (Regular)
- Caption: 12pt (Medium)

### 间距
- 页面边距: 24px
- 卡片间距: 16-20px
- 元素间距: 8-12px

## 🚀 常用命令

```bash
# 安装依赖
flutter pub get

# 运行应用
flutter run

# 代码分析
flutter analyze

# 运行测试
flutter test

# 构建APK
flutter build apk

# 清理项目
flutter clean
```

## 📱 页面结构

### 计划页面
```
- 标题区域
  - "相伴"
  - "Sweat Today?" (渐变)
  - 推荐数量提示
- 横向卡片区
  - 日落慢跑 (45min)
  - 燃脂燃烧 (20min)
- 快速动作列表
  - 晨间拉伸 (10min)
  - 冥想 (15min)
```

### 发现页面
```
- 标题区域
- 精选故事横幅
- 2x2 网格
  - 体能科学
  - 纯净饮食
- 社区挑战卡片
```

### 统计页面
```
- 标题区域
- 能量环卡片
  - 进度百分比
  - 时长/卡路里/心率
- 成就网格
  - 勋章数量
  - 总时长
- 最近动态列表
```

## 🔧 快速修改指南

### 修改主题颜色
📄 `lib/theme/app_theme.dart`
```dart
static const Color vitalOrange = Color(0xFFFF8C42);
```

### 添加训练课程
📄 `lib/data/workout_data.dart`
```dart
Workout(
  id: '3',
  title: '新训练',
  description: '描述',
  duration: 30,
  intensity: '中等',
  imageUrl: 'https://...',
  category: 'cardio',
)
```

### 修改默认统计数据
📄 `lib/services/storage_service.dart`
```dart
WorkoutStats(
  todayProgress: 75.0,
  todayMinutes: 45,
  todayCalories: 320,
  // ...
)
```

### 添加新图标
📄 `lib/widgets/custom_icons.dart`
```dart
static Widget newIcon({double size = 24, Color? color}) {
  return Icon(Icons.icon_name, size: size, color: color);
}
```

## 📊 数据模型

### Workout
```dart
{
  id: String,
  title: String,
  description: String,
  duration: int,
  intensity: String,
  imageUrl: String,
  category: String
}
```

### WorkoutStats
```dart
{
  todayProgress: double,
  todayMinutes: int,
  todayCalories: int,
  todayHeartRate: int,
  totalAchievements: int,
  totalHours: double,
  recentWorkouts: List<WorkoutHistory>
}
```

## 🎯 关键组件

### EnergyRing
```dart
EnergyRing(progress: 75.0)
// 动画时长: 1500ms
// 曲线: Curves.easeOut
```

### WorkoutCard
```dart
WorkoutCard(
  workout: workout,
  onTap: () {},
)
// 尺寸: 280x360
// 圆角: 32px
```

### QuickActionCard
```dart
QuickActionCard(
  workout: workout,
  onTap: () {},
)
// 圆角: 20px
```

## 🔄 状态管理

### 使用 setState
```dart
setState(() {
  _currentIndex = index;
});
```

### 数据持久化
```dart
// 保存
await _storageService.saveStats(stats);

// 加载
final stats = await _storageService.loadStats();
```

## 🎨 动画效果

### 页面切换
- 时长: 300ms
- 效果: 淡入淡出

### 导航栏
- 时长: 300ms
- 效果: 上浮 -12px

### 能量环
- 时长: 1500ms
- 效果: 填充动画

## 📝 代码规范

### 命名
- 文件: snake_case
- 类: PascalCase
- 变量: camelCase
- 常量: camelCase (static const)

### 导入顺序
1. Dart SDK
2. Flutter SDK
3. 第三方包
4. 项目文件

### 组件结构
```dart
class MyWidget extends StatelessWidget {
  // 1. 构造函数
  const MyWidget({super.key});
  
  // 2. build方法
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

## 🐛 调试技巧

### 查看日志
```bash
flutter logs
```

### 性能分析
```bash
flutter run --profile
```

### 热重载
- 保存文件自动重载
- 或按 `r` 键

### 热重启
- 按 `R` 键

## 📚 相关文档

- `README.md` - 产品需求文档
- `PROJECT_STRUCTURE.md` - 项目结构
- `FILES_SUMMARY.md` - 文件清单
- `USAGE_GUIDE.md` - 使用指南
- `DEVELOPMENT_SUMMARY.md` - 开发总结

## ✅ 检查清单

开发前检查:
- [ ] Flutter SDK 已安装
- [ ] 依赖已安装 (flutter pub get)
- [ ] 设备已连接

提交前检查:
- [ ] flutter analyze 通过
- [ ] 代码已格式化
- [ ] 注释已添加
- [ ] 文档已更新

发布前检查:
- [ ] 测试通过
- [ ] 性能优化
- [ ] 图片URL有效
- [ ] 版本号更新

## 🎉 快速开始

```bash
# 1. 克隆项目
cd xiangban

# 2. 安装依赖
flutter pub get

# 3. 运行应用
flutter run

# 4. 开始开发！
```

---

💡 提示: 保存此文件以便快速查找常用信息！

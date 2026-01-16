# 相伴健身App - 使用指南

## 快速开始

### 1. 环境要求
- Flutter SDK 3.10.4 或更高版本
- Dart SDK
- iOS/Android 模拟器或真机

### 2. 安装依赖
```bash
flutter pub get
```

### 3. 运行应用
```bash
# 在模拟器或真机上运行
flutter run

# 指定设备运行
flutter run -d <device_id>

# 查看可用设备
flutter devices
```

### 4. 构建应用
```bash
# Android APK
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

## 应用功能说明

### 主界面导航
应用包含三个主要页面，通过底部导航栏切换：

#### 1. 计划页面（首页）
- **今日推荐**：横向滑动查看推荐的训练课程
  - 每个卡片显示训练图片、时长、强度和描述
  - 点击播放按钮开始训练
- **快速动作**：快速访问短时间训练
  - 晨间拉伸（10分钟）
  - 冥想（15分钟）

#### 2. 发现页面
- **精选故事**：健身达人的励志故事
- **体能科学**：健身知识科普
- **纯净饮食**：健康食谱推荐
- **社区挑战**：参与月度挑战活动

#### 3. 统计页面
- **能量环**：显示今日运动目标完成度
  - 动态填充动画
  - 百分比显示
- **关键数据**：
  - 运动时长（分钟）
  - 消耗卡路里
  - 平均心率
- **成就统计**：
  - 获得的勋章数量
  - 总运动时长
- **最近动态**：查看最近的运动记录

### 交互说明

#### 顶部栏
- **用户头像**：显示当前用户（带活力光圈）
- **欢迎语**：根据时间显示问候
- **日历按钮**：快速查看月度计划（功能预留）

#### 底部导航
- 点击图标切换页面
- 激活的标签会上浮并显示渐变色
- 带有触觉反馈

#### 卡片交互
- 训练卡片可以横向滑动浏览
- 悬停时有缩放效果
- 点击播放按钮开始训练（功能预留）

## 数据存储

应用使用 SharedPreferences 存储以下数据：
- 运动统计数据
- 训练历史记录
- 用户进度

数据会自动保存，重启应用后会自动加载。

## 自定义配置

### 修改主题颜色
编辑 `lib/theme/app_theme.dart`：
```dart
static const Color vitalOrange = Color(0xFFFF8C42);  // 主色
static const Color energyRed = Color(0xFFFF3B30);    // 强调色
```

### 添加训练课程
编辑 `lib/data/workout_data.dart`：
```dart
Workout(
  id: 'new_id',
  title: '新训练',
  description: '描述',
  duration: 30,
  intensity: '中等',
  imageUrl: 'https://...',
  category: 'cardio',
)
```

### 修改统计数据
编辑 `lib/services/storage_service.dart` 中的 `_getDefaultStats()` 方法。

## 开发建议

### 添加新页面
1. 在 `lib/screens/` 创建新的视图文件
2. 在 `home_screen.dart` 中添加导航项
3. 更新 `_buildCurrentView()` 方法

### 添加新组件
1. 在 `lib/widgets/` 创建组件文件
2. 遵循现有的命名和结构规范
3. 使用 AppTheme 中定义的颜色和样式

### 添加新数据模型
1. 在 `lib/models/` 创建模型文件
2. 实现 `toJson()` 和 `fromJson()` 方法
3. 在 `storage_service.dart` 中添加存储逻辑

## 常见问题

### Q: 图片加载失败怎么办？
A: 应用使用网络图片，需要确保设备有网络连接。如果图片URL失效，会显示占位符。

### Q: 如何重置数据？
A: 卸载并重新安装应用，或清除应用数据。

### Q: 如何添加更多训练课程？
A: 编辑 `lib/data/workout_data.dart` 文件，添加新的 Workout 对象。

### Q: 能否离线使用？
A: 应用的UI和功能可以离线使用，但训练卡片的图片需要网络加载。

## 性能优化建议

1. **图片优化**：使用适当尺寸的图片URL
2. **列表优化**：大量数据时使用 ListView.builder
3. **动画优化**：避免过度使用动画
4. **状态管理**：考虑使用 Provider 或 Riverpod（如需扩展）

## 调试技巧

```bash
# 查看日志
flutter logs

# 性能分析
flutter run --profile

# 检查代码质量
flutter analyze

# 运行测试
flutter test
```

## 联系支持

如有问题或建议，请查看项目文档：
- PROJECT_STRUCTURE.md - 项目结构说明
- FILES_SUMMARY.md - 文件清单
- README.md - 产品需求文档

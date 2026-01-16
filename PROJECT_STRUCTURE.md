# 相伴健身App - 项目结构说明

## 项目概述
这是一个基于Flutter开发的健身应用，遵循README.md中的设计规范和index.html的原型设计。

## 技术栈
- Flutter SDK 3.10.4+
- Dart
- shared_preferences (数据持久化)
- 状态管理：setState

## 项目结构

```
lib/
├── main.dart                    # 应用入口
├── theme/
│   └── app_theme.dart          # 主题配置（颜色、字体、渐变）
├── screens/
│   ├── home_screen.dart        # 主屏幕（包含底部导航）
│   ├── plan_view.dart          # 计划页面（首页）
│   ├── discover_view.dart      # 发现页面
│   └── stats_view.dart         # 统计页面
├── widgets/
│   ├── workout_card.dart       # 训练卡片组件
│   ├── quick_action_card.dart  # 快速动作卡片
│   ├── energy_ring.dart        # 能量环组件（带动画）
│   └── custom_icons.dart       # 自定义图标封装
├── models/
│   ├── workout.dart            # 训练数据模型
│   └── stats.dart              # 统计数据模型
├── data/
│   └── workout_data.dart       # 训练数据源
└── services/
    └── storage_service.dart    # 数据存储服务
```

## 核心功能

### 1. 计划页面 (Plan View)
- 今日推荐训练（横向滑动卡片）
- 快速动作列表
- 渐变标题效果

### 2. 发现页面 (Discover View)
- 精选故事横幅
- 体能科学和纯净饮食模块
- 社区挑战卡片

### 3. 统计页面 (Stats View)
- 动态能量环（显示今日进度）
- 关键数据展示（时长、卡路里、心率）
- 成就勋章统计
- 最近运动历史

### 4. 底部导航
- 三个标签：计划、发现、我的
- 激活状态带上浮动画
- 渐变色高亮效果

## 设计特点

### 颜色系统
- 主色：Vital Orange (#FF8C42)
- 强调色：Energy Red (#FF3B30)
- 背景：Off White (#FAFAFA)
- 文字：Dark Gray (#1F2937)

### 动画效果
- 页面切换：淡入淡出
- 能量环：填充动画
- 导航栏：上浮效果
- 卡片：悬停缩放

### 圆角规范
- 卡片：32px
- 按钮：全圆角
- 小模块：24px

## 数据持久化
使用 shared_preferences 存储：
- 训练统计数据
- 用户进度
- 历史记录

## 运行项目

```bash
# 安装依赖
flutter pub get

# 运行应用
flutter run

# 分析代码
flutter analyze

# 运行测试
flutter test
```

## 注意事项
1. 不使用 freezed 包和 part 语法
2. 状态管理使用 setState
3. 不需要本地图片资源
4. 不需要 cached_network_image
5. 不需要账户功能
6. 不需要外部字体
7. 不需要 share_plus

## 扩展建议
- 添加更多训练课程数据
- 实现训练计时器功能
- 添加训练历史详情页
- 实现数据图表展示
- 添加用户设置页面

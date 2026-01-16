相伴 健身 App - 产品需求与 UI 设计规范文档

版本: 1.1

状态: 高保真原型已完成

最后更新: 2024-05-20

1. 产品概述 (Product Overview)

1.1 产品定位

相伴 是一款注重美学与心流体验的个人健身伴侣 App。它区别于传统工具类健身软件的枯燥与繁复，主张“让运动像呼吸一样自然”。通过极简的交互路径、沉浸式的视觉设计和碎片化的课程安排，帮助用户在繁忙的生活中找到运动的节奏。

1.2 目标用户

核心人群：25-35 岁城市白领，追求生活品质，拥有审美要求。

用户特征：时间碎片化，厌倦复杂的健身计划，需要情感化的激励而非冷冰冰的数据。

1.3 核心价值主张 (Value Proposition)

去列表化 (De-listing)：拒绝冗长的菜单，通过智能推荐和卡片流减少决策成本。

视觉化激励 (Visual Motivation)：用动态的色彩和图形反馈身体的能量变化。

沉浸式体验 (Immersive Flow)：从打开 App 的一刻起，通过微动效和渐变色营造专注的氛围。

2. 用户体验分析 (UX Analysis)

2.1 核心交互逻辑

App 的导航结构扁平化，仅保留底部的三个核心入口，分别对应运动的三个阶段：准备 (Plan) -> 探索 (Discover) -> 反馈 (Stats)。

首页即开始：用户打开 App 不需要进入二级菜单寻找课程，首屏即展示“今日最佳推荐”，点击“Play”一键开始。

横向浏览为主：主要内容区采用横向滑动（Snap Scroll），符合拇指操作习惯，且比垂直长列表更具探索感。

情感化反馈：所有的点击、达成目标都有细腻的微交互（如呼吸效果、弹性缩放），赋予 App 生命力。

2.2 操作路径优化

传统路径：打开App -> 点击课程库 -> 筛选部位 -> 筛选时长 -> 点击课程 -> 开始。

相伴 路径：打开App -> 滑动选择今日推荐卡片 -> 点击开始。

3. 功能需求详解 (Functional Requirements)

3.1 页面一：计划 (Plan) - 首页

Header 区域：

用户头像：左上角显示，带有动态光圈（表示今日活力值）。点击进入个人设置。

问候语：根据时间段自动变化（Good Morning / Ready to Sweat）。

日历入口：右上角悬浮按钮，快速查看月度计划。

今日推荐 (Cover Flow)：

交互：大尺寸卡片横向堆叠滑动。

内容：根据用户习惯推荐 2-3 个核心课程（如：日落跑、HIIT 燃脂）。

信息：动态背景图、课程时长、强度标签。

快速动作 (Quick Actions)：

列表：针对碎片时间的 5-10 分钟短课程（晨间拉伸、冥想）。

样式：胶囊状列表项，强调轻量感。

3.2 页面二：发现 (Discover) - 灵感

设计结构：专题模块化（Bento Grid 风格），拒绝无尽的信息流。

Banner 模块：

功能：展示健身达人故事或深度专题。

样式：全宽大图，沉浸式文字排版。

知识板块：

体能科学：科普健身知识，点击弹出详情卡片。

纯净饮食：健康食谱推荐，注重图片的食欲感。

社区挑战：

功能：展示当前热门的全民挑战活动，显示参与人数，营造归属感。

样式：深色背景卡片，区别于其他白色模块，强调独特性。

3.3 页面三：统计 (Stats) - 成就

能量环 (Energy Ring)：

核心视觉：页面中央巨大的动态圆环，通过渐变色的填充度显示今日运动目标（时长/卡路里）达成率。

动画：进入页面时，圆环有填充动画。

关键数据网格：

展示时长 (Time)、卡路里 (Cals)、平均心率 (BPM)。

勋章墙 (Achievements)：

以 3D 质感的图标展示获得的成就，未获得的显示为灰色轮廓。

历史动态：

简单的时间轴，列出最近两次的运动记录。

4. UI 设计规范 (UI Design System)

4.1 色彩系统 (Color Palette)

App 采用鲜明且温暖的色调，激发运动欲望。

颜色名称

色值 (Hex)

用途

Vital Orange

#FF8C42

主色渐变起始色，用于按钮、高亮、图标

Energy Red

#FF3B30

主色渐变结束色，用于强调、热量消耗

Pure White

#FFFFFF

卡片背景、文字反白

Off White

#FAFAFA

页面全局背景

Dark Gray

#1F2937

主标题文字

Soft Gray

#9CA3AF

辅助文字、未激活状态

Success Green

#10B981

健康饮食、达成目标

背景策略：避免纯白背景，使用 #FAFAFA 配合顶部 Linear Gradient (Orange/10% -> Transparent) 的光晕效果，营造通透感。

4.2 排版系统 (Typography)

追求现代、干净的无衬线字体风格。

字体家族：

iOS: San Francisco Pro Display / Text

Android: Roboto

层级标准：

H1 (大标题): 30pt / Bold / Tight Tracking (用于页面主标题)

H2 (卡片标题): 24pt / Bold (用于课程名称)

H3 (模块标题): 18pt / Semibold (用于板块名称)

Body (正文): 14pt / Regular (用于描述文本)

Caption (辅助): 12pt / Medium / Uppercase (用于标签、日期)

4.3 图标与组件 (Components)

圆角 (Border Radius)：

卡片: 32px (超大圆角，以此为特征)

按钮: Full Circle (全圆角)

小模块: 24px

阴影 (Shadows)：

悬浮感: 使用弥散阴影 0 20px 40px -10px rgba(255, 140, 66, 0.3)，让卡片看起来是浮在背景之上的。

Glassmorphism: 底部导航栏和顶部 Header 背景使用 backdrop-filter: blur(20px) 及 bg-white/80，呈现毛玻璃质感。

图标 (Iconography)：

使用线条风格图标 (Lucide / Feather)，线条宽度 2px，在选中状态下可切换为填充风格或渐变色风格。

4.4 动画与微交互 (Motion)

页面切换: 底部导航切换时，页面内容轻微上浮淡入 (Slide Up + Fade In)。

滚动: 列表滚动具有弹性阻尼效果。

点击反馈: 任何可点击元素在按下时缩小至 95% (Scale Down)。

5. 技术实现建议 (HTML/Tailwind)

基于原型代码的开发提示：

布局容器: 使用 flex flex-col 布局，配合 overflow-hidden 确保圆角内的内容不溢出。

隐藏滚动条: 在 CSS 中使用 .no-scrollbar 工具类 (需自定义或使用插件) 来隐藏默认滚动条，保持界面整洁。

渐变文本: 标题中的 "Sweat Today" 使用 bg-clip-text text-transparent bg-gradient-to-r 实现渐变文字效果。

Snap Scroll: 首页的横向卡片流必须使用 snap-x snap-center 属性，确保用户滑动时卡片能自动居中对齐。
# xiangban
# xiangban

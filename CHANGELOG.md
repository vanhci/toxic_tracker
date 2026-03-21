# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-03-21

### Added

#### 核心功能
- 任务管理（增删改查）
- 拍照上传（Web/移动端）
- Supabase Storage 集成
- 判决记录数据库
- 分享功能（share_plus）
- 教练选择系统
- 付费墙 UI
- 惩罚页面（30秒锁屏）
- 启动页视觉设计

#### 社交裂变引擎
- 强制拍照留证：鸽了必须拍照，没有照片不算数
- 分享给死党判决：生成分享链接，让死党当行刑官
- 远程处刑：死党选择"立刻处刑"，App 端触发30秒惩罚锁屏

#### 功能增强
- 耻辱海报生成器：受罚后生成带二维码的精美海报
- 成就系统：连续完成 N 天获得徽章（8个徽章）
- 数据统计：可视化展示鸽了多少次
- 更多教练人设：6位毒舌教练（Amanda、退堂鼓区长、扫兴的王主任、铁教练、刘班主任、无为大师）

#### 技术优化
- 离线模式支持：断网时照片暂存本地，联网后自动上传
- 深色模式：自动适应系统主题
- 多语言支持：中/英文
- 桌面小组件：iOS/Android 小组件实时显示任务状态
- Apple Watch 配套应用：SwiftUI Watch App
- 推送通知提醒：任务提醒和截止日期通知
- 自定义教练声音：TTS 语音 + 可配置音调/语速

#### 商业化扩展
- 订阅方案：月度¥9.9 / 年度¥68 / 终身¥98
- 企业版（团队监督）：团队创建、邀请码分享、鸽子排行榜

#### Web 端优化
- Emoji 字体支持：添加 Noto Color Emoji 字体
- 图片上传兼容性修复

### Technical Details

#### Dependencies
- Flutter SDK >= 3.0.0
- supabase_flutter: ^2.6.0
- purchases_flutter: ^8.1.0
- flutter_local_notifications: ^17.2.3
- home_widget: ^0.7.0
- flutter_tts: ^4.0.2
- audioplayers: ^6.1.0
- connectivity_plus: ^6.0.3
- share_plus: ^7.2.2
- image_picker: ^1.0.7

#### Code Quality
- Analysis: 0 warnings, 0 errors
- Tests: 40/40 passed
- Coverage: Task, Coach, Achievement, Team models, UI state, design

#### Project Statistics
- Dart files: 25
- Lines of code: 4,500+
- Git commits: 63+

### Deployment
- H5 判决页: https://judge-self.vercel.app
- Supabase Project: https://iyziuawpbpyvwhomtjkh.supabase.co

---

## Upcoming Features

### Pending User Action
- RevenueCat 配置（需注册开发者账号）
- App Store 上架（需苹果开发者账号）
- 完整流程测试

### Future Enhancements
- 小红书内容营销
- 抖音短视频推广
- 社群裂变活动
- A/B 测试定价策略

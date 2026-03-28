# Toxic Tracker（今天鸽了吗）

## 📖 项目愿景

### 解决什么问题？
Toxic Tracker 旨在解决自律应用市场的三大痛点：
1. **缺乏惩罚机制** - 传统自律 App 只有提醒，没有实质性惩罚，用户容易"假装没看见"
2. **动力不足** - 单纯的自我监督难以坚持，缺少外部压力和社交驱动
3. **体验同质化** - 主流自律应用界面和交互千篇一律，缺乏个性和趣味性

### 为什么独特？
- **毒舌风格**：独特的嘲讽文案 + 震撼音效，让拖延变得"痛苦"，真正刺激用户行动
- **死党监督**：邀请好友成为"死党"，逾期任务触发"处刑令"，社交压力驱动自律
- **处刑多样化**：多种处刑方式（毒舌语音、公开处刑、金钱惩罚），让惩罚有"仪式感"
- **反人性设计**：故意使用"逆向心理学"，用"嘲讽"代替"鼓励"，用"惩罚"代替"奖励"

---

## 🔥 核心功能机制

### 任务管理系统

#### 任务创建
```dart
class Task {
  String id;                // 任务 ID
  String title;             // 任务标题
  String description;       // 任务描述（可选）
  DateTime deadline;        // 截止时间
  TaskPriority priority;    // 优先级（低/中/高/紧急）
  List<String> tags;        // 标签（工作/学习/健康等）
  bool isCompleted;         // 完成状态
  DateTime? completedAt;    // 完成时间
  int overdueDays;          // 逾期天数
}
```

#### 逾期检测
- 自动检测任务是否逾期（当前时间 > 截止时间）
- 实时计算逾期天数
- 逾期任务标记为红色，显示"逾期 X 天"
- 支持逾期任务快速筛选

#### 连续失败统计
```dart
class UserStats {
  int consecutiveFailures;  // 连续逾期次数
  int consecutiveSuccesses; // 连续成功次数
  int totalTasks;           // 总任务数
  int completedTasks;       // 已完成任务数
  int overdueTasks;         // 逾期任务数
  double successRate;       // 成功率
}
```

**激励机制**：
- 连续成功 7 天：解锁"自律达人"称号
- 连续成功 30 天：解锁"自律大师"称号
- 连续失败 3 天：触发"紧急提醒"
- 连续失败 7 天：解锁"摆烂王"称号（嘲讽）

---

### 毒舌系统设计

#### 毒舌文案库

**逾期提醒文案**（按逾期天数分级）：
```dart
// 1-3 天逾期（轻度嘲讽）
"哟，又鸽了？你这拖延症晚期没治了吧 😏"
"我就知道你会鸽，毕竟你是'鸽子王'嘛 🕊️"
"截止日期对你来说是摆设吗？啧啧啧..."

// 4-7 天逾期（中度嘲讽）
"哇塞，连续鸽了 X 天！你是想打破吉尼斯纪录吗？ 🏆"
"你的任务列表比你的床还乱，服了服了 🛏️"
"照你这速度，蜗牛都能超车了 🐌"

// 8+ 天逾期（重度嘲讽）
"恭喜你！荣获'本年度最摆烂用户'称号！ 🎉"
"你的任务已经逾期一周了，是打算留到明年吗？ 📅"
"我见过拖延的，没见过你这么能拖的，人才！ 💀"
```

**处刑令文案**（死党发送）：
```dart
// 处刑开始
"咚咚咚！你的死党 [名字] 给你发来了处刑令！ ⚔️"
"[名字] 早就看不下去了，现在执行公开处刑！ 💀"
"准备好接受来自死党的爱的教育了吗？ 😈"

// 处刑进行中
"听听！这是你摆烂的声音！ 🔊"
"[名字] 说：你还有脸摆烂？给我起来干活！ 💪"
"公开处刑进行中...你的羞耻心还在吗？ 😳"

// 处刑结束
"处刑完毕！希望你下次能争点气！ 👊"
"[名字] 的处刑令已送达，下次别再让大家失望了！ ✨"
"记住这份羞耻，然后...去完成任务吧！ 🔥"
```

#### 毒舌语音系统

**语音合成（TTS）**：
- 使用 Flutter TTS 插件
- 支持中英文语音播报
- 可调节语速（慢速、正常、快速）
- 可调节音调（低沉、正常、尖锐）

**音效库**：
```dart
// 内置音效
- 'sarcasm.mp3'      // 嘲讽笑声
- 'slap.mp3'         // 巴掌声（处刑）
- 'alarm_harsh.mp3'  // 刺耳闹钟（紧急提醒）
- 'whip.mp3'         // 鞭子声（死党处刑）
- 'boo.mp3'          // 嘘声（失败）
- 'applause.mp3'     // 掌声（成功）
```

**语音触发场景**：
- 任务逾期提醒：播放毒舌语音 + 震动
- 收到处刑令：播放处刑语音 + 强震动
- 任务完成：播放鼓励语音（反差）
- 连续失败：播放"紧急拯救"语音

---

### 死党社交系统

#### 死党关系

**添加死党**：
```dart
class Team {
  String id;                // 团队 ID
  String name;              // 团队名称
  List<Member> members;     // 成员列表
  DateTime createdAt;       // 创建时间
  
  // 成员角色
  enum MemberRole {
    leader,    // 队长（创建者）
    member,    // 成员
  }
}

class Member {
  String userId;            // 用户 ID
  String name;              // 昵称
  String? avatar;           // 头像
  MemberRole role;          // 角色
  DateTime joinedAt;        // 加入时间
}
```

**死党功能**：
- 邀请好友（分享链接/二维码）
- 查看死党任务列表
- 查看死党完成率排行
- 发送处刑令

#### 处刑令系统

**处刑令类型**：
```dart
enum ExecutionType {
  verbal,        // 毒舌语音（免费）
  public,        // 公开处刑（免费）
  money,         // 金钱惩罚（需订阅）
  custom,        // 自定义处刑（需订阅）
}

class ExecutionOrder {
  String id;                // 处刑令 ID
  String fromUserId;        // 发送者 ID
  String toUserId;          // 接收者 ID
  String taskId;            // 关联任务 ID
  ExecutionType type;       // 处刑类型
  String? customMessage;    // 自定义消息
  int? penaltyAmount;       // 罚款金额（金钱处刑）
  DateTime createdAt;       // 发送时间
  bool isExecuted;          // 是否已执行
}
```

**处刑流程**：
```
1. 死党发现你逾期任务
    ↓
2. 点击"发送处刑令"
    ↓
3. 选择处刑类型
    ↓
4. 编辑自定义消息（可选）
    ↓
5. 发送处刑令
    ↓
6. 接收者收到通知 + 播放处刑语音 + 强震动
    ↓
7. 处刑令记录到"处刑历史"
```

#### 社交排行榜

**死党排行榜**：
```dart
class Leaderboard {
  // 本周成功率排行
  List<RankingEntry> weeklySuccessRate;
  
  // 本月完成任务数排行
  List<RankingEntry> monthlyCompletedTasks;
  
  // 总成功率排行
  List<RankingEntry> allTimeSuccessRate;
  
  // "摆烂王"排行（逾期最多）
  List<RankingEntry> slackerRanking;
}

class RankingEntry {
  String userId;
  String name;
  String? avatar;
  double score;     // 成功率或完成数
  int rank;         // 排名
}
```

**社交压力机制**：
- 逾期任务自动通知所有死党
- 死党可以看到你的"摆烂记录"
- 排行榜公开展示，激励良性竞争
- "摆烂王"排行榜（反向激励）

---

### 处刑令多样化设计

#### 免费处刑类型

**1. 毒舌语音处刑**：
- 系统随机选择毒舌文案
- TTS 语音播报 + 震动
- 持续时间：5-10 秒
- 不可跳过（必须听完）

**2. 公开处刑**：
- 处刑消息推送给所有死党
- 在死党群聊中显示"处刑公告"
- 显示任务详情 + 逾期天数 + 处刑者
- 保留 7 天处刑记录

**3. 闹钟轰炸**：
- 连续播放刺耳闹钟音效
- 必须完成"挑战"才能关闭（如：解答数学题）
- 最多轰炸 3 次

#### 订阅处刑类型

**4. 金钱惩罚**：
```dart
class MoneyPenalty {
  double amount;            // 罚款金额（1-100 元）
  String toUserId;          // 接收者（死党）
  String taskId;            // 关联任务
  bool isPaid;              // 是否已支付
}
```

- 死党设置罚款金额（1-100 元）
- 逾期任务自动扣款
- 款项转入死党账户
- 需绑定支付方式（微信支付/支付宝）

**5. 自定义处刑**：
```dart
class CustomExecution {
  String message;           // 自定义消息
  String? audioUrl;         // 自定义录音（可选）
  int duration;             // 处刑时长（秒）
  bool requireAction;       // 是否需要行动才能关闭
  String? actionType;       // 行动类型（拍照/录音/文字）
}
```

- 死党录制语音消息
- 死党上传自定义音频
- 设置"必须行动才能关闭"（如：拍照证明你在工作）
- 最长 60 秒处刑时长

**6. 社交媒体处刑**：
- 自动在社交媒体发布"我鸽了"动态（需授权）
- 可选平台：朋友圈、微博、Twitter
- 动态内容：任务详情 + 逾期天数 + 嘲讽文案
- 需绑定社交账号

**7. 游戏化处刑**：
- 强制玩"羞耻小游戏"（如：跳一跳、消消乐）
- 必须达到一定分数才能关闭
- 游戏结果分享给死党
- 增加趣味性和仪式感

---

## 🎯 上瘾机制设计

### 即时反馈系统

**视觉反馈**：
- 任务逾期时：红色闪烁 + 骷髅图标
- 收到处刑令：全屏震动效果 + 处刑动画
- 任务完成时：绿色庆祝动画 + 掌声音效
- 连续成功时：火焰特效 + 连胜数字

**听觉反馈**：
- 逾期提醒：嘲讽语音 + 震动
- 处刑令到达：刺耳音效 + 强震动
- 任务完成：鼓励语音 + 欢快音效
- 连续成功：胜利音效 + 烟花声

**触觉反馈**：
- 普通通知：轻震动（100ms）
- 逾期提醒：中震动（300ms）
- 处刑令到达：强震动（500ms + 节奏震动）
- 紧急提醒：连续震动（5 次）

### 长期目标系统

**等级系统**：
```
Lv. 1  摆烂萌新（0-10 次任务）
Lv. 2  偶尔鸽鸽（11-30 次）
Lv. 3  普通社畜（31-60 次）
Lv. 4  稍微靠谱（61-100 次）
Lv. 5  自律学徒（101-150 次）
Lv. 6  自律达人（151-220 次）
Lv. 7  自律大师（221-300 次）
Lv. 8  时间管理专家（301-400 次）
Lv. 9  效率机器（401-500 次）
Lv. 10 自律之神（500+ 次）
```

**称号系统**：
```
负面称号（嘲讽）：
- 🕊️ 鸽子王：连续逾期 7 天
- 🦥 摆烂王：连续逾期 14 天
- 💀 放弃治疗：连续逾期 30 天

正面称号（激励）：
- ⚡ 闪电侠：连续成功 7 天
- 🔥 火力全开：连续成功 30 天
- 👑 自律之神：连续成功 100 天
- 🎖️ 钢铁意志：连续成功 365 天

特殊称号（趣味）：
- 🎭 戏精：被处刑 100 次
- 💪 抗压达人：承受 1000 元罚款
- 👥 社交达人：加入 5 个死党团队
```

**成就系统**：
```
任务成就：
- 首次完成任务：✅ 不鸽一次
- 完成 10 个任务：✅ 小试牛刀
- 完成 50 个任务：✅ 渐入佳境
- 完成 100 个任务：✅ 自律新星
- 完成 500 个任务：✅ 自律大师

连续成就：
- 连续成功 3 天：🔥 三日连胜
- 连续成功 7 天：🔥 周周连胜
- 连续成功 30 天：🔥 月月连胜
- 连续成功 100 天：🔥 自律狂人

社交成就：
- 加入第一个死党团队：👥 有朋自远方来
- 发送第一个处刑令：⚔️ 执刑者
- 收到 10 个处刑令：🎭 戏精
- 发送 100 个处刑令：💀 处刑专家

特殊成就：
- 首次金钱处刑：💸 破财消灾
- 累计罚款 100 元：💰 慈善家
- 连续逾期 7 天：🕊️ 鸽子王
- 自律等级达到 10 级：👑 自律之神
```

### 社交驱动系统

**死党互动**：
- 查看死党任务进度
- 给死党加油打气（发送鼓励）
- 给死党处刑令（发送惩罚）
- 分享自己的成就

**社交压力**：
- 逾期任务自动通知死党
- 死党可以看到你的"摆烂记录"
- 排行榜公开展示
- "摆烂王"排行榜（反向激励）

**正向激励**：
- 死党可以看到你的成功记录
- 为你的成功点赞
- 发送鼓励消息
- 赠送"自律勋章"

---

## 🗺️ 升级路线图

### P0 - 核心体验（MVP）

**任务管理**：
- [x] 任务创建/编辑/删除
- [x] 截止时间设置
- [x] 逾期检测
- [x] 任务列表展示
- [ ] 优先级排序
- [ ] 标签系统

**毒舌系统**：
- [x] 毒舌文案库（50+ 条）
- [x] 逾期提醒通知
- [ ] TTS 语音播报
- [ ] 音效库集成
- [ ] 震动反馈

**本地功能**：
- [x] 本地数据存储
- [ ] 主题切换（深色/浅色）
- [ ] 多语言支持（中英文）
- [ ] 小组件支持

### P1 - 社交功能

**死党系统**：
- [ ] 创建/加入团队
- [ ] 邀请好友（分享链接/二维码）
- [ ] 查看死党列表
- [ ] 查看死党任务

**处刑令系统**：
- [ ] 发送处刑令
- [ ] 接收处刑令
- [ ] 毒舌语音处刑（免费）
- [ ] 公开处刑（免费）
- [ ] 处刑历史记录

**排行榜**：
- [ ] 本周成功率排行
- [ ] 本月完成任务数排行
- [ ] 总成功率排行
- [ ] "摆烂王"排行

**云同步**：
- [ ] Supabase 后端集成
- [ ] 用户认证
- [ ] 数据云端同步
- [ ] 多设备同步

### P2 - 高级功能

**订阅功能**：
- [ ] RevenueCat 集成
- [ ] 订阅等级（免费/高级/专业）
- [ ] 订阅功能解锁
- [ ] 订阅管理界面

**高级处刑**：
- [ ] 金钱惩罚（订阅）
- [ ] 自定义处刑（订阅）
- [ ] 社交媒体处刑（订阅）
- [ ] 游戏化处刑（订阅）

**成就系统**：
- [ ] 成就定义（50+ 成就）
- [ ] 成就解锁动画
- [ ] 称号系统
- [ ] 成就展示

**统计分析**：
- [ ] 任务完成率统计
- [ ] 逾期率统计
- [ ] 最佳完成时间分析
- [ ] 周/月/年报表

---

## 💰 商业化规划

### 收入模型

#### 免费用户（F2P）
- 无限任务创建
- 本地数据存储
- 基础毒舌提醒
- 毒舌语音处刑（免费）
- 公开处刑（免费）
- 加入 1 个死党团队
- 基础成就系统

#### 高级用户（订阅 ¥12/月 或 ¥68/年）：
- 云端数据同步
- 加入无限死党团队
- 金钱惩罚处刑
- 自定义处刑（录音/上传音频）
- 社交媒体处刑
- 游戏化处刑
- 高级成就和称号
- 详细统计分析
- 无广告体验
- 优先客服支持

#### 专业用户（订阅 ¥30/月 或 ¥198/年）：
- 高级用户所有功能
- 团队管理功能（创建管理多个团队）
- 团队数据分析
- 导出报表（PDF/Excel）
- API 接口（对接其他应用）
- 专属客服经理
- 优先新功能体验

### 付费设计原则

**公平性**：
- 核心功能完全免费（任务管理、基础处刑）
- 付费主要是高级功能和便利性
- 不影响基础使用体验

**性价比梯度**：
```
年订阅 > 月订阅 > 单买功能包
```

**防沉迷**：
- 每日处刑次数上限（免费 3 次，高级 10 次）
- 金钱惩罚单次上限 100 元
- 未成年保护（禁用金钱惩罚）

### 预期收入模型（假设）

**目标用户**：
- 第一年目标：100 万下载，20 万 DAU

**收入结构**：
- 高级订阅：50% 收入（5000 用户 × ¥68/年 = ¥34 万/年）
- 专业订阅：30% 收入（1000 用户 × ¥198/年 = ¥19.8 万/年）
- 广告收入：20% 收入（非订阅用户看广告）

**首年收入预估**：
- 月流水：¥8-15 万
- 年流水：¥100-180 万

---

## 🏗️ 技术架构

### 当前技术栈

**前端（Flutter）**：
```
Flutter 3.x + Dart 3.x
├── 状态管理：原生 ChangeNotifier
├── 数据持久化：
│   ├── SharedPreferences（本地）
│   └── Supabase（云端）
├── 国际化：flutter_localizations + intl
├── 支付：purchases_flutter（RevenueCat）
├── 推送：flutter_local_notifications
├── 小组件：home_widget
├── 语音：flutter_tts + audioplayers
└── 其他：vibration、share_plus、image_picker
```

**后端（Supabase）**：
```
Supabase
├── 数据库：PostgreSQL
│   ├── users（用户表）
│   ├── tasks（任务表）
│   ├── teams（团队表）
│   ├── executions（处刑令表）
│   └── achievements（成就表）
├── 认证：Supabase Auth
│   ├── 邮箱/密码登录
│   ├── 第三方登录（微信/Apple）
│   └── 匿名登录（可选）
├── 存储：Supabase Storage
│   ├── avatars（头像）
│   ├── audios（自定义音频）
│   └── exports（导出文件）
└── 实时：Supabase Realtime
    ├── 实时任务更新
    ├── 实处处刑令
    └── 实时排行榜
```

### 关键文件说明

#### 核心模型（`lib/models/`）

**task.dart**：
```dart
class Task {
  String id;
  String userId;
  String title;
  String? description;
  DateTime deadline;
  TaskPriority priority;
  List<String> tags;
  bool isCompleted;
  DateTime? completedAt;
  int overdueDays;
  DateTime createdAt;
  DateTime updatedAt;
}

enum TaskPriority {
  low,      // 低
  medium,   // 中
  high,     // 高
  urgent,   // 紧急
}
```

**team.dart**：
```dart
class Team {
  String id;
  String name;
  String? description;
  String leaderId;
  List<TeamMember> members;
  int maxMembers;  // 最大成员数（免费 10，高级无限）
  DateTime createdAt;
}

class TeamMember {
  String userId;
  String name;
  String? avatar;
  MemberRole role;
  DateTime joinedAt;
}

enum MemberRole {
  leader,   // 队长
  member,   // 成员
}
```

**execution.dart**：
```dart
class ExecutionOrder {
  String id;
  String fromUserId;
  String toUserId;
  String teamId;
  String taskId;
  ExecutionType type;
  String? customMessage;
  int? penaltyAmount;  // 罚款金额（分）
  DateTime createdAt;
  bool isExecuted;
  DateTime? executedAt;
}

enum ExecutionType {
  verbal,        // 毒舌语音（免费）
  public,        // 公开处刑（免费）
  alarm,         // 闹钟轰炸（免费）
  money,         // 金钱惩罚（订阅）
  custom,        // 自定义处刑（订阅）
  social,        // 社交媒体（订阅）
  gamified,      // 游戏化（订阅）
}
```

**achievement.dart**：
```dart
class Achievement {
  String id;
  String name;
  String description;
  String icon;  // emoji 或图标路径
  AchievementType type;
  int requirement;  // 达成条件（如完成 10 个任务）
  AchievementReward reward;
}

enum AchievementType {
  task,       // 任务成就
  streak,     // 连续成就
  social,     // 社交成就
  special,    // 特殊成就
}

class AchievementReward {
  String? title;      // 称号
  String? avatar;     // 头像框
  int? coins;         // 虚拟货币（未来）
}
```

#### 服务层（`lib/services/`）

**notification_service.dart**：
```dart
class NotificationService {
  // 本地推送通知
  Future<void> scheduleTaskReminder(Task task);
  Future<void> cancelTaskReminder(String taskId);
  
  // 逾期检测
  Future<void> checkOverdueTasks();
  
  // 处刑令通知
  Future<void> sendExecutionNotification(ExecutionOrder execution);
}
```

**voice_service.dart**：
```dart
class VoiceService {
  // TTS 语音合成
  Future<void> speak(String text, {double rate, double pitch});
  
  // 播放音效
  Future<void> playSoundEffect(String soundName);
  
  // 播放毒舌语音
  Future<void> playToxicReminder(Task task);
  
  // 播放处刑语音
  Future<void> playExecutionVoice(ExecutionOrder execution);
}
```

**theme_service.dart**：
```dart
class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  Future<void> setThemeMode(ThemeMode mode);
  Future<void> toggleTheme();
}
```

**locale_service.dart**：
```dart
class LocaleService extends ChangeNotifier {
  Locale _locale = const Locale('zh', 'CN');
  
  Locale get locale => _locale;
  
  Future<void> setLocale(Locale locale);
  Future<void> toggleLanguage();  // 中英文切换
}
```

**widget_service.dart**：
```dart
class WidgetService {
  // 更新小组件数据
  Future<void> updateWidgetData();
  
  // 设置小组件任务
  Future<void> setWidgetTask(Task task);
  
  // 清除小组件数据
  Future<void> clearWidgetData();
}
```

#### 界面层（`lib/screens/`）

**home_screen.dart**：
- 任务列表展示
- 逾期任务高亮
- 快速操作按钮（创建任务、查看死党）
- 底部导航（任务、死党、成就、设置）

**task_detail_screen.dart**：
- 任务详情查看/编辑
- 截止时间设置
- 优先级选择
- 标签管理
- 逾期天数显示

**team_screen.dart**：
- 死党团队列表
- 团队成员查看
- 发送处刑令
- 排行榜查看

**achievement_screen.dart**：
- 成就列表
- 已解锁成就展示
- 称号管理
- 成就进度

**settings_screen.dart**：
- 主题切换
- 语言切换
- 通知设置
- 订阅管理
- 账号设置

### 数据流向

```
用户操作
    ↓
Widget (UI Layer)
    ↓
Screen (Screen Layer)
    ↓
Service (Service Layer)
    ↓
Model (Model Layer)
    ↓
Repository (Data Layer)
    ↓
SharedPreferences / Supabase
    ↓
State Update → UI Refresh
```

### 性能优化策略

**任务列表优化**：
- 使用 `ListView.builder` 延迟加载
- 任务分页加载（每次 20 条）
- 任务缓存（本地 + 云端）

**通知优化**：
- 批量调度通知（减少系统调用）
- 通知去重（避免重复通知）
- 通知静默期（夜间免打扰）

**数据同步优化**：
- 增量同步（只同步变更数据）
- 离线优先（本地优先，后台同步）
- 冲突解决（时间戳优先）

---

## 🚀 安装运行

### 环境要求
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- macOS / Windows / Linux / iOS / Android

### 安装步骤
```bash
# 1. 克隆仓库
git clone https://github.com/vanhci/toxic_tracker.git

# 2. 进入项目目录
cd toxic_tracker

# 3. 安装依赖
flutter pub get

# 4. 配置 Supabase（可选）
# 创建 .env 文件配置 SUPABASE_URL 和 SUPABASE_ANON_KEY

# 5. 运行应用
flutter run -d macos   # macOS
flutter run -d android # Android
flutter run -d ios     # iOS
flutter run            # 默认设备
```

### 开发命令
```bash
# 代码格式化
flutter format .

# 静态分析
flutter analyze

# 运行测试
flutter test

# 构建生产版本
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

---

## 📸 应用截图

### 主界面
（预留位置 - 建议添加截图）

### 功能展示
（预留位置 - 建议添加截图）

---

## 🤝 贡献指南
欢迎提交 Issue 和 Pull Request

## 📄 许可证
MIT License

## 🔗 链接

- **GitHub 仓库**: https://github.com/vanhci/toxic_tracker
- **隐私政策**: https://vanhci.github.io/toxic_tracker/privacy/

## 👤 作者
vanhci

## 🙏 致谢
感谢所有贡献者和开源项目

---

## 📊 文档统计

**本文档包含**：
- 项目愿景：明确解决的问题和独特性
- 核心功能机制：任务管理、毒舌系统、死党社交、处刑多样化
- 上瘾机制设计：即时反馈、长期目标、社交驱动
- 升级路线图：P0（核心体验）、P1（社交功能）、P2（高级功能）
- 商业化规划：免费/高级/专业三级订阅，预期收入模型
- 技术架构：Flutter 前端 + Supabase 后端，关键文件说明
- 字数统计：约 7,500 字
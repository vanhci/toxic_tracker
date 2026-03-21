# API 参考文档

本文档描述《今天鸽了吗》应用的服务层 API。

---

## 目录

- [TaskStorage](#taskstorage) - 任务存储
- [UserService](#userservice) - 用户身份
- [UploadService](#uploadservice) - 图片上传
- [VerdictService](#verdictservice) - 判决服务
- [TeamService](#teamservice) - 团队服务
- [AchievementService](#achievementservice) - 成就系统
- [NotificationService](#notificationservice) - 推送通知
- [VoiceService](#voiceservice) - 语音服务
- [ThemeService](#themeservice) - 主题服务
- [LocaleService](#localeservice) - 语言服务

---

## TaskStorage

任务本地存储服务，使用 SharedPreferences。

### 方法

```dart
// 加载所有任务
Future<List<Task>> loadTasks()

// 保存任务列表
Future<void> saveTasks(List<Task> tasks)

// 添加新任务
Future<void> addTask(Task task)

// 更新任务
Future<void> updateTask(Task updatedTask)

// 删除任务
Future<void> deleteTask(String taskId)
```

### 示例

```dart
final storage = TaskStorage();

// 创建任务
final task = Task(
  id: 'task-1',
  title: '健身打卡',
  createdAt: DateTime.now(),
  deadline: DateTime.now().add(Duration(days: 7)),
);
await storage.addTask(task);

// 加载任务
final tasks = await storage.loadTasks();

// 更新任务（鸽了）
final updated = task.copyWith(consecutiveFails: task.consecutiveFails + 1);
await storage.updateTask(updated);

// 删除任务
await storage.deleteTask('task-1');
```

---

## UserService

用户身份管理服务，优先使用 Supabase 匿名用户。

### 方法

```dart
// 获取或创建用户 ID
Future<String> getUserId()

// 清除缓存
void clearCache()

// 检查是否已认证
bool get isAuthenticated
```

### 示例

```dart
// 获取用户 ID
final userId = await UserService.getUserId();
print('用户 ID: $userId');

// 检查认证状态
if (UserService.isAuthenticated) {
  print('用户已通过 Supabase 认证');
}
```

---

## UploadService

Supabase Storage 图片上传服务。

### 方法

```dart
// 上传图片
Future<String?> uploadProof(String taskId, XFile photo)

// 获取公开 URL
String getPublicUrl(String path)
```

### 示例

```dart
// 拍照后上传
final photo = await ImagePicker().pickImage(source: ImageSource.camera);
if (photo != null) {
  final url = await UploadService.uploadProof(taskId, photo);
  if (url != null) {
    print('图片已上传: $url');
  }
}
```

---

## VerdictService

判决状态监听服务。

### 方法

```dart
// 创建判决记录
Future<String?> createVerdict(String taskId, String taskTitle, String photoUrl)

// 监听判决状态
Stream<String> listenToVerdict(String verdictId)

// 停止监听
void stopListening()
```

### 示例

```dart
// 创建判决
final verdictId = await VerdictService.createVerdict(
  taskId,
  '健身打卡',
  photoUrl,
);

// 监听判决结果
VerdictService.listenToVerdict(verdictId).listen((status) {
  if (status == 'punish') {
    // 触发惩罚
    _showPunishment();
  } else if (status == 'pass') {
    // 放过
    _showPass();
  }
});
```

---

## TeamService

团队管理服务。

### 方法

```dart
// 创建团队
Future<Team?> createTeam({
  required String name,
  required String leaderId,
  String? leaderName,
})

// 加入团队
Future<Team?> joinTeam({
  required String inviteCode,
  required String userId,
  String? displayName,
})

// 获取团队
Future<Team?> getTeam(String teamId)

// 获取当前团队
Future<Team?> getCurrentTeam()

// 获取成员统计
Future<List<TeamMember>> getMemberStats(String teamId)

// 更新团队设置
Future<bool> updateTeamSettings({
  required String teamId,
  required TeamSettings settings,
})

// 移除成员
Future<bool> removeMember({
  required String teamId,
  required String userId,
})

// 退出团队
Future<bool> leaveTeam({
  required String teamId,
  required String userId,
})
```

### 示例

```dart
// 创建团队
final team = await TeamService.createTeam(
  name: '自律小分队',
  leaderId: userId,
  leaderName: '队长',
);
print('邀请码: ${team?.inviteCode}');

// 加入团队
final team = await TeamService.joinTeam(
  inviteCode: 'ABC123',
  userId: userId,
  displayName: '新成员',
);

// 获取鸽子排行榜
final leaderboard = team?.failLeaderboard;
```

---

## AchievementService

成就系统服务。

### 方法

```dart
// 加载成就
Future<List<Achievement>> loadAchievements()

// 保存成就
Future<void> saveAchievements(List<Achievement> achievements)

// 检查成就
Future<List<Achievement>> checkAchievements({
  required int totalFlags,
  required int totalFails,
  required int maxConsecutiveFails,
  required int punishmentCount,
  required int passCount,
  required int consecutiveNoFail,
})

// 获取已解锁数量
int getUnlockedCount(List<Achievement> achievements)
```

---

## NotificationService

推送通知服务。

### 方法

```dart
// 初始化
Future<void> initialize()

// 请求权限
Future<void> requestPermission()

// 显示通知
Future<void> showNotification({
  required int id,
  required String title,
  required String body,
})

// 取消通知
Future<void> cancelNotification(int id)

// 取消所有通知
Future<void> cancelAllNotifications()
```

---

## VoiceService

教练语音服务。

### 方法

```dart
// 初始化
Future<void> initialize()

// 播放语音
Future<void> speak(Coach coach, String message)

// 停止播放
Future<void> stop()

// 设置音调
Future<void> setPitch(double pitch)

// 设置语速
Future<void> setRate(double rate)
```

---

## ThemeService

主题切换服务（ChangeNotifier）。

### 方法

```dart
// 加载保存的主题
Future<void> load()

// 切换主题
void toggle()

// 设置主题模式
void setMode(ThemeMode mode)

// 当前主题模式
ThemeMode get mode
```

---

## LocaleService

语言切换服务（ChangeNotifier）。

### 方法

```dart
// 加载保存的语言
Future<void> load()

// 切换语言
void toggle()

// 设置语言
void setLocale(Locale locale)

// 当前语言
Locale get locale
```

---

## 错误处理

所有服务方法都有内置错误处理，失败时返回 `null` 或空列表，并在 debug 模式下打印错误日志。

```dart
try {
  final result = await SomeService.doSomething();
  if (result == null) {
    // 处理失败情况
  }
} catch (e) {
  // 捕获意外错误
  print('错误: $e');
}
```

---

## 相关链接

- [开发指南](DEVELOPMENT.md)
- [项目结构](../README.md#项目结构)
- [Supabase 配置](../QUICKSTART.md)

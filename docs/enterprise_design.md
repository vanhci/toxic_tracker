# 企业版设计文档

## 概述

企业版（团队监督）功能允许团队管理者创建团队，邀请成员加入，并监督团队成员的任务完成情况。

## 核心功能

### 1. 团队管理

#### 数据模型

```dart
class Team {
  final String id;
  final String name;
  final String leaderId;
  final List<TeamMember> members;
  final DateTime createdAt;
  final TeamSettings settings;
}

class TeamMember {
  final String userId;
  final String displayName;
  final TeamRole role; // admin, leader, member
  final DateTime joinedAt;
}

class TeamSettings {
  final bool enableNotifications;
  final bool requirePhotoProof;
  final int failThreshold; // 触发通知的失败次数阈值
}
```

#### 功能点
- 创建团队
- 邀请成员（通过邀请码/链接）
- 移除成员
- 设置团队规则
- 查看团队概览

### 2. 监督面板

#### 管理者视图
- 团队成员任务完成率
- 鸽子排行榜
- 即将逾期的任务
- 需要关注的成员（连续失败）

#### 成员视图
- 自己的任务列表
- 团队排名
- 团队公告

### 3. 通知系统

#### 通知类型
- 成员连续失败 N 次
- 成员任务逾期
- 新成员加入
- 团队目标达成

### 4. 数据库设计

#### Supabase 表结构

```sql
-- 团队表
CREATE TABLE teams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  leader_id UUID NOT NULL REFERENCES auth.users(id),
  settings JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 团队成员表
CREATE TABLE team_members (
  team_id UUID REFERENCES teams(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id),
  role TEXT DEFAULT 'member',
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (team_id, user_id)
);

-- 团队任务视图（关联用户任务）
CREATE VIEW team_tasks AS
SELECT
  t.id as task_id,
  t.title,
  t.deadline,
  t.consecutive_fails,
  tm.team_id,
  u.id as user_id,
  u.raw_user_meta_data->>'name' as user_name
FROM tasks t
JOIN team_members tm ON tm.user_id = t.user_id
JOIN auth.users u ON u.id = t.user_id;
```

## 技术实现

### 新增依赖
```yaml
# 无需新依赖，使用现有的 Supabase
```

### 新增服务

#### lib/services/team_service.dart
```dart
class TeamService {
  // 创建团队
  static Future<Team> createTeam(String name);

  // 加入团队
  static Future<bool> joinTeam(String inviteCode);

  // 获取团队信息
  static Future<Team?> getTeam(String teamId);

  // 获取团队成员任务统计
  static Future<List<MemberStats>> getMemberStats(String teamId);
}
```

#### lib/screens/team_screen.dart
```dart
// 团队管理界面
// - 团队信息卡片
// - 成员列表
// - 统计图表
// - 邀请链接
```

## 商业化

### 定价策略
- 基础版：免费，最多 5 人
- 专业版：¥99/月，最多 50 人
- 企业版：¥299/月，无限人数

### RevenueCat 配置
- 新增 Product ID: `team_pro_monthly`
- 新增 Product ID: `team_enterprise_monthly`

## 开发计划

### Phase 1：基础架构
- [ ] 创建 Team 数据模型
- [ ] 实现团队 CRUD
- [ ] 邀请链接生成

### Phase 2：监督功能
- [ ] 团队任务统计
- [ ] 成员排行榜
- [ ] 管理者通知

### Phase 3：商业化
- [ ] 团队订阅功能
- [ ] 权限控制
- [ ] 管理后台

---

**注意**：企业版功能较为复杂，建议先完成 MVP 上线，收集用户反馈后再开发。

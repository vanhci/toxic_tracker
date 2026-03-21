/// 团队角色
enum TeamRole {
  admin,   // 管理员：所有权限
  leader,  // 领导：可查看统计、发送通知
  member,  // 成员：仅查看自己
}

/// 团队成员
class TeamMember {
  final String userId;
  final String displayName;
  final TeamRole role;
  final DateTime joinedAt;
  final int totalTasks;
  final int completedTasks;
  final int totalFails;

  TeamMember({
    required this.userId,
    required this.displayName,
    required this.role,
    required this.joinedAt,
    this.totalTasks = 0,
    this.completedTasks = 0,
    this.totalFails = 0,
  });

  double get completionRate =>
      totalTasks > 0 ? completedTasks / totalTasks : 0.0;

  TeamMember copyWith({
    String? userId,
    String? displayName,
    TeamRole? role,
    DateTime? joinedAt,
    int? totalTasks,
    int? completedTasks,
    int? totalFails,
  }) {
    return TeamMember(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      totalTasks: totalTasks ?? this.totalTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      totalFails: totalFails ?? this.totalFails,
    );
  }

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      userId: json['user_id'] ?? '',
      displayName: json['display_name'] ?? '匿名用户',
      role: TeamRole.values.firstWhere(
        (e) => e.name == (json['role'] ?? 'member'),
        orElse: () => TeamRole.member,
      ),
      joinedAt: json['joined_at'] != null
          ? DateTime.parse(json['joined_at'])
          : DateTime.now(),
      totalTasks: json['total_tasks'] ?? 0,
      completedTasks: json['completed_tasks'] ?? 0,
      totalFails: json['total_fails'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'display_name': displayName,
      'role': role.name,
      'joined_at': joinedAt.toIso8601String(),
      'total_tasks': totalTasks,
      'completed_tasks': completedTasks,
      'total_fails': totalFails,
    };
  }
}

/// 团队设置
class TeamSettings {
  final bool enableNotifications;
  final bool requirePhotoProof;
  final int failThreshold;

  const TeamSettings({
    this.enableNotifications = true,
    this.requirePhotoProof = true,
    this.failThreshold = 3,
  });

  factory TeamSettings.fromJson(Map<String, dynamic> json) {
    return TeamSettings(
      enableNotifications: json['enable_notifications'] ?? true,
      requirePhotoProof: json['require_photo_proof'] ?? true,
      failThreshold: json['fail_threshold'] ?? 3,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enable_notifications': enableNotifications,
      'require_photo_proof': requirePhotoProof,
      'fail_threshold': failThreshold,
    };
  }
}

/// 团队
class Team {
  final String id;
  final String name;
  final String leaderId;
  final String? inviteCode;
  final List<TeamMember> members;
  final TeamSettings settings;
  final DateTime createdAt;

  Team({
    required this.id,
    required this.name,
    required this.leaderId,
    this.inviteCode,
    this.members = const [],
    this.settings = const TeamSettings(),
    required this.createdAt,
  });

  int get memberCount => members.length;

  /// 获取鸽子排行榜（按失败次数降序）
  List<TeamMember> get failLeaderboard {
    final sorted = List<TeamMember>.from(members);
    sorted.sort((a, b) => b.totalFails.compareTo(a.totalFails));
    return sorted;
  }

  /// 获取完成率排行榜（按完成率降序）
  List<TeamMember> get completionLeaderboard {
    final sorted = List<TeamMember>.from(members);
    sorted.sort((a, b) => b.completionRate.compareTo(a.completionRate));
    return sorted;
  }

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      leaderId: json['leader_id'] ?? '',
      inviteCode: json['invite_code'],
      members: (json['members'] as List<dynamic>?)
              ?.map((m) => TeamMember.fromJson(m))
              .toList() ??
          [],
      settings: json['settings'] != null
          ? TeamSettings.fromJson(json['settings'])
          : const TeamSettings(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'leader_id': leaderId,
      'invite_code': inviteCode,
      'members': members.map((m) => m.toJson()).toList(),
      'settings': settings.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Team copyWith({
    String? id,
    String? name,
    String? leaderId,
    String? inviteCode,
    List<TeamMember>? members,
    TeamSettings? settings,
    DateTime? createdAt,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      leaderId: leaderId ?? this.leaderId,
      inviteCode: inviteCode ?? this.inviteCode,
      members: members ?? this.members,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

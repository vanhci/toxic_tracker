class Task {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime deadline;
  int consecutiveFails;
  DateTime? lastFailDate;

  Task({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.deadline,
    this.consecutiveFails = 0,
    this.lastFailDate,
  });

  bool get isOverdue => DateTime.now().isAfter(deadline);

  int get daysUntilDeadline {
    final now = DateTime.now();
    final difference = deadline.difference(DateTime(now.year, now.month, now.day));
    return difference.inDays;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'consecutiveFails': consecutiveFails,
      'lastFailDate': lastFailDate?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      deadline: DateTime.parse(json['deadline']),
      consecutiveFails: json['consecutiveFails'] ?? 0,
      lastFailDate: json['lastFailDate'] != null
          ? DateTime.parse(json['lastFailDate'])
          : null,
    );
  }

  Task copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? deadline,
    int? consecutiveFails,
    DateTime? lastFailDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      deadline: deadline ?? this.deadline,
      consecutiveFails: consecutiveFails ?? this.consecutiveFails,
      lastFailDate: lastFailDate ?? this.lastFailDate,
    );
  }
}

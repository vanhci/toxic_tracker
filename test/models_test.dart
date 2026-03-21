import 'package:flutter_test/flutter_test.dart';
import 'package:toxic_tracker/models/task.dart';
import 'package:toxic_tracker/models/coach.dart';
import 'package:toxic_tracker/models/achievement.dart';
import 'package:toxic_tracker/models/team.dart';

void main() {
  group('Task Model Tests', () {
    test('Task should be created with correct properties', () {
      final now = DateTime.now();
      final deadline = now.add(const Duration(days: 7));

      final task = Task(
        id: 'test-id',
        title: '测试任务',
        createdAt: now,
        deadline: deadline,
      );

      expect(task.id, 'test-id');
      expect(task.title, '测试任务');
      expect(task.consecutiveFails, 0);
      expect(task.lastFailDate, isNull);
    });

    test('Task copyWith should update properties correctly', () {
      final now = DateTime.now();
      final deadline = now.add(const Duration(days: 7));

      final task = Task(
        id: 'test-id',
        title: '测试任务',
        createdAt: now,
        deadline: deadline,
      );

      final failDate = DateTime.now();
      final updatedTask = task.copyWith(
        consecutiveFails: 3,
        lastFailDate: failDate,
      );

      expect(updatedTask.consecutiveFails, 3);
      expect(updatedTask.lastFailDate, failDate);
      expect(updatedTask.id, task.id);
      expect(updatedTask.title, task.title);
    });

    test('Task JSON serialization should work correctly', () {
      final now = DateTime.now();
      final deadline = now.add(const Duration(days: 7));

      final task = Task(
        id: 'test-id',
        title: '测试任务',
        createdAt: now,
        deadline: deadline,
        consecutiveFails: 2,
      );

      final json = task.toJson();
      final restoredTask = Task.fromJson(json);

      expect(restoredTask.id, task.id);
      expect(restoredTask.title, task.title);
      expect(restoredTask.consecutiveFails, task.consecutiveFails);
    });

    test('Task isOverdue should return correct value', () {
      final now = DateTime.now();

      // 过期任务
      final overdueTask = Task(
        id: 'overdue',
        title: '过期任务',
        createdAt: now.subtract(const Duration(days: 10)),
        deadline: now.subtract(const Duration(days: 1)),
      );
      expect(overdueTask.isOverdue, true);

      // 未过期任务
      final futureTask = Task(
        id: 'future',
        title: '未来任务',
        createdAt: now,
        deadline: now.add(const Duration(days: 7)),
      );
      expect(futureTask.isOverdue, false);
    });
  });

  group('Coach Model Tests', () {
    test('Coach should be created with correct properties', () {
      final coach = Coach(
        id: 'test-coach',
        name: 'Test Coach',
        emoji: '🧪',
        greeting: 'Hello!',
        style: 'Test Style',
      );

      expect(coach.id, 'test-coach');
      expect(coach.name, 'Test Coach');
      expect(coach.emoji, '🧪');
      expect(coach.isPremium, false);
      expect(coach.isUnlocked, false);
    });

    test('Coach copyWith should update isUnlocked correctly', () {
      final coach = Coach(
        id: 'test-coach',
        name: 'Test Coach',
        emoji: '🧪',
        greeting: 'Hello!',
        style: 'Test Style',
        isPremium: true,
      );

      final unlockedCoach = coach.copyWith(isUnlocked: true);

      expect(unlockedCoach.isUnlocked, true);
      expect(unlockedCoach.isPremium, true);
      expect(unlockedCoach.id, coach.id);
    });

    test('Default coaches should have 6 coaches', () {
      expect(Coach.defaultCoaches.length, 6);
    });

    test('First default coach should be unlocked', () {
      expect(Coach.defaultCoaches.first.isUnlocked, true);
      expect(Coach.defaultCoaches.first.isPremium, false);
    });
  });

  group('Achievement Model Tests', () {
    test('Achievement should be created with correct properties', () {
      const achievement = Achievement(
        id: 'test-achievement',
        title: 'Test Achievement',
        description: 'Test Description',
        emoji: '🏆',
        requirement: 5,
      );

      expect(achievement.id, 'test-achievement');
      expect(achievement.title, 'Test Achievement');
      expect(achievement.emoji, '🏆');
      expect(achievement.requirement, 5);
      expect(achievement.isUnlocked, false);
    });

    test('Achievement copyWith should update isUnlocked correctly', () {
      const achievement = Achievement(
        id: 'test-achievement',
        title: 'Test Achievement',
        description: 'Test Description',
        emoji: '🏆',
        requirement: 5,
      );

      final unlockedAchievement = achievement.copyWith(isUnlocked: true);

      expect(unlockedAchievement.isUnlocked, true);
      expect(unlockedAchievement.id, achievement.id);
    });

    test('Default achievements should have 8 achievements', () {
      expect(Achievement.defaultAchievements.length, 8);
    });
  });

  group('Team Model Tests', () {
    test('TeamMember should calculate completion rate correctly', () {
      final member = TeamMember(
        userId: 'user-1',
        displayName: 'Test User',
        role: TeamRole.member,
        joinedAt: DateTime.now(),
        totalTasks: 10,
        completedTasks: 7,
        totalFails: 3,
      );

      expect(member.completionRate, closeTo(0.7, 0.01));
    });

    test('TeamSettings should have correct defaults', () {
      const settings = TeamSettings();

      expect(settings.enableNotifications, true);
      expect(settings.requirePhotoProof, true);
      expect(settings.failThreshold, 3);
    });

    test('Team should calculate member count correctly', () {
      final team = Team(
        id: 'team-1',
        name: 'Test Team',
        leaderId: 'leader-1',
        members: [
          TeamMember(
            userId: 'user-1',
            displayName: 'User 1',
            role: TeamRole.admin,
            joinedAt: DateTime.now(),
          ),
          TeamMember(
            userId: 'user-2',
            displayName: 'User 2',
            role: TeamRole.member,
            joinedAt: DateTime.now(),
          ),
        ],
        createdAt: DateTime.now(),
      );

      expect(team.memberCount, 2);
    });

    test('Team failLeaderboard should sort by totalFails descending', () {
      final team = Team(
        id: 'team-1',
        name: 'Test Team',
        leaderId: 'leader-1',
        members: [
          TeamMember(
            userId: 'user-1',
            displayName: 'Low Fail',
            role: TeamRole.member,
            joinedAt: DateTime.now(),
            totalFails: 1,
          ),
          TeamMember(
            userId: 'user-2',
            displayName: 'High Fail',
            role: TeamRole.member,
            joinedAt: DateTime.now(),
            totalFails: 10,
          ),
          TeamMember(
            userId: 'user-3',
            displayName: 'Medium Fail',
            role: TeamRole.member,
            joinedAt: DateTime.now(),
            totalFails: 5,
          ),
        ],
        createdAt: DateTime.now(),
      );

      final leaderboard = team.failLeaderboard;

      expect(leaderboard[0].displayName, 'High Fail');
      expect(leaderboard[1].displayName, 'Medium Fail');
      expect(leaderboard[2].displayName, 'Low Fail');
    });

    test('Team JSON serialization should work correctly', () {
      final team = Team(
        id: 'team-1',
        name: 'Test Team',
        leaderId: 'leader-1',
        inviteCode: 'ABC123',
        createdAt: DateTime.now(),
      );

      final json = team.toJson();
      final restoredTeam = Team.fromJson(json);

      expect(restoredTeam.id, team.id);
      expect(restoredTeam.name, team.name);
      expect(restoredTeam.leaderId, team.leaderId);
      expect(restoredTeam.inviteCode, team.inviteCode);
    });
  });
}

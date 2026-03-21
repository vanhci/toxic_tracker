import 'package:flutter_test/flutter_test.dart';
import 'package:toxic_tracker/models/team.dart';

void main() {
  group('UserService Tests', () {
    test('TeamMember copyWith should update fields correctly', () {
      final member = TeamMember(
        userId: 'user-1',
        displayName: 'Test User',
        role: TeamRole.member,
        joinedAt: DateTime.now(),
        totalTasks: 10,
        completedTasks: 7,
        totalFails: 3,
      );

      final updated = member.copyWith(
        totalTasks: 20,
        completedTasks: 15,
        totalFails: 5,
      );

      expect(updated.userId, member.userId);
      expect(updated.displayName, member.displayName);
      expect(updated.role, member.role);
      expect(updated.totalTasks, 20);
      expect(updated.completedTasks, 15);
      expect(updated.totalFails, 5);
    });

    test('TeamMember completionRate updates with new stats', () {
      final member = TeamMember(
        userId: 'user-1',
        displayName: 'Test User',
        role: TeamRole.member,
        joinedAt: DateTime.now(),
        totalTasks: 10,
        completedTasks: 8,
      );

      expect(member.completionRate, closeTo(0.8, 0.01));

      final updated = member.copyWith(totalTasks: 20, completedTasks: 10);
      expect(updated.completionRate, closeTo(0.5, 0.01));
    });
  });

  group('TeamRole Tests', () {
    test('TeamRole values are correct', () {
      expect(TeamRole.values.length, 3);
      expect(TeamRole.admin.name, 'admin');
      expect(TeamRole.leader.name, 'leader');
      expect(TeamRole.member.name, 'member');
    });

    test('TeamRole fromJson handles invalid values', () {
      final json = {'role': 'invalid_role'};
      final member = TeamMember.fromJson(json);
      expect(member.role, TeamRole.member); // defaults to member
    });

    test('TeamRole fromJson handles null values', () {
      final json = <String, dynamic>{};
      final member = TeamMember.fromJson(json);
      expect(member.role, TeamRole.member);
    });
  });

  group('TeamSettings Tests', () {
    test('TeamSettings default values', () {
      const settings = TeamSettings();
      expect(settings.enableNotifications, true);
      expect(settings.requirePhotoProof, true);
      expect(settings.failThreshold, 3);
    });

    test('TeamSettings custom values', () {
      const settings = TeamSettings(
        enableNotifications: false,
        requirePhotoProof: false,
        failThreshold: 5,
      );
      expect(settings.enableNotifications, false);
      expect(settings.requirePhotoProof, false);
      expect(settings.failThreshold, 5);
    });

    test('TeamSettings JSON serialization', () {
      const settings = TeamSettings(
        enableNotifications: true,
        requirePhotoProof: false,
        failThreshold: 4,
      );

      final json = settings.toJson();
      final restored = TeamSettings.fromJson(json);

      expect(restored.enableNotifications, settings.enableNotifications);
      expect(restored.requirePhotoProof, settings.requirePhotoProof);
      expect(restored.failThreshold, settings.failThreshold);
    });
  });

  group('TeamMember Edge Cases', () {
    test('TeamMember with zero tasks has zero completion rate', () {
      final member = TeamMember(
        userId: 'user-1',
        displayName: 'No Tasks',
        role: TeamRole.member,
        joinedAt: DateTime.now(),
        totalTasks: 0,
        completedTasks: 0,
      );

      expect(member.completionRate, 0.0);
    });

    test('TeamMember with all completed tasks has 100% rate', () {
      final member = TeamMember(
        userId: 'user-1',
        displayName: 'Perfect',
        role: TeamRole.member,
        joinedAt: DateTime.now(),
        totalTasks: 10,
        completedTasks: 10,
      );

      expect(member.completionRate, 1.0);
    });

    test('TeamMember with more completed than total', () {
      final member = TeamMember(
        userId: 'user-1',
        displayName: 'Over Achiever',
        role: TeamRole.member,
        joinedAt: DateTime.now(),
        totalTasks: 5,
        completedTasks: 10, // This shouldn't happen but we handle it
      );

      expect(member.completionRate, greaterThan(1.0));
    });
  });

  group('Team Leaderboard Tests', () {
    test('Empty team has empty leaderboards', () {
      final team = Team(
        id: 'team-1',
        name: 'Empty Team',
        leaderId: 'leader-1',
        members: [],
        createdAt: DateTime.now(),
      );

      expect(team.memberCount, 0);
      expect(team.failLeaderboard, isEmpty);
      expect(team.completionLeaderboard, isEmpty);
    });

    test('Team with single member', () {
      final member = TeamMember(
        userId: 'user-1',
        displayName: 'Solo',
        role: TeamRole.admin,
        joinedAt: DateTime.now(),
        totalTasks: 5,
        completedTasks: 4,
        totalFails: 2,
      );

      final team = Team(
        id: 'team-1',
        name: 'Solo Team',
        leaderId: 'user-1',
        members: [member],
        createdAt: DateTime.now(),
      );

      expect(team.memberCount, 1);
      expect(team.failLeaderboard.length, 1);
      expect(team.failLeaderboard.first.displayName, 'Solo');
    });

    test('Completion leaderboard sorts correctly', () {
      final members = [
        TeamMember(
          userId: 'user-1',
          displayName: 'Low Rate',
          role: TeamRole.member,
          joinedAt: DateTime.now(),
          totalTasks: 10,
          completedTasks: 3,
        ),
        TeamMember(
          userId: 'user-2',
          displayName: 'High Rate',
          role: TeamRole.member,
          joinedAt: DateTime.now(),
          totalTasks: 10,
          completedTasks: 9,
        ),
        TeamMember(
          userId: 'user-3',
          displayName: 'Medium Rate',
          role: TeamRole.member,
          joinedAt: DateTime.now(),
          totalTasks: 10,
          completedTasks: 6,
        ),
      ];

      final team = Team(
        id: 'team-1',
        name: 'Test Team',
        leaderId: 'leader-1',
        members: members,
        createdAt: DateTime.now(),
      );

      final leaderboard = team.completionLeaderboard;
      expect(leaderboard[0].displayName, 'High Rate');
      expect(leaderboard[1].displayName, 'Medium Rate');
      expect(leaderboard[2].displayName, 'Low Rate');
    });
  });
}

// lib/data/repositories/leaderboard_repository.dart

import 'package:equatable/equatable.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

class LeaderboardEntry extends Equatable {
  final String userId;
  final String userName;
  final String categoryName;
  final int score;
  final int maxScore;
  final double percentage;
  final String grade;
  final DateTime completedAt;

  const LeaderboardEntry({
    required this.userId,
    required this.userName,
    required this.categoryName,
    required this.score,
    required this.maxScore,
    required this.percentage,
    required this.grade,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [userId, categoryName, score, completedAt];
}

// ── Abstract contract ─────────────────────────────────────────────────────────

abstract class LeaderboardRepository {
  Future<List<LeaderboardEntry>> getEntries({String? categoryName});
  Future<void> submitEntry(LeaderboardEntry entry);
}

// ── In-memory implementation ──────────────────────────────────────────────────

class MockLeaderboardRepository implements LeaderboardRepository {
  final List<LeaderboardEntry> _entries = [
    LeaderboardEntry(
      userId: 'u1',
      userName: 'Rahim Ahmed',
      categoryName: 'General Knowledge',
      score: 140,
      maxScore: 150,
      percentage: 93.3,
      grade: 'S',
      completedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    LeaderboardEntry(
      userId: 'u2',
      userName: 'Nusrat Jahan',
      categoryName: 'General Knowledge',
      score: 120,
      maxScore: 150,
      percentage: 80.0,
      grade: 'A',
      completedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    LeaderboardEntry(
      userId: 'u3',
      userName: 'Karim Hossain',
      categoryName: 'Computers',
      score: 100,
      maxScore: 150,
      percentage: 66.7,
      grade: 'B',
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    LeaderboardEntry(
      userId: 'u4',
      userName: 'Shirin Akter',
      categoryName: 'Mathematics',
      score: 85,
      maxScore: 150,
      percentage: 56.7,
      grade: 'C',
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    LeaderboardEntry(
      userId: 'u5',
      userName: 'Tanvir Islam',
      categoryName: 'Sports',
      score: 130,
      maxScore: 150,
      percentage: 86.7,
      grade: 'A',
      completedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  @override
  Future<List<LeaderboardEntry>> getEntries({String? categoryName}) async {
    await Future.delayed(const Duration(milliseconds: 400)); // simulate network
    final filtered = categoryName == null
        ? _entries
        : _entries.where((e) => e.categoryName == categoryName).toList();
    final sorted = [...filtered]..sort((a, b) => b.score.compareTo(a.score));
    return sorted;
  }

  @override
  Future<void> submitEntry(LeaderboardEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Remove previous entry by same user + category, then add new one
    _entries.removeWhere(
      (e) => e.userId == entry.userId && e.categoryName == entry.categoryName,
    );
    _entries.add(entry);
  }
}

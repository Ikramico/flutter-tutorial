import 'package:equatable/equatable.dart';

class LeaderboardEntry extends Equatable {
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String categoryName;
  final int score;
  final int maxScore;
  final double percentage;
  final DateTime completedAt;

  const LeaderboardEntry({
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.categoryName,
    required this.score,
    required this.maxScore,
    required this.percentage,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [userId, categoryName, score, completedAt];
}

abstract class LeaderboardRepository {
  Future<void> submitScore(LeaderboardEntry entry);
  Future<List<LeaderboardEntry>> getGlobalLeaderboard();
  Future<List<LeaderboardEntry>> getCategoryLeaderboard(String categoryName);
}

/// In-memory leaderboard — seeded with mock participants
class MockLeaderboardRepository implements LeaderboardRepository {
  final List<LeaderboardEntry> _entries = [
    LeaderboardEntry(
      userId: 'mock-p1',
      userName: 'Rahim Uddin',
      categoryName: 'Flutter',
      score: 90,
      maxScore: 100,
      percentage: 90,
      completedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    LeaderboardEntry(
      userId: 'mock-p2',
      userName: 'Fatema Begum',
      categoryName: 'Dart Language',
      score: 80,
      maxScore: 100,
      percentage: 80,
      completedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    LeaderboardEntry(
      userId: 'mock-p3',
      userName: 'Karim Hassan',
      categoryName: 'Firebase',
      score: 70,
      maxScore: 100,
      percentage: 70,
      completedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    LeaderboardEntry(
      userId: 'mock-p4',
      userName: 'Sumaiya Akter',
      categoryName: 'Flutter',
      score: 100,
      maxScore: 100,
      percentage: 100,
      completedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    LeaderboardEntry(
      userId: 'mock-p5',
      userName: 'Nafis Rahman',
      categoryName: 'REST & HTTP',
      score: 60,
      maxScore: 100,
      percentage: 60,
      completedAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    LeaderboardEntry(
      userId: 'mock-p6',
      userName: 'Tamanna Islam',
      categoryName: 'Git & GitHub',
      score: 50,
      maxScore: 100,
      percentage: 50,
      completedAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    LeaderboardEntry(
      userId: 'mock-p7',
      userName: 'Jubayer Ahmed',
      categoryName: 'UI/UX Design',
      score: 85,
      maxScore: 100,
      percentage: 85,
      completedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    LeaderboardEntry(
      userId: 'mock-p8',
      userName: 'Nadia Chowdhury',
      categoryName: 'Dart Language',
      score: 95,
      maxScore: 100,
      percentage: 95,
      completedAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
  ];

  @override
  Future<void> submitScore(LeaderboardEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Remove old entry for same user+category, then add new
    _entries.removeWhere(
      (e) => e.userId == entry.userId && e.categoryName == entry.categoryName,
    );
    _entries.add(entry);
  }

  @override
  Future<List<LeaderboardEntry>> getGlobalLeaderboard() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final sorted = List<LeaderboardEntry>.from(_entries)
      ..sort((a, b) => b.score.compareTo(a.score));
    return sorted;
  }

  @override
  Future<List<LeaderboardEntry>> getCategoryLeaderboard(
    String categoryName,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final filtered =
        _entries.where((e) => e.categoryName == categoryName).toList()
          ..sort((a, b) => b.score.compareTo(a.score));
    return filtered;
  }
}

part of 'leaderboard_bloc.dart';

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object?> get props => [];
}

class LeaderboardLoadRequested extends LeaderboardEvent {
  const LeaderboardLoadRequested();
}

class LeaderboardFilterChanged extends LeaderboardEvent {
  /// null means "All categories"
  final String? categoryName;

  const LeaderboardFilterChanged(this.categoryName);

  @override
  List<Object?> get props => [categoryName];
}

class LeaderboardScoreSubmitted extends LeaderboardEvent {
  final AppUser user;
  final QuizResult result;

  const LeaderboardScoreSubmitted(this.user, this.result);

  @override
  List<Object?> get props => [user, result];
}

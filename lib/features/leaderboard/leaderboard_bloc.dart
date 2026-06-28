// lib/features/leaderboard/leaderboard_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutteria/features/quiz/quiz_result.dart';
import '../../data/app_user.dart';
import '../../data/repositories/leaderboard_repository.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final LeaderboardRepository _repository;
  String? _activeFilter;

  LeaderboardBloc(this._repository) : super(const LeaderboardInitial()) {
    on<LeaderboardLoadRequested>(_onLoad);
    on<LeaderboardFilterChanged>(_onFilterChanged);
    on<LeaderboardScoreSubmitted>(_onScoreSubmitted);
  }

  Future<void> _onLoad(
    LeaderboardLoadRequested event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(const LeaderboardLoading());
    try {
      final entries = await _repository.getEntries(categoryName: _activeFilter);
      emit(LeaderboardLoaded(entries, activeFilter: _activeFilter));
    } catch (e) {
      emit(LeaderboardError(e.toString()));
    }
  }

  Future<void> _onFilterChanged(
    LeaderboardFilterChanged event,
    Emitter<LeaderboardState> emit,
  ) async {
    _activeFilter = event.categoryName;
    emit(const LeaderboardLoading());
    try {
      final entries = await _repository.getEntries(categoryName: _activeFilter);
      emit(LeaderboardLoaded(entries, activeFilter: _activeFilter));
    } catch (e) {
      emit(LeaderboardError(e.toString()));
    }
  }

  Future<void> _onScoreSubmitted(
    LeaderboardScoreSubmitted event,
    Emitter<LeaderboardState> emit,
  ) async {
    try {
      final entry = LeaderboardEntry(
        userId: event.user.id,
        userName: event.user.displayName,
        categoryName: event.result.categoryName,
        score: event.result.totalScore,
        maxScore: event.result.maxScore,
        percentage: event.result.percentage,
        grade: event.result.grade,
        completedAt: DateTime.now(),
      );
      await _repository.submitEntry(entry);
      // Reload so the leaderboard reflects the new score immediately.
      final entries = await _repository.getEntries(categoryName: _activeFilter);
      emit(LeaderboardLoaded(entries, activeFilter: _activeFilter));
    } catch (e) {
      emit(LeaderboardError(e.toString()));
    }
  }
}

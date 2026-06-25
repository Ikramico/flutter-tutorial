import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/leaderboard_repository.dart';
import '../../data/app_user.dart';
import '../quiz/quiz_result.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final LeaderboardRepository _repository;

  String? _activeFilter;

  LeaderboardBloc(this._repository) : super(const LeaderboardInitial()) {
    on<LeaderboardLoadRequested>(_onLoad);
    on<LeaderboardFilterChanged>(_onFilter);
    on<LeaderboardScoreSubmitted>(_onSubmit);
  }

  Future<void> _onLoad(
    LeaderboardLoadRequested event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(const LeaderboardLoading());
    try {
      final entries = _activeFilter == null
          ? await _repository.getGlobalLeaderboard()
          : await _repository.getCategoryLeaderboard(_activeFilter!);
      emit(LeaderboardLoaded(entries, activeFilter: _activeFilter));
    } catch (e) {
      emit(LeaderboardError(e.toString()));
    }
  }

  Future<void> _onFilter(
    LeaderboardFilterChanged event,
    Emitter<LeaderboardState> emit,
  ) async {
    _activeFilter = event.categoryName;
    add(const LeaderboardLoadRequested());
  }

  Future<void> _onSubmit(
    LeaderboardScoreSubmitted event,
    Emitter<LeaderboardState> emit,
  ) async {
    final entry = LeaderboardEntry(
      userId: event.user.id,
      userName: event.user.name,
      userPhotoUrl: event.user.photoUrl,
      categoryName: event.result.categoryName,
      score: event.result.totalScore,
      maxScore: event.result.maxScore,
      percentage: event.result.percentage,
      completedAt: DateTime.now(),
    );
    await _repository.submitScore(entry);
    add(const LeaderboardLoadRequested());
  }
}

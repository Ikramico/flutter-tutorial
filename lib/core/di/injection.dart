// lib/core/di/injection.dart

import 'package:get_it/get_it.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/quiz_repository.dart';
import '../../data/repositories/leaderboard_repository.dart';
import '../../features/auth/auth_bloc.dart';
import '../../features/quiz/quiz_bloc.dart';
import '../../features/leaderboard/leaderboard_bloc.dart';
import '../../features/category/category_bloc.dart';

final GetIt sl = GetIt.instance;

void setupDI() {
  // ── Repositories (singletons — one instance for app lifetime) ─────────────
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
  sl.registerLazySingleton<CategoryRepository>(() => ApiCategoryRepository());
  sl.registerLazySingleton<QuizRepository>(() => ApiQuizRepository());
  sl.registerLazySingleton<LeaderboardRepository>(
    () => MockLeaderboardRepository(),
  );

  // ── BLoCs (factories — fresh instance per page push) ─────────────────────
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl<AuthRepository>()));
  sl.registerFactory<CategoryBloc>(() => CategoryBloc(sl<CategoryRepository>()));
  sl.registerFactory<QuizBloc>(() => QuizBloc(sl<QuizRepository>()));
  sl.registerFactory<LeaderboardBloc>(
    () => LeaderboardBloc(sl<LeaderboardRepository>()),
  );
}
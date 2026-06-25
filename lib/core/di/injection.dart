import 'package:get_it/get_it.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/quiz_repository.dart';
import '../../data/repositories/leaderboard_repository.dart';

final GetIt sl = GetIt.instance;

void setupDI() {
  // Auth
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());

  // Data — real API implementations
  sl.registerLazySingleton<CategoryRepository>(() => ApiCategoryRepository());
  sl.registerLazySingleton<QuizRepository>(() => ApiQuizRepository());

  // Leaderboard stays in-memory (no leaderboard API provided)
  sl.registerLazySingleton<LeaderboardRepository>(
    () => MockLeaderboardRepository(),
  );
}

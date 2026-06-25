import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/category.dart';
import '../../features/auth/auth_bloc.dart';
import '../../features/auth/view/login_page.dart';
import '../../features/home/home_screen.dart';
import '../../features/category/view/category_page.dart';
import '../../features/profile/profile_page_wrapper.dart';
import '../../features/quiz/quiz_result.dart';
import '../../features/quiz/view/quiz_page.dart';
import '../../features/result/view/result_page.dart';
import '../../features/leaderboard/view/leaderboard_page.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/';
  static const categories = '/categories';
  static const quiz = '/quiz';
  static const result = '/result';
  static const leaderboard = '/leaderboard';
  static const profile = '/profile';
}

GoRouter buildRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isLoginPage = state.matchedLocation == AppRoutes.login;

      if (authState is AuthAuthenticated && isLoginPage) {
        return AppRoutes.home;
      }
      if (authState is! AuthAuthenticated &&
          authState is! AuthLoading &&
          authState is! AuthInitial &&
          !isLoginPage) {
        return AppRoutes.login;
      }
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
      GoRoute(path: AppRoutes.home, builder: (_, __) => const HomeScreen()),
      GoRoute(
        path: AppRoutes.categories,
        builder: (_, __) => const CategoryPage(),
      ),
      GoRoute(
        path: AppRoutes.quiz,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final category = extra['category'] as QuizCategory;
          return QuizPage(category: category);
        },
      ),
      GoRoute(
        path: AppRoutes.result,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final result = extra['result'] as QuizResult;
          return ResultPage(result: result);
        },
      ),
      GoRoute(
        path: AppRoutes.leaderboard,
        builder: (_, __) => const LeaderboardPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, __) => const ProfilePageWrapper(),
      ),
    ],
  );
}

// Converts a Bloc stream to a Listenable for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    stream.listen((_) => notifyListeners());
  }
}

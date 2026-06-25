// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/category_repository.dart';
import 'data/repositories/quiz_repository.dart';
import 'features/auth/auth_bloc.dart';
import 'features/category/category_bloc.dart';
import 'features/quiz/quiz_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // required before any plugin use
  setupDI();
  runApp(const FlutterMasteryApp());
}

class FlutterMasteryApp extends StatefulWidget {
  const FlutterMasteryApp({super.key});

  @override
  State<FlutterMasteryApp> createState() => _FlutterMasteryAppState();
}

class _FlutterMasteryAppState extends State<FlutterMasteryApp> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    // AuthBloc fires AuthCheckRequested in its constructor,
    // so the silent restore happens automatically here.
    _authBloc = AuthBloc(sl<AuthRepository>());
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider(create: (_) => CategoryBloc(sl<CategoryRepository>())),
        BlocProvider(create: (_) => QuizBloc(sl<QuizRepository>())),
      ],
      child: Builder(
        builder: (context) {
          final router = buildRouter(_authBloc);
          return MaterialApp.router(
            title: 'Flutter Mastery',
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(),
            routerConfig: router,
          );
        },
      ),
    );
  }
}

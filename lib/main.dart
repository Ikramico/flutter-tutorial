// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDI(); // ✅ registers all repos + blocs with GetIt
  runApp(const FlutteriaApp());
}

class FlutteriaApp extends StatelessWidget {
  const FlutteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _RouterShell(),
    );
  }
}

/// Separate widget so we can call context.read<AuthBloc>()
/// after BlocProvider is in the widget tree.
class _RouterShell extends StatefulWidget {
  const _RouterShell();

  @override
  State<_RouterShell> createState() => _RouterShellState();
}

class _RouterShellState extends State<_RouterShell> {
  late final _router = buildRouter(context.read<AuthBloc>());

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutteria',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: _router,
    );
  }
}
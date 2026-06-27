// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'features/auth/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ FIX: Was missing entirely — DI container was never initialised,
  //    so repositories were never registered with GetIt.
  setupDI();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => sl<AuthBloc>(), child: _RouterShell());
  }
}

// Separate widget so we can read AuthBloc after BlocProvider is in the tree.
class _RouterShell extends StatefulWidget {
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
      routerConfig: _router,
    );
  }
}

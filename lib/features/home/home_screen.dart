// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutteria'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () => _showSnack(context, 'No new notifications'),
          ),
          GestureDetector(
            onTap: () => context.push(AppRoutes.profile),
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 4),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final initials = state is AuthAuthenticated
                      ? state.user.initials
                      : '?';
                  return CircleAvatar(
                    radius: 17,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Greeting ────────────────────────────────────────────────────
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final name = state is AuthAuthenticated
                    ? state.user.displayName.split(' ').first
                    : 'there';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello, $name 👋', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    const Text(
                      'Ready to test your knowledge?',
                      style: AppTextStyles.body,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),

            // ── Hero banner ─────────────────────────────────────────────────
            _HeroBanner(),
            const SizedBox(height: 28),

            // ── Quiz & Leaderboard CTAs ─────────────────────────────────────
            const Text('Test Your Skills', style: AppTextStyles.h3),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _CTACard(
                    emoji: '🎯',
                    title: 'Take a Quiz',
                    subtitle: '24 categories available',
                    gradient: AppColors.gradientPrimary,
                    onTap: () => context.push(AppRoutes.categories),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _CTACardLight(
                    emoji: '🏆',
                    title: 'Leader-\nboard',
                    onTap: () => context.push(AppRoutes.leaderboard),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // ── How it works ────────────────────────────────────────────────
            const Text('How It Works', style: AppTextStyles.h3),
            const SizedBox(height: 14),
            _HowItWorks(),
          ],
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.gradientQuiz,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🎓', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 12),
          const Text(
            'Sharpen your\ndev skills daily',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Timed quizzes · Grade S–F · Global leaderboard',
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.push(AppRoutes.categories),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              minimumSize: const Size(140, 44),
            ),
            child: const Text('Start Now →'),
          ),
        ],
      ),
    );
  }
}

class _CTACard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _CTACard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CTACardLight extends StatelessWidget {
  final String emoji;
  final String title;
  final VoidCallback onTap;

  const _CTACardLight({
    required this.emoji,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFFFB74D).withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFE65100),
                fontSize: 15,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const steps = [
      ('1', '🗂️', 'Pick a Category', 'Choose from 24 trivia topics'),
      ('2', '⏱️', 'Answer in 30s', '30 seconds per question'),
      ('3', '📊', 'Get Graded', 'S, A, B, C or F grade'),
      ('4', '🏆', 'Hit Leaderboard', 'Compete with everyone'),
    ];

    return Column(
      children: steps
          .map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          s.$1,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(s.$2, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.$3, style: AppTextStyles.label),
                          Text(s.$4, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

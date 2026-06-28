// lib/features/auth/view/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Container(
            decoration: const BoxDecoration(
              gradient: AppColors.gradientPrimary,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // ── Logo / branding ──────────────────────────────────
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Center(
                        child: Text('🎯', style: TextStyle(fontSize: 44)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Flutteria',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Test your Flutter & dev knowledge\nwith timed quizzes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),

                    const Spacer(flex: 2),

                    // ── Feature pills ────────────────────────────────────
                    _FeatureRow(),
                    const SizedBox(height: 48),

                    // ── Google Sign-In button ────────────────────────────
                    if (isLoading)
                      const CircularProgressIndicator(color: Colors.white)
                    else
                      _GoogleSignInButton(
                        onTap: () => context.read<AuthBloc>().add(
                          const AuthGoogleSignInRequested(),
                        ),
                      ),

                    const SizedBox(height: 20),
                    Text(
                      'By continuing you agree to our Terms & Privacy Policy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.45),
                        fontSize: 11,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback onTap;
  const _GoogleSignInButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google 'G' logo rendered with coloured text
            const Text(
              'G',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF4285F4),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Continue with Google',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1730),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = [('⏱️', 'Timed'), ('🏆', 'Ranked'), ('📊', 'Graded')];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items
          .map(
            (item) => Column(
              children: [
                Text(item.$1, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 6),
                Text(
                  item.$2,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

// lib/features/profile/profile_page_wrapper.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_bloc.dart';

class ProfilePageWrapper extends StatelessWidget {
  const ProfilePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return _ProfilePage(user: state.user);
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class _ProfilePage extends StatelessWidget {
  final dynamic user; // AppUser
  const _ProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: BackButton(onPressed: () => context.pop()),
        actions: [
          TextButton.icon(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthSignOutRequested());
              context.go(AppRoutes.login);
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: 18,
            ),
            label: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            // ── Avatar ─────────────────────────────────────────────────────
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.gradientPrimary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  user.initials as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.displayName as String,
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(user.email as String, style: AppTextStyles.body),
            const SizedBox(height: 32),

            // ── Info card ──────────────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.verified_user_outlined,
                      label: 'Account',
                      value: 'Google Sign-In',
                    ),
                    const Divider(height: 24),
                    _InfoRow(
                      icon: Icons.fingerprint_rounded,
                      label: 'User ID',
                      value: (user.id as String).length > 16
                          ? '${(user.id as String).substring(0, 16)}…'
                          : user.id as String,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── Sign out button ────────────────────────────────────────────
            OutlinedButton.icon(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthSignOutRequested());
                context.go(AppRoutes.login);
              },
              icon: const Icon(Icons.logout_rounded, color: AppColors.error),
              label: const Text(
                'Sign Out',
                style: TextStyle(color: AppColors.error),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.label),
        const Spacer(),
        Text(value, style: AppTextStyles.body),
      ],
    );
  }
}

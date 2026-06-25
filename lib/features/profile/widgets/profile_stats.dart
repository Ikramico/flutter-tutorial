import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text('Quiz Stats', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatCard(
                value: '12',
                label: 'Quizzes\nCompleted',
                icon: Icons.quiz_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              _StatCard(
                value: '78%',
                label: 'Average\nAccuracy',
                icon: Icons.gps_fixed_rounded,
                color: AppColors.success,
              ),
              const SizedBox(width: 12),
              _StatCard(
                value: '#5',
                label: 'Global\nRank',
                icon: Icons.emoji_events_outlined,
                color: const Color(0xFFFFB74D),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

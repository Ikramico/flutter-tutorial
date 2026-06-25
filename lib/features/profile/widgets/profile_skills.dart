import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProfileSkills extends StatelessWidget {
  const ProfileSkills({super.key});

  static const _skills = [
    {'name': 'Flutter Widgets', 'level': 0.85},
    {'name': 'Dart Language', 'level': 0.75},
    {'name': 'State Management', 'level': 0.60},
    {'name': 'Firebase', 'level': 0.50},
    {'name': 'REST APIs', 'level': 0.70},
    {'name': 'UI/UX Design', 'level': 0.55},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.psychology_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text('Skills', style: AppTextStyles.h3),
              ],
            ),
            const SizedBox(height: 16),
            ..._skills.map(
              (s) => _SkillBar(
                name: s['name'] as String,
                level: s['level'] as double,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  final String name;
  final double level;

  const _SkillBar({required this.name, required this.level});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${(level * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: level,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              minHeight: 7,
            ),
          ),
        ],
      ),
    );
  }
}

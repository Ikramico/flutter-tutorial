import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProfileExperience extends StatelessWidget {
  const ProfileExperience({super.key});

  static const _experiences = [
    {
      'role': 'Flutter Developer (Intern)',
      'company': 'TechStart BD',
      'period': 'Jan 2024 – Present',
      'icon': '💼',
    },
    {
      'role': 'Freelance App Developer',
      'company': 'Self-employed',
      'period': 'Jun 2023 – Dec 2023',
      'icon': '🚀',
    },
    {
      'role': 'Web Developer',
      'company': 'Local Agency, Rajshahi',
      'period': 'Jan 2023 – May 2023',
      'icon': '🌐',
    },
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
                  Icons.work_outline_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text('Experience', style: AppTextStyles.h3),
              ],
            ),
            const SizedBox(height: 16),
            ..._experiences.asMap().entries.map(
              (e) => _ExperienceTile(
                experience: e.value,
                isLast: e.key == _experiences.length - 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienceTile extends StatelessWidget {
  final Map<String, String> experience;
  final bool isLast;

  const _ExperienceTile({required this.experience, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    experience['icon']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: AppColors.divider,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    experience['role']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    experience['company']!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(experience['period']!, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProfileEducation extends StatelessWidget {
  const ProfileEducation({super.key});

  static const _educations = [
    {
      'degree': 'B.Sc. in Computer Science',
      'institution': 'Rajshahi University of Engineering & Technology',
      'period': '2021 – Present',
      'icon': '🎓',
    },
    {
      'degree': 'Higher Secondary Certificate',
      'institution': 'Rajshahi College',
      'period': '2019 – 2021',
      'icon': '🏫',
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
                Icon(Icons.school_outlined, color: AppColors.primary, size: 18),
                SizedBox(width: 8),
                Text('Education', style: AppTextStyles.h3),
              ],
            ),
            const SizedBox(height: 16),
            ..._educations.map(
              (edu) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(edu['icon']!, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            edu['degree']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            edu['institution']!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(edu['period']!, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

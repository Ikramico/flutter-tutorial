import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ContentSection extends StatelessWidget {
  final ValueChanged<String> onModuleTap;

  const ContentSection({super.key, required this.onModuleTap});

  static const _modules = [
    {
      'icon': '🧱',
      'title': 'Widgets 101',
      'subtitle': '12 lessons',
      'progress': 0.8,
    },
    {
      'icon': '🎨',
      'title': 'Styling & Themes',
      'subtitle': '8 lessons',
      'progress': 0.5,
    },
    {
      'icon': '🔀',
      'title': 'Navigation',
      'subtitle': '6 lessons',
      'progress': 0.3,
    },
    {
      'icon': '⚡',
      'title': 'State Management',
      'subtitle': '10 lessons',
      'progress': 0.1,
    },
    {
      'icon': '🌐',
      'title': 'Networking',
      'subtitle': '7 lessons',
      'progress': 0.0,
    },
    {
      'icon': '🧪',
      'title': 'Testing',
      'subtitle': '5 lessons',
      'progress': 0.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Learning Modules', style: AppTextStyles.h3),
              TextButton(
                onPressed: () => onModuleTap('View all modules'),
                child: const Text(
                  'See all',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...(_modules
              .map((m) => _ModuleTile(module: m, onTap: onModuleTap))
              .toList()),
        ],
      ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  final Map<String, dynamic> module;
  final ValueChanged<String> onTap;

  const _ModuleTile({required this.module, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final progress = module['progress'] as double;
    final isStarted = progress > 0;

    return GestureDetector(
      onTap: () => onTap('Opened: ${module['title']}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  module['icon'] as String,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module['title'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    module['subtitle'] as String,
                    style: AppTextStyles.bodySmall,
                  ),
                  if (isStarted) ...[
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.divider,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isStarted ? Icons.play_circle_rounded : Icons.lock_open_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ResourcesSection extends StatelessWidget {
  final ValueChanged<String> onTap;

  const ResourcesSection({super.key, required this.onTap});

  static const _resources = [
    {
      'icon': '📄',
      'title': 'Official Flutter Docs',
      'subtitle': 'docs.flutter.dev',
      'tag': 'DOCS',
      'tagColor': 0xFF3B82F6,
    },
    {
      'icon': '🎓',
      'title': 'Dart Language Tour',
      'subtitle': 'dart.dev/guides',
      'tag': 'GUIDE',
      'tagColor': 0xFF10B981,
    },
    {
      'icon': '📦',
      'title': 'pub.dev Packages',
      'subtitle': 'pub.dev',
      'tag': 'PACKAGES',
      'tagColor': 0xFFF59E0B,
    },
    {
      'icon': '💬',
      'title': 'Flutter Community',
      'subtitle': 'flutter.dev/community',
      'tag': 'COMMUNITY',
      'tagColor': 0xFF8B5CF6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Resources', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
            ),
            itemCount: _resources.length,
            itemBuilder: (context, i) {
              final r = _resources[i];
              final tagColor = Color(r['tagColor'] as int);
              return GestureDetector(
                onTap: () => onTap('Opened: ${r['title']}'),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            r['icon'] as String,
                            style: const TextStyle(fontSize: 22),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: tagColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              r['tag'] as String,
                              style: TextStyle(
                                color: tagColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        r['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        r['subtitle'] as String,
                        style: AppTextStyles.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

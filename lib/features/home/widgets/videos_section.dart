import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class VideosSection extends StatelessWidget {
  final ValueChanged<String> onTap;

  const VideosSection({super.key, required this.onTap});

  static const _videos = [
    {
      'thumbnail': '🧱',
      'title': 'Flutter Widgets Deep Dive',
      'channel': 'Flutter Team',
      'duration': '18:42',
      'views': '124K views',
    },
    {
      'thumbnail': '⚡',
      'title': 'BLoC Pattern Explained',
      'channel': 'Felix Angelov',
      'duration': '32:10',
      'views': '89K views',
    },
    {
      'thumbnail': '🚀',
      'title': 'GoRouter Full Course',
      'channel': 'Flutter Mapp',
      'duration': '45:00',
      'views': '56K views',
    },
    {
      'thumbnail': '🔥',
      'title': 'Firebase + Flutter Setup',
      'channel': 'Fireship',
      'duration': '12:28',
      'views': '210K views',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Video Tutorials', style: AppTextStyles.h3),
              TextButton(
                onPressed: () => onTap('View all videos'),
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
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: _videos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final v = _videos[i];
              return GestureDetector(
                onTap: () => onTap('Playing: ${v['title']}'),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
                      Container(
                        height: 108,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(14),
                            topRight: Radius.circular(14),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                v['thumbnail'] as String,
                                style: const TextStyle(fontSize: 40),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  v['duration'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: AppColors.primary,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Info
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              v['title'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${v['channel']} · ${v['views']}',
                              style: AppTextStyles.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/shared_widgets.dart';

class VideosSection extends StatelessWidget {
  final ValueChanged<String> onTap;

  const VideosSection({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('🎥 Video Tutorials'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _VideoCard(
                title: 'Building Beautiful UIs',
                duration: '45 min • Beginner',
                onTap: () => onTap('Playing: Building Beautiful UIs'),
              ),
              const SizedBox(height: 16),
              _VideoCard(
                title: 'State Management Explained',
                duration: '1 hr 10 min • Intermediate',
                onTap: () => onTap('Playing: State Management Explained'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VideoCard extends StatelessWidget {
  final String title;
  final String duration;
  final VoidCallback onTap;

  const _VideoCard({
    required this.title,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.play_circle_fill,
                    size: 40, color: Colors.redAccent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(duration,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

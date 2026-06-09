import 'package:flutter/material.dart';
import '../../../core/shared_widgets.dart';

class ResourcesSection extends StatelessWidget {
  final ValueChanged<String> onTap;

  const ResourcesSection({super.key, required this.onTap});

  static const _resources = [
    ('Dart Basics',           Icons.book),
    ('UI/UX Principles',      Icons.design_services),
    ('Firebase Integration',  Icons.cloud),
    ('Performance Tips',      Icons.speed),
    ('Package Ecosystem',     Icons.extension),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('📖 Learning Resources'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _resources
                .map((r) => _ResourceChip(
                      label: r.$1,
                      icon: r.$2,
                      onTap: () => onTap('Opened resource: ${r.$1}'),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _ResourceChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ResourceChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        avatar: Icon(icon, size: 18, color: Colors.deepPurple),
        label: Text(label),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.deepPurple, width: 1.5),
      ),
    );
  }
}

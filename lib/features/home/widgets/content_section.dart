import 'package:flutter/material.dart';
import '../../../core/shared_widgets.dart';

class ContentSection extends StatelessWidget {
  final ValueChanged<String> onModuleTap;

  const ContentSection({super.key, required this.onModuleTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('📚 Latest Content'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _ContentCard(
                  title: 'Widgets Deep Dive',
                  subtitle: 'Container, Row, Column & more',
                  icon: Icons.widgets,
                  color: Colors.blue,
                  onTap: () => onModuleTap('Opening Widgets Deep Dive...'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ContentCard(
                  title: 'State Management',
                  subtitle: 'setState, Provider, Riverpod',
                  icon: Icons.animation,
                  color: Colors.orange,
                  onTap: () => onModuleTap('Opening State Management...'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ContentCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(double.infinity, 44),
              ),
              child: const Text('Start Module'),
            ),
          ],
        ),
      ),
    );
  }
}

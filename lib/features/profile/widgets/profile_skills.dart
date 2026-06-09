import 'package:flutter/material.dart';
import '../../../core/shared_widgets.dart';

class ProfileSkills extends StatelessWidget {
  const ProfileSkills({super.key});

  static const _skills = [
    ('Flutter',  Icons.phone_android,         0.92, Color(0xFF54C5F8)),
    ('Dart',     Icons.code,                  0.90, Color(0xFF00B4AB)),
    ('React',    Icons.web,                   0.75, Color(0xFF61DAFB)),
    ('Firebase', Icons.local_fire_department, 0.80, Color(0xFFFFCA28)),
    ('Figma',    Icons.design_services,       0.70, Color(0xFFFF7262)),
    ('Git',      Icons.merge_type,            0.85, Color(0xFFF05032)),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardHeader(
                  icon: Icons.bar_chart, title: 'Skills & Technologies'),
              const SizedBox(height: 16),
              ..._skills.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _SkillRow(
                      label: s.$1, icon: s.$2, level: s.$3, color: s.$4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final double level;
  final Color color;

  const _SkillRow({
    required this.label,
    required this.icon,
    required this.level,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
            ),
            Text('${(level * 100).round()}%',
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: level,
            minHeight: 6,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

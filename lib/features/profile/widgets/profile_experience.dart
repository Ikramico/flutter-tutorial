import 'package:flutter/material.dart';
import '../../../core/shared_widgets.dart';

class ProfileExperience extends StatelessWidget {
  const ProfileExperience({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardHeader(icon: Icons.work_outline, title: 'Experience'),
              SizedBox(height: 16),
              _ExpTile(
                role: 'Flutter Developer',
                company: 'TechVenture BD',
                period: 'Jan 2024 — Present',
                desc: 'Lead dev on 2 production apps (10k+ users). Built complex '
                    'animations, Provider/Riverpod state management, and CI/CD pipelines.',
                color: Color(0xFF54C5F8),
                icon: Icons.phone_android,
              ),
              Divider(height: 28),
              _ExpTile(
                role: 'Mobile & Web Developer',
                company: 'Freelance',
                period: 'Jun 2022 — Dec 2023',
                desc: 'Delivered 15+ client projects across Flutter, React, and Node.js. '
                    'Specialized in MVP builds and startup dashboards.',
                color: Color(0xFF6B46C1),
                icon: Icons.work_outline,
              ),
              Divider(height: 28),
              _ExpTile(
                role: 'Student Developer (Intern)',
                company: 'BUET Project Lab',
                period: 'Mar 2022 — Jun 2022',
                desc: 'Built an IoT monitoring dashboard in Flutter integrating '
                    'real-time Firebase data streams for sensor readings.',
                color: Color(0xFF4DB33D),
                icon: Icons.science_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpTile extends StatelessWidget {
  final String role, company, period, desc;
  final Color color;
  final IconData icon;

  const _ExpTile({
    required this.role,
    required this.company,
    required this.period,
    required this.desc,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 2),
              Text(company,
                  style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(period,
                  style:
                      const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 6),
              Text(desc,
                  style: const TextStyle(
                      color: Colors.black87, fontSize: 13, height: 1.55)),
            ],
          ),
        ),
      ],
    );
  }
}

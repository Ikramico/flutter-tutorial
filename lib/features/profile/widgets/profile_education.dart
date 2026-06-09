import 'package:flutter/material.dart';
import '../../../core/shared_widgets.dart';

class ProfileEducation extends StatelessWidget {
  const ProfileEducation({super.key});

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
              CardHeader(icon: Icons.school_outlined, title: 'Education'),
              SizedBox(height: 16),
              _EduTile(
                degree: 'B.Sc. in Computer Science & Engineering',
                institution:
                    'Bangladesh University of Engineering & Technology (BUET)',
                period: '2020 — Present',
                grade: 'CGPA 3.75 / 4.00',
                color: Color(0xFF7C3AED),
                icon: Icons.school_outlined,
              ),
              Divider(height: 28),
              _EduTile(
                degree: 'Higher Secondary Certificate (Science)',
                institution: 'Dhaka College',
                period: '2018 — 2020',
                grade: 'GPA 5.00 / 5.00',
                color: Color(0xFFF59E0B),
                icon: Icons.menu_book_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EduTile extends StatelessWidget {
  final String degree, institution, period, grade;
  final Color color;
  final IconData icon;

  const _EduTile({
    required this.degree,
    required this.institution,
    required this.period,
    required this.grade,
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
              Text(degree,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 3),
              Text(institution,
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 13, height: 1.4)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(period,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 12)),
                  const SizedBox(width: 12),
                  Icon(Icons.star_rounded, size: 13, color: color),
                  const SizedBox(width: 3),
                  Text(grade,
                      style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

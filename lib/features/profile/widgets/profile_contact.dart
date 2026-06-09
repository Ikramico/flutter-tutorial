import 'package:flutter/material.dart';
import '../../../core/shared_widgets.dart';

class ProfileContact extends StatelessWidget {
  const ProfileContact({super.key});

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
                  icon: Icons.contact_mail_outlined,
                  title: 'Contact & Socials'),
              const SizedBox(height: 16),
              const _ContactRow(
                  icon: Icons.mail_outline,
                  label: 'ikram@dev.com',
                  color: Colors.deepPurple),
              const SizedBox(height: 10),
              const _ContactRow(
                  icon: Icons.phone_outlined,
                  label: '+880 17XX-XXXXXX',
                  color: Colors.green),
              const SizedBox(height: 10),
              const _ContactRow(
                  icon: Icons.location_on_outlined,
                  label: 'Dhaka, Bangladesh',
                  color: Colors.redAccent),
              const Divider(height: 28),
              const Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _SocialChip(
                      icon: Icons.code,
                      label: 'GitHub',
                      color: Color(0xFF6E5494)),
                  _SocialChip(
                      icon: Icons.business_center_outlined,
                      label: 'LinkedIn',
                      color: Color(0xFF0A66C2)),
                  _SocialChip(
                      icon: Icons.alternate_email,
                      label: 'Twitter',
                      color: Color(0xFF1DA1F2)),
                  _SocialChip(
                      icon: Icons.camera_alt_outlined,
                      label: 'Instagram',
                      color: Color(0xFFE1306C)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 14),
        Text(label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _SocialChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SocialChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

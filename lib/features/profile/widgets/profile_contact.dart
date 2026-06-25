import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProfileContact extends StatelessWidget {
  const ProfileContact({super.key});

  static const _contacts = [
    {
      'icon': Icons.email_outlined,
      'label': 'Email',
      'value': 'ishtiaq@example.com',
      'color': 0xFF3B82F6,
    },
    {
      'icon': Icons.phone_outlined,
      'label': 'Phone',
      'value': '+880 1700-000000',
      'color': 0xFF10B981,
    },
    {
      'icon': Icons.location_on_outlined,
      'label': 'Location',
      'value': 'Rajshahi, Bangladesh',
      'color': 0xFFEF4444,
    },
    {
      'icon': Icons.link_rounded,
      'label': 'GitHub',
      'value': 'github.com/ishtiaq',
      'color': 0xFF8B5CF6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.contact_mail_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text('Contact', style: AppTextStyles.h3),
              ],
            ),
            const SizedBox(height: 16),
            ..._contacts.map((c) {
              final color = Color(c['color'] as int);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        c['icon'] as IconData,
                        color: color,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c['label'] as String,
                            style: AppTextStyles.bodySmall,
                          ),
                          Text(
                            c['value'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

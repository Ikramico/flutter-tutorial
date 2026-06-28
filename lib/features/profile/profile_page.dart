

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.success,
      appBar: AppBar(
        title: const Text('My Profile'),
        leading: const BackButton(color: Colors.white),
        elevation: 0,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 64,
                color: AppColors.primary,
              ),
              SizedBox(height: 16),
              Text('Profile Page', style: AppTextStyles.h2),
              SizedBox(height: 8),
              Text(
                'Sub-widgets (profile_header, profile_bio, etc.) are not built yet.\n'
                'This placeholder prevents compile errors.',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

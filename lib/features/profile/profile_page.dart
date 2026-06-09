import 'package:flutter/material.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_bio.dart';
import 'widgets/profile_stats.dart';
import 'widgets/profile_skills.dart';
import 'widgets/profile_experience.dart';
import 'widgets/profile_education.dart';
import 'widgets/profile_contact.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        leading: const BackButton(color: Colors.white),
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(),
            SizedBox(height: 24),
            ProfileBio(),
            SizedBox(height: 20),
            ProfileStats(),
            SizedBox(height: 20),
            ProfileSkills(),
            SizedBox(height: 20),
            ProfileExperience(),
            SizedBox(height: 20),
            ProfileEducation(),
            SizedBox(height: 20),
            ProfileContact(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

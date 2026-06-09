import 'package:flutter/material.dart';
import '../../../core/app_constants.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 160,
          width: double.infinity,
          decoration: gradientDecoration,
        ),
        Positioned(
          bottom: -50,
          child: Container(
            width: 106,
            height: 106,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/profile.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: kPrimaryLight,
                  child:
                      const Icon(Icons.person, color: Colors.white, size: 60),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

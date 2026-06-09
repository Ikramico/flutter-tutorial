import 'package:flutter/material.dart';
import '../../../core/app_constants.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onProfile;

  const HeroSection({
    super.key,
    required this.onStart,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: gradientDecoration,
      child: Column(
        children: [
          Image.asset(
            'assets/images/flutter_logo.png',
            height: 120,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.flutter_dash, size: 120, color: Colors.white),
          ),
          const SizedBox(height: 24),
          const Text(
            'Master Flutter Development',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'From widgets to real-world apps — Learn, Practice, Build',
            style: TextStyle(fontSize: 18, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow),
            label: const Text(
              'Start Learning',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onProfile,
            icon: const Icon(Icons.person_outline, color: Colors.white70),
            label: const Text(
              'Meet the Author →',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

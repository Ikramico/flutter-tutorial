import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/hero_section.dart';
import 'widgets/nav_chips.dart';
import 'widgets/content_section.dart';
import 'widgets/sandbox_section.dart';
import 'widgets/resources_section.dart';
import 'widgets/videos_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentSection = 0;

  static const _sections = [
    'Home',
    'Content',
    'Practice',
    'Resources',
    'Videos',
  ];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showPracticeSandbox() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Practice Sandbox'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Try editing this code snippet:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Card(
              color: Color(0xFF2C2C2C),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Container(\n'
                  '  child: Text("Hello Flutter!"),\n'
                  '  padding: EdgeInsets.all(20),\n'
                  ')',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.greenAccent,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Great! Keep practicing in VS Code 💪');
            },
            child: const Text('Try It Yourself'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        onNotification: () => _showSnackBar('No new notifications'),
        onProfileTap: () => context.push(AppRoutes.profile),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroSection(
              onStart: () =>
                  _showSnackBar('Welcome to your learning journey! 🚀'),
              onProfile: () => context.push(AppRoutes.profile),
            ),
            const SizedBox(height: 24),
            NavChips(
              sections: _sections,
              currentIndex: _currentSection,
              onTap: (i) {
                setState(() => _currentSection = i);
                _showSnackBar('Switched to ${_sections[i]}');
              },
            ),
            const SizedBox(height: 16),

            // ── Quiz & Leaderboard CTA ───────────────────────────────────
            _QuizBanner(),
            const SizedBox(height: 24),

            ContentSection(onModuleTap: _showSnackBar),
            const SizedBox(height: 32),
            SandboxSection(onOpen: _showPracticeSandbox),
            const SizedBox(height: 32),
            ResourcesSection(onTap: _showSnackBar),
            const SizedBox(height: 32),
            VideosSection(onTap: _showSnackBar),
            const SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentSection > 3 ? 0 : _currentSection,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          setState(() => _currentSection = i);
          if (i == 2) {
            _showPracticeSandbox();
          } else if (i == 3) {
            context.push(AppRoutes.profile);
          } else {
            _showSnackBar('Navigated to ${_sections[i]}');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.code), label: 'Practice'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _QuizBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Test Your Skills', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.categories),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5C35D4), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🎯', style: TextStyle(fontSize: 28)),
                        const SizedBox(height: 10),
                        const Text(
                          'Take a Quiz',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '6 topics available',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.leaderboard),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFFFB74D).withOpacity(0.4),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('🏆', style: TextStyle(fontSize: 28)),
                        SizedBox(height: 10),
                        Text(
                          'Leader-\nboard',
                          style: TextStyle(
                            color: Color(0xFFE65100),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

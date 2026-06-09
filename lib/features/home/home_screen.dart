import 'package:flutter/material.dart';
import '../profile/profile_page.dart';
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

  static const _sections = ['Home', 'Content', 'Practice', 'Resources', 'Videos'];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.deepPurple,
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
            Text('Try editing this code snippet:',
                style: TextStyle(fontWeight: FontWeight.bold)),
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

  void _openProfile() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        onNotification: () => _showSnackBar('No new notifications'),
        onProfileTap: _openProfile,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroSection(
              onStart: () => _showSnackBar('Welcome to your learning journey! 🚀'),
              onProfile: _openProfile,
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
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          setState(() => _currentSection = i);
          if (i == 2) {
            _showPracticeSandbox();
          } else if (i == 3) {
            _openProfile();
          } else {
            _showSnackBar('Navigated to ${_sections[i]}');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.code), label: 'Practice'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

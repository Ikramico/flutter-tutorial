import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onNotification;
  final VoidCallback onProfileTap;

  const HomeAppBar({
    super.key,
    required this.onNotification,
    required this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Row(
        children: [
          Icon(Icons.flutter_dash, color: Colors.white, size: 28),
          SizedBox(width: 10),
          Text(
            'Flutter Mastery',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ],
      ),
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: onNotification,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: onProfileTap,
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Text('👨‍💻', style: TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ],
    );
  }
}

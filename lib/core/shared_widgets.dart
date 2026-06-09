import 'package:flutter/material.dart';
import 'app_constants.dart';

/// Section header with an emoji prefix (used on the Home screen).
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Text(title, style: kHeadingStyle),
    );
  }
}

/// Titled card header with an icon — used inside profile cards.
class CardHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const CardHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: kPrimary, size: 22),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      ],
    );
  }
}

/// Thin divider used between stat items.
class StatDivider extends StatelessWidget {
  const StatDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: Colors.grey.shade200);
  }
}

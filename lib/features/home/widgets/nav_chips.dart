import 'package:flutter/material.dart';

class NavChips extends StatelessWidget {
  final List<String> sections;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NavChips({
    super.key,
    required this.sections,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: sections.length,
          itemBuilder: (_, i) {
            final selected = currentIndex == i;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () => onTap(i),
                child: Chip(
                  label: Text(sections[i]),
                  backgroundColor:
                      selected ? Colors.deepPurple : Colors.white,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontWeight:
                        selected ? FontWeight.bold : FontWeight.normal,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

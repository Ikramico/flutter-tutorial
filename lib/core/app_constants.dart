import 'package:flutter/material.dart';

// ── Colors ──────────────────────────────────────
const Color kPrimary      = Color(0xFF6B46C1);
const Color kPrimaryLight = Color(0xFF9F7AEA);
const Color kScaffoldBg   = Color(0xFFF8F9FC);

// ── Text Styles ──────────────────────────────────
const TextStyle kHeadingStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

const TextStyle kSubtitleStyle = TextStyle(
  color: Colors.grey,
  fontSize: 14,
);

// ── Decoration helpers ────────────────────────────
BoxDecoration gradientDecoration = const BoxDecoration(
  gradient: LinearGradient(
    colors: [kPrimary, kPrimaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
);

ShapeBorder kCardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(16),
);

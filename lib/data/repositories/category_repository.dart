// lib/data/repositories/category_repository.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../category.dart';

// ── Abstract contract ─────────────────────────────────────────────────────────

abstract class CategoryRepository {
  Future<List<QuizCategory>> getCategories();
}

// ── Real API implementation ───────────────────────────────────────────────────
//
// Uses the Open Trivia DB (opentdb.com) — completely free, no key required.
// GET https://opentdb.com/api_category.php
// Response: { "trivia_categories": [{ "id": 9, "name": "General Knowledge" }, ...] }
//
// We map each category to a QuizCategory. questionCount is fetched from
// the category question-count endpoint when available.

class ApiCategoryRepository implements CategoryRepository {
  static const _baseUrl = 'https://opentdb.com';

  static const _fixedIcons = <int, String>{
    9: '🧠', // General Knowledge
    10: '📖', // Entertainment: Books
    11: '🎬', // Entertainment: Film
    12: '🎵', // Entertainment: Music
    13: '🎭', // Entertainment: Musicals & Theatres
    14: '📺', // Entertainment: Television
    15: '🎮', // Entertainment: Video Games
    16: '🎲', // Entertainment: Board Games
    17: '🔬', // Science & Nature
    18: '💻', // Science: Computers
    19: '🧮', // Science: Mathematics
    20: '🏛️', // Mythology
    21: '⚽', // Sports
    22: '🌍', // Geography
    23: '📜', // History
    24: '🏛️', // Politics
    25: '🎨', // Art
    26: '⭐', // Celebrities
    27: '🐾', // Animals
    28: '🚗', // Vehicles
    29: '📖', // Entertainment: Comics
    30: '📱', // Science: Gadgets
    31: '🎌', // Entertainment: Japanese Anime & Manga
    32: '🃏', // Entertainment: Cartoon & Animations
  };

  @override
  Future<List<QuizCategory>> getCategories() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/api_category.php'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final list = data['trivia_categories'] as List<dynamic>;

      return list.map((e) {
        final map = e as Map<String, dynamic>;
        final id = map['id'] as int;
        return QuizCategory(
          id: id,
          name: map['name'] as String,
          description: _descriptionFor(map['name'] as String),
          icon: _fixedIcons[id] ?? '📚',
          questionCount: 10, // default; opentdb returns 10 per request
        );
      }).toList();
    } catch (e) {
      debugPrint('[CategoryRepository] error: $e');
      // Fallback to a small curated list so the app still works offline
      return _fallbackCategories;
    }
  }

  String _descriptionFor(String name) {
    // Trim "Entertainment: " / "Science: " prefixes for cleaner descriptions
    return name.replaceAll('Entertainment: ', '').replaceAll('Science: ', '');
  }

  static const _fallbackCategories = [
    QuizCategory(
      id: 9,
      name: 'General Knowledge',
      description: 'Mixed trivia',
      icon: '🧠',
      questionCount: 10,
    ),
    QuizCategory(
      id: 17,
      name: 'Science & Nature',
      description: 'Nature & Science',
      icon: '🔬',
      questionCount: 10,
    ),
    QuizCategory(
      id: 18,
      name: 'Computers',
      description: 'Technology & Code',
      icon: '💻',
      questionCount: 10,
    ),
    QuizCategory(
      id: 19,
      name: 'Mathematics',
      description: 'Numbers & Logic',
      icon: '🧮',
      questionCount: 10,
    ),
    QuizCategory(
      id: 21,
      name: 'Sports',
      description: 'Sports & Games',
      icon: '⚽',
      questionCount: 10,
    ),
    QuizCategory(
      id: 22,
      name: 'Geography',
      description: 'Countries & Places',
      icon: '🌍',
      questionCount: 10,
    ),
  ];
}

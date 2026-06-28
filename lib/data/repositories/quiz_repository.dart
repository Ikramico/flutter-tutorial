// lib/data/repositories/quiz_repository.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../question.dart';

// ── Abstract contract ─────────────────────────────────────────────────────────

abstract class QuizRepository {
  /// Returns 10 questions for the given [categoryId].
  Future<List<Question>> getQuestions(int categoryId);
}

// ── Real API implementation ───────────────────────────────────────────────────
//
// Open Trivia DB — https://opentdb.com
// GET https://opentdb.com/api.php?amount=10&category=9&type=multiple
//
// Response shape:
// {
//   "response_code": 0,
//   "results": [{
//     "category": "...",
//     "type": "multiple",
//     "difficulty": "easy",
//     "question": "Which ...",
//     "correct_answer": "Paris",
//     "incorrect_answers": ["London","Berlin","Madrid"]
//   }]
// }
//
// We decode HTML entities (opentdb encodes & as &amp; etc.) and shuffle
// the options, keeping track of the correct index.

class ApiQuizRepository implements QuizRepository {
  static const _baseUrl = 'https://opentdb.com/api.php';

  @override
  Future<List<Question>> getQuestions(int categoryId) async {
    final uri = Uri.parse(
      '$_baseUrl?amount=10&category=$categoryId&type=multiple&encode=url3986',
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 12));

      if (response.statusCode != 200) {
        throw Exception('API error ${response.statusCode}');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final code = data['response_code'] as int;

      // response_code meanings: 0=OK, 1=no results, 2=invalid param, 5=rate limit
      if (code == 5) throw Exception('Rate limited — please wait a moment.');
      if (code != 0)
        throw Exception('No questions available for this category.');

      final results = data['results'] as List<dynamic>;

      return results.asMap().entries.map((entry) {
        final i = entry.key;
        final raw = entry.value as Map<String, dynamic>;

        final correct = _decode(raw['correct_answer'] as String);
        final incorrects = (raw['incorrect_answers'] as List<dynamic>)
            .map((e) => _decode(e as String))
            .toList();

        // Deterministically shuffle so correct answer isn't always first.
        // We insert correct at a position based on question index so it
        // differs per question without needing dart:math Random (reproducible).
        final options = [...incorrects];
        final correctIdx = i % 4; // 0,1,2,3 pattern
        options.insert(correctIdx, correct);

        return Question(
          id: i,
          question: _decode(raw['question'] as String),
          options: options,
          answerIndex: correctIdx,
          mark: _markForDifficulty(raw['difficulty'] as String? ?? 'medium'),
          explanation: null,
        );
      }).toList();
    } catch (e) {
      debugPrint('[QuizRepository] error: $e');
      rethrow;
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  /// Decode URL-encoded (RFC 3986) strings from opentdb.
  String _decode(String encoded) {
    return Uri.decodeComponent(encoded);
  }

  int _markForDifficulty(String difficulty) {
    switch (difficulty) {
      case 'hard':
        return 15;
      case 'medium':
        return 10;
      default:
        return 5; // easy
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../question.dart';

abstract class QuizRepository {
  Future<List<Question>> getQuestions(int categoryId);
}

class ApiQuizRepository implements QuizRepository {
  static const String _baseUrl =
      'https://sadiks-quiz-apihub.lovable.app/api/v1';

  /// Fetches up to [count] random questions for [categoryId].
  /// Falls back to the paginated endpoint if the random endpoint returns empty.
  @override
  Future<List<Question>> getQuestions(int categoryId, {int count = 10}) async {
    // Prefer the /random endpoint so each quiz session is varied
    final randomUri = Uri.parse(
      '$_baseUrl/categories/$categoryId/questions/random?count=$count',
    );
    final randomRes = await http.get(randomUri);

    if (randomRes.statusCode == 200) {
      final body = jsonDecode(randomRes.body) as Map<String, dynamic>;
      if (body['success'] == true) {
        final data = body['data'] as List<dynamic>;
        if (data.isNotEmpty) {
          return _parseQuestions(data);
        }
      }
    }

    // Fallback: regular paginated endpoint
    final fallbackUri = Uri.parse(
      '$_baseUrl/categories/$categoryId/questions?limit=$count',
    );
    final fallbackRes = await http.get(fallbackUri);

    if (fallbackRes.statusCode != 200) {
      throw Exception('Failed to load questions (${fallbackRes.statusCode})');
    }

    final body = jsonDecode(fallbackRes.body) as Map<String, dynamic>;
    if (body['success'] != true) {
      throw Exception(body['message'] ?? 'Unknown error');
    }

    final data = body['data'] as List<dynamic>;
    if (data.isEmpty) {
      throw Exception('No questions found for this category.');
    }

    return _parseQuestions(data);
  }

  List<Question> _parseQuestions(List<dynamic> data) {
    return data.map((json) {
      final map = json as Map<String, dynamic>;
      return Question(
        id: map['id'] as int,
        question: map['question'] as String,
        options: List<String>.from(map['options'] as List),
        answerIndex: map['answerIndex'] as int,
        mark: map['mark'] as int? ?? 10,
      );
    }).toList();
  }
}

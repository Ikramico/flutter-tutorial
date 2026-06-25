import 'dart:convert';
import 'package:http/http.dart' as http;
import '../category.dart';

abstract class CategoryRepository {
  Future<List<QuizCategory>> getCategories();
}

class ApiCategoryRepository implements CategoryRepository {
  static const String _baseUrl =
      'https://sadiks-quiz-apihub.lovable.app/api/v1';

  // Emoji icons assigned by index since the API doesn't provide them
  static const List<String> _icons = [
    '💡',
    '📚',
    '🔬',
    '🌍',
    '🎯',
    '🏆',
    '🧠',
    '🎨',
    '💻',
    '🚀',
    '🔥',
    '⚡',
    '🌟',
    '🎵',
    '🏅',
    '🧩',
  ];

  @override
  Future<List<QuizCategory>> getCategories() async {
    final uri = Uri.parse('$_baseUrl/categories?limit=100');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load categories (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (body['success'] != true) {
      throw Exception(body['message'] ?? 'Unknown error');
    }

    final data = body['data'] as List<dynamic>;

    return data.asMap().entries.map((entry) {
      final i = entry.key;
      final json = entry.value as Map<String, dynamic>;
      return QuizCategory(
        id: json['id'] as int,
        name: json['name'] as String,
        description: (json['description'] as String?) ?? '',
        icon: _icons[i % _icons.length],
        questionCount: 0, // not returned by list endpoint; updated after fetch
      );
    }).toList();
  }
}

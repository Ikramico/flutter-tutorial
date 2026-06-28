// lib/data/models/category.dart

import 'package:equatable/equatable.dart';

class QuizCategory extends Equatable {
  final int id;
  final String name;
  final String description;
  final String icon;
  final int questionCount;

  const QuizCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.questionCount,
  });

  factory QuizCategory.fromJson(Map<String, dynamic> json) {
    return QuizCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '📚',
      questionCount:
          json['questionCount'] as int? ?? json['question_count'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, description, icon, questionCount];
}

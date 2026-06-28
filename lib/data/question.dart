// lib/data/models/question.dart

import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final int id;
  final String question;
  final List<String> options;
  final int answerIndex;
  final int mark;
  final String? explanation;

  const Question({
    required this.id,
    required this.question,
    required this.options,
    required this.answerIndex,
    this.mark = 10,
    this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    // Supports both 'options' list and individual 'option_a/b/c/d' fields
    List<String> opts;
    if (json['options'] is List) {
      opts = List<String>.from(json['options'] as List);
    } else {
      opts = [
        json['option_a'] as String? ?? '',
        json['option_b'] as String? ?? '',
        json['option_c'] as String? ?? '',
        json['option_d'] as String? ?? '',
      ];
    }

    // answerIndex can come as int or as a letter ('A','B','C','D')
    int idx;
    final raw = json['answerIndex'] ?? json['answer_index'] ?? json['correct'];
    if (raw is int) {
      idx = raw;
    } else if (raw is String && raw.length == 1) {
      idx = raw.toUpperCase().codeUnitAt(0) - 'A'.codeUnitAt(0);
    } else {
      idx = 0;
    }

    return Question(
      id: json['id'] as int? ?? 0,
      question: json['question'] as String,
      options: opts,
      answerIndex: idx,
      mark: json['mark'] as int? ?? json['marks'] as int? ?? 10,
      explanation: json['explanation'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, question, options, answerIndex, mark];
}

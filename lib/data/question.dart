import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final int id;
  final String question;
  final List<String> options;
  final int answerIndex;
  final int mark;

  const Question({
    required this.id,
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.mark,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      answerIndex: json['answerIndex'] as int,
      mark: json['mark'] as int? ?? 10,
    );
  }

  @override
  List<Object?> get props => [id, question, options, answerIndex, mark];
}

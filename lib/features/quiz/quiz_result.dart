import 'package:equatable/equatable.dart';
import '../../data/question.dart';


class AnsweredQuestion extends Equatable {
  final Question question;
  final int? selectedIndex; // null = unanswered (timed out)

  const AnsweredQuestion({required this.question, required this.selectedIndex});

  bool get isCorrect => selectedIndex == question.answerIndex;
  bool get isSkipped => selectedIndex == null;
  int get earnedMark => isCorrect ? question.mark : 0;

  @override
  List<Object?> get props => [question, selectedIndex];
}

class QuizResult extends Equatable {
  final int categoryId;
  final String categoryName;
  final List<AnsweredQuestion> answers;
  final int totalTimeSeconds;

  const QuizResult({
    required this.categoryId,
    required this.categoryName,
    required this.answers,
    required this.totalTimeSeconds,
  });

  int get totalScore => answers.fold(0, (sum, a) => sum + a.earnedMark);
  int get maxScore => answers.fold(0, (sum, a) => sum + a.question.mark);
  int get correctCount => answers.where((a) => a.isCorrect).length;
  int get wrongCount =>
      answers.where((a) => !a.isCorrect && !a.isSkipped).length;
  int get skippedCount => answers.where((a) => a.isSkipped).length;
  double get percentage => maxScore == 0 ? 0 : (totalScore / maxScore) * 100;

  String get grade {
    if (percentage >= 90) return 'S';
    if (percentage >= 75) return 'A';
    if (percentage >= 60) return 'B';
    if (percentage >= 45) return 'C';
    return 'F';
  }

  String get gradeLabel {
    if (percentage >= 90) return 'Outstanding';
    if (percentage >= 75) return 'Excellent';
    if (percentage >= 60) return 'Good Job';
    if (percentage >= 45) return 'Keep Going';
    return 'Try Again';
  }

  @override
  List<Object?> get props => [categoryId, answers, totalTimeSeconds];
}

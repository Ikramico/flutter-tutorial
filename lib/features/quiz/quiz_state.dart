part of 'quiz_bloc.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {
  const QuizInitial();
}

class QuizLoading extends QuizState {
  const QuizLoading();
}

class QuizInProgress extends QuizState {
  final List<Question> questions;
  final int currentIndex;
  final int? selectedAnswerIndex; // null = not yet answered
  final bool isAnswered;
  final int timerSeconds;
  final List<AnsweredQuestion> answeredSoFar;

  const QuizInProgress({
    required this.questions,
    required this.currentIndex,
    required this.selectedAnswerIndex,
    required this.isAnswered,
    required this.timerSeconds,
    required this.answeredSoFar,
  });

  Question get currentQuestion => questions[currentIndex];
  int get totalQuestions => questions.length;
  bool get isLast => currentIndex == questions.length - 1;

  @override
  List<Object?> get props => [
    questions,
    currentIndex,
    selectedAnswerIndex,
    isAnswered,
    timerSeconds,
    answeredSoFar,
  ];
}

class QuizCompleted extends QuizState {
  final QuizResult result;

  const QuizCompleted(this.result);

  @override
  List<Object?> get props => [result];
}

class QuizError extends QuizState {
  final String message;

  const QuizError(this.message);

  @override
  List<Object?> get props => [message];
}

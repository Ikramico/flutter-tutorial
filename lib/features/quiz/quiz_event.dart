// lib/features/quiz/quiz_event.dart

part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();
  @override
  List<Object?> get props => [];
}

class QuizStartRequested extends QuizEvent {
  final int categoryId;
  final String categoryName;
  const QuizStartRequested(this.categoryId, this.categoryName);
  @override
  List<Object?> get props => [categoryId, categoryName];
}

class QuizAnswerSelected extends QuizEvent {
  final int answerIndex;
  const QuizAnswerSelected(this.answerIndex);
  @override
  List<Object?> get props => [answerIndex];
}

class QuizNextQuestion extends QuizEvent {
  const QuizNextQuestion();
}

class QuizTimerTick extends QuizEvent {
  final int remaining;
  const QuizTimerTick(this.remaining);
  @override
  List<Object?> get props => [remaining];
}

class QuizTimedOut extends QuizEvent {
  const QuizTimedOut();
}

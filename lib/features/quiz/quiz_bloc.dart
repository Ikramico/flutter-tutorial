// lib/features/quiz/quiz_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/question.dart';
import '../../data/repositories/quiz_repository.dart';
import 'quiz_result.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _repository;

  static const int _questionTimeSeconds = 30;

  List<Question> _questions = [];
  int _currentIndex = 0;
  String _categoryName = '';
  int _categoryId = 0;
  final List<AnsweredQuestion> _answers = [];
  Timer? _timer;
  int _timerRemaining = _questionTimeSeconds;
  int _totalElapsed = 0;

  QuizBloc(this._repository) : super(const QuizInitial()) {
    on<QuizStartRequested>(_onStart);
    on<QuizAnswerSelected>(_onAnswerSelected);
    on<QuizNextQuestion>(_onNext);
    on<QuizTimerTick>(_onTick);
    on<QuizTimedOut>(_onTimedOut);
  }

  Future<void> _onStart(
    QuizStartRequested event,
    Emitter<QuizState> emit,
  ) async {
    emit(const QuizLoading());
    _answers.clear();
    _currentIndex = 0;
    _totalElapsed = 0;
    _categoryId = event.categoryId;
    _categoryName = event.categoryName;
    try {
      _questions = await _repository.getQuestions(event.categoryId);
      if (_questions.isEmpty) {
        emit(const QuizError('No questions available for this category.'));
        return;
      }
      emit(_buildInProgress(selectedAnswer: null, isAnswered: false));
      _startTimer();
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  void _onAnswerSelected(QuizAnswerSelected event, Emitter<QuizState> emit) {
    if (state is! QuizInProgress) return;
    final s = state as QuizInProgress;
    if (s.isAnswered) return;

    _timer?.cancel(); // stop the countdown when user answers

    emit(
      QuizInProgress(
        questions: _questions,
        currentIndex: _currentIndex,
        selectedAnswerIndex: event.answerIndex,
        isAnswered: true,
        timerSeconds: _timerRemaining,
        answeredSoFar: s.answeredSoFar,
      ),
    );
  }

  void _onNext(QuizNextQuestion event, Emitter<QuizState> emit) {
    if (state is! QuizInProgress) return;
    final s = state as QuizInProgress;

    _answers.add(
      AnsweredQuestion(
        question: _questions[_currentIndex],
        selectedIndex: s.selectedAnswerIndex,
      ),
    );
    _totalElapsed += _questionTimeSeconds - _timerRemaining;

    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _timerRemaining = _questionTimeSeconds;
      emit(_buildInProgress(selectedAnswer: null, isAnswered: false));
      _startTimer();
    } else {
      _timer?.cancel();
      emit(
        QuizCompleted(
          QuizResult(
            categoryId: _categoryId,
            categoryName: _categoryName,
            answers: List.unmodifiable(_answers),
            totalTimeSeconds: _totalElapsed,
          ),
        ),
      );
    }
  }

  void _onTick(QuizTimerTick event, Emitter<QuizState> emit) {
    _timerRemaining = event.remaining;
    if (state is QuizInProgress) {
      final s = state as QuizInProgress;
      if (!s.isAnswered) {
        emit(
          QuizInProgress(
            questions: _questions,
            currentIndex: _currentIndex,
            selectedAnswerIndex: null,
            isAnswered: false,
            timerSeconds: event.remaining,
            answeredSoFar: s.answeredSoFar,
          ),
        );
      }
    }
  }

  void _onTimedOut(QuizTimedOut event, Emitter<QuizState> emit) {
    // Auto-advance with null answer (skipped)
    add(const QuizNextQuestion());
  }

  void _startTimer() {
    _timer?.cancel();
    _timerRemaining = _questionTimeSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      _timerRemaining--;
      add(QuizTimerTick(_timerRemaining));
      if (_timerRemaining <= 0) {
        t.cancel();
        add(const QuizTimedOut());
      }
    });
  }

  QuizInProgress _buildInProgress({
    required int? selectedAnswer,
    required bool isAnswered,
  }) {
    return QuizInProgress(
      questions: _questions,
      currentIndex: _currentIndex,
      selectedAnswerIndex: selectedAnswer,
      isAnswered: isAnswered,
      timerSeconds: _timerRemaining,
      answeredSoFar: List.unmodifiable(_answers),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

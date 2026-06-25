import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../quiz_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../data/category.dart';

class QuizPage extends StatefulWidget {
  final QuizCategory category;

  const QuizPage({super.key, required this.category});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(
      QuizStartRequested(widget.category.id, widget.category.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state is QuizCompleted) {
          context.pushReplacement(
            AppRoutes.result,
            extra: {'result': state.result},
          );
        }
      },
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(gradient: AppColors.gradientQuiz),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(child: _buildBody(context, state)),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, QuizState state) {
    if (state is QuizLoading || state is QuizInitial) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (state is QuizError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go back'),
            ),
          ],
        ),
      );
    }
    if (state is QuizInProgress) {
      return _QuizInProgressView(state: state, category: widget.category);
    }
    return const SizedBox();
  }
}

class _QuizInProgressView extends StatelessWidget {
  final QuizInProgress state;
  final QuizCategory category;

  const _QuizInProgressView({required this.state, required this.category});

  @override
  Widget build(BuildContext context) {
    final q = state.currentQuestion;
    final progress = (state.currentIndex + 1) / state.totalQuestions;
    final timerFraction = state.timerSeconds / 30;
    final isTimerWarning = state.timerSeconds <= 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Top bar ───────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _showExitDialog(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withOpacity(0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.accent,
                    ),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${state.currentIndex + 1}/${state.totalQuestions}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // ── Timer ─────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              Text(category.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              _TimerChip(
                seconds: state.timerSeconds,
                fraction: timerFraction,
                isWarning: isTimerWarning,
              ),
            ],
          ),
        ),

        // ── Question ──────────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${state.currentIndex + 1}',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  q.question,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                ...List.generate(
                  q.options.length,
                  (i) => _OptionTile(
                    index: i,
                    text: q.options[i],
                    state: state,
                    onTap: state.isAnswered
                        ? null
                        : () => context.read<QuizBloc>().add(
                            QuizAnswerSelected(i),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Next button ───────────────────────────────────────────────────
        if (state.isAnswered)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    context.read<QuizBloc>().add(const QuizNextQuestion()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  state.isLast ? 'See Results' : 'Next Question',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leave Quiz?'),
        content: const Text(
          'Your progress will be lost. Are you sure you want to exit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Exit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _TimerChip extends StatelessWidget {
  final int seconds;
  final double fraction;
  final bool isWarning;

  const _TimerChip({
    required this.seconds,
    required this.fraction,
    required this.isWarning,
  });

  @override
  Widget build(BuildContext context) {
    final color = isWarning ? AppColors.accent : Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (isWarning ? AppColors.accent : Colors.white).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            '${seconds}s',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final QuizInProgress state;
  final VoidCallback? onTap;

  const _OptionTile({
    required this.index,
    required this.text,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = state.selectedAnswerIndex == index;
    final isCorrect = index == state.currentQuestion.answerIndex;
    final isAnswered = state.isAnswered;

    Color borderColor;
    Color bgColor;
    Color textColor;
    Widget? trailingIcon;

    if (!isAnswered) {
      borderColor = Colors.white.withOpacity(0.12);
      bgColor = Colors.white.withOpacity(0.06);
      textColor = Colors.white;
    } else if (isCorrect) {
      borderColor = AppColors.success;
      bgColor = AppColors.success.withOpacity(0.15);
      textColor = AppColors.success;
      trailingIcon = const Icon(
        Icons.check_circle_rounded,
        color: AppColors.success,
        size: 20,
      );
    } else if (isSelected) {
      borderColor = AppColors.error;
      bgColor = AppColors.error.withOpacity(0.15);
      textColor = AppColors.error;
      trailingIcon = const Icon(
        Icons.cancel_rounded,
        color: AppColors.error,
        size: 20,
      );
    } else {
      borderColor = Colors.white.withOpacity(0.06);
      bgColor = Colors.transparent;
      textColor = Colors.white38;
    }

    final labels = ['A', 'B', 'C', 'D'];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor.withOpacity(0.5)),
              ),
              child: Center(
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              trailingIcon,
            ],
          ],
        ),
      ),
    );
  }
}

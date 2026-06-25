import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../features/auth/auth_bloc.dart';
import '../../../features/leaderboard/leaderboard_bloc.dart';
import '../../quiz/quiz_result.dart';

class ResultPage extends StatefulWidget {
  final QuizResult result;

  const ResultPage({super.key, required this.result});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();

    // Submit score to leaderboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated && !_submitted) {
        _submitted = true;
        context.read<LeaderboardBloc>().add(
              LeaderboardScoreSubmitted(authState.user, widget.result),
            );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final isPassing = r.percentage >= 45;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isPassing
              ? AppColors.gradientPrimary
              : const LinearGradient(
                  colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: ScaleTransition(
                          scale: _scaleAnim,
                          child: _GradeBadge(result: r),
                        ),
                      ),
                      const SizedBox(height: 28),
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: Column(
                          children: [
                            Text(
                              r.gradeLabel,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              r.categoryName,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _ScoreCard(result: r),
                      const SizedBox(height: 20),
                      _BreakdownRow(result: r),
                      const SizedBox(height: 28),
                      _AnswerReview(result: r),
                    ],
                  ),
                ),
              ),
              _BottomActions(result: r),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradeBadge extends StatelessWidget {
  final QuizResult result;

  const _GradeBadge({required this.result});

  @override
  Widget build(BuildContext context) {
    final gradeEmoji = {
      'S': '🏆',
      'A': '⭐',
      'B': '👍',
      'C': '💪',
      'F': '📚',
    }[result.grade] ?? '📚';

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(gradeEmoji, style: const TextStyle(fontSize: 36)),
          Text(
            result.grade,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final QuizResult result;

  const _ScoreCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                '${result.totalScore}',
                style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              Text(
                'out of ${result.maxScore}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(width: 32),
          Container(width: 1, height: 60, color: Colors.white24),
          const SizedBox(width: 32),
          Column(
            children: [
              Text(
                '${result.percentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              Text(
                'accuracy',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final QuizResult result;

  const _BreakdownRow({required this.result});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatPill(
          label: 'Correct',
          value: '${result.correctCount}',
          color: AppColors.success,
          icon: Icons.check_rounded,
        ),
        const SizedBox(width: 10),
        _StatPill(
          label: 'Wrong',
          value: '${result.wrongCount}',
          color: AppColors.accent,
          icon: Icons.close_rounded,
        ),
        const SizedBox(width: 10),
        _StatPill(
          label: 'Skipped',
          value: '${result.skippedCount}',
          color: Colors.white54,
          icon: Icons.remove_rounded,
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: TextStyle(color: color.withOpacity(0.7), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerReview extends StatelessWidget {
  final QuizResult result;

  const _AnswerReview({required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review Answers',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...result.answers.asMap().entries.map(
              (e) => _ReviewItem(index: e.key, answered: e.value),
            ),
      ],
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final int index;
  final AnsweredQuestion answered;

  const _ReviewItem({required this.index, required this.answered});

  @override
  Widget build(BuildContext context) {
    final color = answered.isSkipped
        ? Colors.white54
        : answered.isCorrect
            ? AppColors.success
            : AppColors.accent;

    final icon = answered.isSkipped
        ? Icons.remove_circle_outline_rounded
        : answered.isCorrect
            ? Icons.check_circle_rounded
            : Icons.cancel_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Q${index + 1}. ${answered.question.question}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Correct: ${answered.question.options[answered.question.answerIndex]}',
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final QuizResult result;

  const _BottomActions({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.go(AppRoutes.leaderboard),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white38),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Leaderboard'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.go(AppRoutes.categories),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Play Again',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
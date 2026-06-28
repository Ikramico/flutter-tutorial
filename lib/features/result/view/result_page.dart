// lib/features/result/view/result_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/injection.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/leaderboard_repository.dart';
import '../../../features/auth/auth_bloc.dart';
import '../../quiz/quiz_result.dart';

class ResultPage extends StatefulWidget {
  final QuizResult result;
  const ResultPage({super.key, required this.result});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _submitting = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _submitToLeaderboard();
  }

  Future<void> _submitToLeaderboard() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    setState(() => _submitting = true);
    try {
      final repo = sl<LeaderboardRepository>();
      await repo.submitEntry(
        LeaderboardEntry(
          userId: authState.user.id,
          userName: authState.user.displayName,
          categoryName: widget.result.categoryName,
          score: widget.result.totalScore,
          maxScore: widget.result.maxScore,
          percentage: widget.result.percentage,
          grade: widget.result.grade,
          completedAt: DateTime.now(),
        ),
      );
      if (mounted) setState(() => _submitted = true);
    } catch (_) {
      // Non-fatal — leaderboard submit failure doesn't break results
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final gradeColor = AppColors.forGrade(r.grade);

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradientResult),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Top bar ────────────────────────────────────────────────
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.home),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.home_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      r.categoryName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 36),
                  ],
                ),
                const SizedBox(height: 32),

                // ── Grade badge ────────────────────────────────────────────
                _GradeBadge(grade: r.grade, gradeColor: gradeColor),
                const SizedBox(height: 16),

                Text(
                  r.gradeLabel,
                  style: TextStyle(
                    color: gradeColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  r.gradeDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // ── Score card ─────────────────────────────────────────────
                _ScoreCard(result: r),
                const SizedBox(height: 20),

                // ── Stats row ──────────────────────────────────────────────
                _StatsRow(result: r),
                const SizedBox(height: 20),

                // ── Grade scale reference ──────────────────────────────────
                _GradeScale(currentGrade: r.grade),
                const SizedBox(height: 32),

                // ── Leaderboard submit indicator ───────────────────────────
                if (_submitting)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            color: Colors.white54,
                            strokeWidth: 2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Saving to leaderboard…',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_submitted)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.success,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Score saved to leaderboard!',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                // ── Action buttons ─────────────────────────────────────────
                ElevatedButton.icon(
                  onPressed: () => context.go(AppRoutes.categories),
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Play Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.leaderboard),
                  icon: const Icon(
                    Icons.leaderboard_rounded,
                    color: Colors.white70,
                  ),
                  label: const Text(
                    'View Leaderboard',
                    style: TextStyle(color: Colors.white70),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    side: BorderSide(color: Colors.white.withOpacity(0.25)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _GradeBadge extends StatelessWidget {
  final String grade;
  final Color gradeColor;
  const _GradeBadge({required this.grade, required this.gradeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: gradeColor.withOpacity(0.15),
        border: Border.all(color: gradeColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: gradeColor.withOpacity(0.3),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Text(
          grade,
          style: TextStyle(
            color: gradeColor,
            fontSize: 44,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final QuizResult result;
  const _ScoreCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final pct = result.percentage.toStringAsFixed(1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          Text(
            '${result.totalScore} / ${result.maxScore}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$pct% correct',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: result.percentage / 100,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.forGrade(result.grade),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final QuizResult result;
  const _StatsRow({required this.result});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('✅', '${result.correctCount}', 'Correct'),
      ('❌', '${result.wrongCount}', 'Wrong'),
      ('⏭️', '${result.skippedCount}', 'Skipped'),
      ('⏱️', '${result.totalTimeSeconds}s', 'Time'),
    ];

    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    Text(item.$1, style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 6),
                    Text(
                      item.$2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      item.$3,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _GradeScale extends StatelessWidget {
  final String currentGrade;
  const _GradeScale({required this.currentGrade});

  @override
  Widget build(BuildContext context) {
    const bands = [
      ('S', '≥ 90%', AppColors.gradeS),
      ('A', '≥ 75%', AppColors.gradeA),
      ('B', '≥ 60%', AppColors.gradeB),
      ('C', '≥ 45%', AppColors.gradeC),
      ('F', '< 45%', AppColors.gradeF),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grade Scale',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: bands.map((b) {
              final isActive = b.$1 == currentGrade;
              return Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isActive ? 44 : 36,
                    height: isActive ? 44 : 36,
                    decoration: BoxDecoration(
                      color: b.$3.withOpacity(isActive ? 0.25 : 0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: b.$3.withOpacity(isActive ? 1 : 0.3),
                        width: isActive ? 2.5 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        b.$1,
                        style: TextStyle(
                          color: b.$3,
                          fontSize: isActive ? 18 : 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    b.$2,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 10,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

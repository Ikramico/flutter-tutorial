// lib/features/leaderboard/view/leaderboard_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/injection.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/leaderboard_repository.dart';
import '../leaderboard_bloc.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Fix: LeaderboardBloc was never provided — now created locally here.
    return BlocProvider(
      create: (_) =>
          sl<LeaderboardBloc>()..add(const LeaderboardLoadRequested()),
      child: const _LeaderboardView(),
    );
  }
}

class _LeaderboardView extends StatefulWidget {
  const _LeaderboardView();

  @override
  State<_LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<_LeaderboardView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> _tabs = ['All'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  void _rebuildTabs(List<String> tabs) {
    _tabController?.dispose();
    _tabs = tabs;
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) return;
      final filter = _tabController!.index == 0
          ? null
          : _tabs[_tabController!.index];
      context.read<LeaderboardBloc>().add(LeaderboardFilterChanged(filter));
    });
    setState(() {});
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Fix: use Theme colors instead of hardcoded Colors.white/Colors.white54
    final theme = Theme.of(context);

    return BlocConsumer<LeaderboardBloc, LeaderboardState>(
      listener: (context, state) {
        if (state is LeaderboardLoaded) {
          final categoryNames =
              state.entries.map((e) => e.categoryName).toSet().toList()..sort();
          final newTabs = ['All', ...categoryNames];
          if (newTabs.join() != _tabs.join()) {
            _rebuildTabs(newTabs);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Leaderboard'),
            leading: BackButton(onPressed: () => context.pop()),
            bottom: _tabController != null && _tabs.length > 1
                ? TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    // ✅ Fix: use theme colors, not hardcoded
                    indicatorColor: theme.appBarTheme.foregroundColor,
                    indicatorWeight: 3,
                    labelColor: theme.appBarTheme.foregroundColor,
                    unselectedLabelColor: theme.appBarTheme.foregroundColor
                        ?.withOpacity(0.5),
                    labelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    tabAlignment: TabAlignment.start,
                    tabs: _tabs.map((t) => Tab(text: t)).toList(),
                  )
                : null,
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(LeaderboardState state) {
    if (state is LeaderboardLoading || state is LeaderboardInitial) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (state is LeaderboardError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('😕', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(state.message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<LeaderboardBloc>().add(
                  const LeaderboardLoadRequested(),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (state is LeaderboardLoaded) {
      if (state.entries.isEmpty) return const _EmptyLeaderboard();
      return _LeaderboardList(entries: state.entries);
    }
    return const SizedBox();
  }
}

// ── List ──────────────────────────────────────────────────────────────────────

class _LeaderboardList extends StatelessWidget {
  final List<LeaderboardEntry> entries;
  const _LeaderboardList({required this.entries});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (entries.length >= 3)
          SliverToBoxAdapter(child: _Podium(top3: entries.take(3).toList())),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final hasTop3 = entries.length >= 3;
                final rank = i + (hasTop3 ? 4 : 1);
                final entry = entries[hasTop3 ? i + 3 : i];
                return _LeaderboardTile(rank: rank, entry: entry);
              },
              childCount: entries.length >= 3
                  ? entries.length - 3
                  : entries.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Podium ────────────────────────────────────────────────────────────────────

class _Podium extends StatelessWidget {
  final List<LeaderboardEntry> top3;
  const _Podium({required this.top3});

  @override
  Widget build(BuildContext context) {
    final order = top3.length == 1
        ? [top3[0]]
        : top3.length == 2
        ? [top3[1], top3[0]]
        : [top3[1], top3[0], top3[2]];

    final heights = [80.0, 110.0, 60.0];
    final ranks = [2, 1, 3];
    final medals = ['🥈', '🥇', '🥉'];
    const colors = [Color(0xFFC0C0C0), Color(0xFFFFD700), Color(0xFFCD7F32)];

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradientPrimary),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(order.length, (i) {
          final e = order[i];
          return Expanded(
            child: Column(
              children: [
                Text(medals[i], style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 6),
                _AvatarInitial(name: e.userName, color: colors[i]),
                const SizedBox(height: 6),
                Text(
                  e.userName.split(' ').first,
                  // ✅ Fix: use white from const, not Colors.white (same but explicit)
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${e.score} pts',
                  style: TextStyle(
                    color: colors[i],
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // ── Grade badge ──────────────────────────────────────────
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.forGrade(e.grade).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.forGrade(e.grade).withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    'Grade ${e.grade}',
                    style: TextStyle(
                      color: AppColors.forGrade(e.grade),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: heights[i],
                  decoration: BoxDecoration(
                    color: colors[i].withOpacity(0.25),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    border: Border.all(
                      color: colors[i].withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '#${ranks[i]}',
                      style: TextStyle(
                        color: colors[i],
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _AvatarInitial extends StatelessWidget {
  final String name;
  final Color color;
  const _AvatarInitial({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

// ── List tile ─────────────────────────────────────────────────────────────────

class _LeaderboardTile extends StatelessWidget {
  final int rank;
  final LeaderboardEntry entry;
  const _LeaderboardTile({required this.rank, required this.entry});

  @override
  Widget build(BuildContext context) {
    final gradeColor = AppColors.forGrade(entry.grade);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '#$rank',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              entry.userName.isNotEmpty ? entry.userName[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.userName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(entry.categoryName, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.score} pts',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${entry.percentage.toStringAsFixed(0)}%  ',
                    style: AppTextStyles.bodySmall,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: gradeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      entry.grade,
                      style: TextStyle(
                        color: gradeColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyLeaderboard extends StatelessWidget {
  const _EmptyLeaderboard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🏆', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          const Text('No scores yet', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          const Text(
            'Be the first to complete a quiz\nin this category!',
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.categories),
            child: const Text('Start a Quiz'),
          ),
        ],
      ),
    );
  }
}

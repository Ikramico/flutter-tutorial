import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../leaderboard_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/leaderboard_repository.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> _tabs = ['All'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    context.read<LeaderboardBloc>().add(const LeaderboardLoadRequested());
  }

  void _rebuildTabs(List<String> tabs) {
    if (_tabController != null) {
      _tabController!.dispose();
    }
    _tabs = tabs;
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) return;
      final filter = _tabController!.index == 0
          ? null
          : _tabs[_tabController!.index];
      context.read<LeaderboardBloc>().add(LeaderboardFilterChanged(filter));
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeaderboardBloc, LeaderboardState>(
      listener: (context, state) {
        if (state is LeaderboardLoaded) {
          // Derive unique category names from the loaded entries
          final categoryNames =
              state.entries.map((e) => e.categoryName).toSet().toList()..sort();
          final newTabs = ['All', ...categoryNames];
          if (newTabs.join() != _tabs.join()) {
            setState(() => _rebuildTabs(newTabs));
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
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white54,
                    labelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    tabAlignment: TabAlignment.start,
                    tabs: _tabs.map((t) => Tab(text: t)).toList(),
                  )
                : null,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, LeaderboardState state) {
    if (state is LeaderboardLoading || state is LeaderboardInitial) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (state is LeaderboardError) {
      return Center(child: Text(state.message));
    }
    if (state is LeaderboardLoaded) {
      if (state.entries.isEmpty) {
        return const _EmptyLeaderboard();
      }
      return _LeaderboardList(entries: state.entries);
    }
    return const SizedBox();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Everything below is unchanged from your original leaderboard_page.dart
// ─────────────────────────────────────────────────────────────────────────────

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
                final rank = i + (entries.length >= 3 ? 4 : 1);
                final entry = entries[entries.length >= 3 ? i + 3 : i];
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
    final colors = [
      const Color(0xFFC0C0C0),
      const Color(0xFFFFD700),
      const Color(0xFFCD7F32),
    ];

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
                  style: const TextStyle(
                    color: Colors.white,
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

class _LeaderboardTile extends StatelessWidget {
  final int rank;
  final LeaderboardEntry entry;

  const _LeaderboardTile({required this.rank, required this.entry});

  @override
  Widget build(BuildContext context) {
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
              Text(
                '${entry.percentage.toStringAsFixed(0)}%',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
            onPressed: () => context.go('/categories'),
            child: const Text('Start a Quiz'),
          ),
        ],
      ),
    );
  }
}

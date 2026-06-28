// lib/features/category/view/category_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/injection.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/category.dart';
import '../category_bloc.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoryBloc>()..add(const CategoryLoadRequested()),
      child: const _CategoryView(),
    );
  }
}

class _CategoryView extends StatelessWidget {
  const _CategoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a Category')),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading || state is CategoryInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is CategoryError) {
            return _ErrorView(
              message: state.message,
              onRetry: () => context.read<CategoryBloc>().add(
                const CategoryLoadRequested(),
              ),
            );
          }
          if (state is CategoryLoaded) {
            return _CategoryGrid(categories: state.categories);
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final List<QuizCategory> categories;
  const _CategoryGrid({required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.88,
      ),
      itemCount: categories.length,
      itemBuilder: (context, i) => _CategoryCard(category: categories[i]),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final QuizCategory category;
  const _CategoryCard({required this.category});

  // Cycle through subtle card tints
  static const _tints = [
    Color(0xFFF0EBFF),
    Color(0xFFEBF5FF),
    Color(0xFFEBFFF5),
    Color(0xFFFFF8EB),
    Color(0xFFFFEBEB),
    Color(0xFFEBFFFF),
  ];

  @override
  Widget build(BuildContext context) {
    final tint = _tints[category.id % _tints.length];

    return GestureDetector(
      onTap: () => context.push(AppRoutes.quiz, extra: {'category': category}),
      child: Container(
        decoration: BoxDecoration(
          color: tint,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category.icon, style: const TextStyle(fontSize: 36)),
            const Spacer(),
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.quiz_outlined,
                  size: 12,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text('10 questions', style: AppTextStyles.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

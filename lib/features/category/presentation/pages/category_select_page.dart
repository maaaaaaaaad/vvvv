import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/features/category/presentation/providers/category_providers.dart';
import 'package:jellomark_mobile_owner/features/category/presentation/providers/category_state.dart';
import 'package:jellomark_mobile_owner/features/category/presentation/widgets/category_grid.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_gradients.dart';

class CategorySelectPage extends ConsumerStatefulWidget {
  final String shopId;
  final Set<String> initialSelectedIds;
  final void Function(List<String> categoryIds)? onSaved;

  const CategorySelectPage({
    super.key,
    required this.shopId,
    this.initialSelectedIds = const {},
    this.onSaved,
  });

  @override
  ConsumerState<CategorySelectPage> createState() => _CategorySelectPageState();
}

class _CategorySelectPageState extends ConsumerState<CategorySelectPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryStateProvider.notifier).loadCategories(
            initialSelectedIds: widget.initialSelectedIds,
          );
    });
  }

  Future<void> _saveCategories() async {
    final success = await ref
        .read(categoryStateProvider.notifier)
        .saveCategories(widget.shopId);

    if (success && mounted) {
      final state = ref.read(categoryStateProvider);
      if (state is CategorySaved) {
        widget.onSaved?.call(state.savedCategories.map((c) => c.id).toList());
      }
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('카테고리 설정'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          if (state is CategoryLoaded)
            TextButton(
              onPressed: _saveCategories,
              child: const Text(
                '저장',
                style: TextStyle(
                  color: AppColors.pastelPink,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: Container(
        decoration:
            const BoxDecoration(gradient: AppGradients.softWhiteGradient),
        child: SafeArea(
          child: _buildBody(state),
        ),
      ),
    );
  }

  Widget _buildBody(CategoryState state) {
    return switch (state) {
      CategoryInitial() => const SizedBox.shrink(),
      CategoryLoading() => _buildLoading(),
      CategoryLoaded(:final categories, :final selectedCategoryIds) =>
        _buildCategoryList(categories, selectedCategoryIds),
      CategorySaving(:final categories, :final selectedCategoryIds) =>
        _buildCategoryList(categories, selectedCategoryIds, isSaving: true),
      CategorySaved() => _buildLoading(),
      CategoryError(:final message) => _buildError(message),
    };
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.pastelPink,
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(categoryStateProvider.notifier).loadCategories(
                    initialSelectedIds: widget.initialSelectedIds,
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pastelPink,
              foregroundColor: Colors.white,
            ),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(
    List categories,
    Set<String> selectedCategoryIds, {
    bool isSaving = false,
  }) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '샵에 해당하는 카테고리를 선택해주세요',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${selectedCategoryIds.length}개 선택됨',
                style: TextStyle(
                  color: AppColors.textPrimary.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              CategoryGrid(
                categories: categories.cast(),
                selectedCategoryIds: selectedCategoryIds,
                onCategoryTap: (categoryId) {
                  ref
                      .read(categoryStateProvider.notifier)
                      .toggleCategory(categoryId);
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        if (isSaving)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.pastelPink,
              ),
            ),
          ),
      ],
    );
  }
}

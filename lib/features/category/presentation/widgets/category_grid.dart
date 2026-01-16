import 'package:flutter/material.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';
import 'package:jellomark_mobile_owner/features/category/presentation/widgets/category_chip.dart';

class CategoryGrid extends StatelessWidget {
  final List<Category> categories;
  final Set<String> selectedCategoryIds;
  final void Function(String categoryId) onCategoryTap;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.selectedCategoryIds,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((category) {
        return CategoryChip(
          category: category,
          isSelected: selectedCategoryIds.contains(category.id),
          onTap: () => onCategoryTap(category.id),
        );
      }).toList(),
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  final Set<String> selectedCategoryIds;

  const CategoryLoaded({
    required this.categories,
    this.selectedCategoryIds = const {},
  });

  CategoryLoaded copyWith({
    List<Category>? categories,
    Set<String>? selectedCategoryIds,
  }) {
    return CategoryLoaded(
      categories: categories ?? this.categories,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
    );
  }

  @override
  List<Object?> get props => [categories, selectedCategoryIds];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class CategorySaving extends CategoryState {
  final List<Category> categories;
  final Set<String> selectedCategoryIds;

  const CategorySaving({
    required this.categories,
    required this.selectedCategoryIds,
  });

  @override
  List<Object?> get props => [categories, selectedCategoryIds];
}

class CategorySaved extends CategoryState {
  final List<Category> savedCategories;

  const CategorySaved({required this.savedCategories});

  @override
  List<Object?> get props => [savedCategories];
}

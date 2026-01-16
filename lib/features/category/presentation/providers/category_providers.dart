import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/core/di/injection_container.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/category/data/datasources/category_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/category/data/repositories/category_repository_impl.dart';
import 'package:jellomark_mobile_owner/features/category/domain/repositories/category_repository.dart';
import 'package:jellomark_mobile_owner/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:jellomark_mobile_owner/features/category/domain/usecases/set_shop_categories_usecase.dart';
import 'package:jellomark_mobile_owner/features/category/presentation/providers/category_state.dart';

final categoryRemoteDataSourceProvider =
    Provider<CategoryRemoteDataSource>((ref) {
  return CategoryRemoteDataSourceImpl(apiClient: sl<ApiClient>());
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(
    remoteDataSource: ref.watch(categoryRemoteDataSourceProvider),
  );
});

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  return GetCategoriesUseCase(repository: ref.watch(categoryRepositoryProvider));
});

final setShopCategoriesUseCaseProvider =
    Provider<SetShopCategoriesUseCase>((ref) {
  return SetShopCategoriesUseCase(
      repository: ref.watch(categoryRepositoryProvider));
});

final categoryStateProvider =
    StateNotifierProvider<CategoryStateNotifier, CategoryState>((ref) {
  return CategoryStateNotifier(
    getCategoriesUseCase: ref.watch(getCategoriesUseCaseProvider),
    setShopCategoriesUseCase: ref.watch(setShopCategoriesUseCaseProvider),
  );
});

class CategoryStateNotifier extends StateNotifier<CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final SetShopCategoriesUseCase setShopCategoriesUseCase;

  CategoryStateNotifier({
    required this.getCategoriesUseCase,
    required this.setShopCategoriesUseCase,
  }) : super(const CategoryInitial());

  Future<void> loadCategories({Set<String>? initialSelectedIds}) async {
    state = const CategoryLoading();
    final result = await getCategoriesUseCase(NoParams());
    result.fold(
      (failure) => state = CategoryError(failure.message),
      (categories) => state = CategoryLoaded(
        categories: categories,
        selectedCategoryIds: initialSelectedIds ?? {},
      ),
    );
  }

  void toggleCategory(String categoryId) {
    final currentState = state;
    if (currentState is CategoryLoaded) {
      final newSelectedIds = Set<String>.from(currentState.selectedCategoryIds);
      if (newSelectedIds.contains(categoryId)) {
        newSelectedIds.remove(categoryId);
      } else {
        newSelectedIds.add(categoryId);
      }
      state = currentState.copyWith(selectedCategoryIds: newSelectedIds);
    }
  }

  void setSelectedCategories(Set<String> categoryIds) {
    final currentState = state;
    if (currentState is CategoryLoaded) {
      state = currentState.copyWith(selectedCategoryIds: categoryIds);
    }
  }

  Future<bool> saveCategories(String shopId) async {
    final currentState = state;
    if (currentState is! CategoryLoaded) return false;

    state = CategorySaving(
      categories: currentState.categories,
      selectedCategoryIds: currentState.selectedCategoryIds,
    );

    final result = await setShopCategoriesUseCase(
      SetShopCategoriesParams(
        shopId: shopId,
        categoryIds: currentState.selectedCategoryIds.toList(),
      ),
    );

    return result.fold(
      (failure) {
        state = CategoryError(failure.message);
        return false;
      },
      (savedCategories) {
        state = CategorySaved(savedCategories: savedCategories);
        return true;
      },
    );
  }

  void reset() {
    state = const CategoryInitial();
  }
}

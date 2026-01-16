import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';
import 'package:jellomark_mobile_owner/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:jellomark_mobile_owner/features/category/domain/usecases/set_shop_categories_usecase.dart';
import 'package:jellomark_mobile_owner/features/category/presentation/providers/category_providers.dart';
import 'package:jellomark_mobile_owner/features/category/presentation/providers/category_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

class MockSetShopCategoriesUseCase extends Mock
    implements SetShopCategoriesUseCase {}

void main() {
  late CategoryStateNotifier notifier;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockSetShopCategoriesUseCase mockSetShopCategoriesUseCase;

  final testCategories = [
    Category(
      id: 'cat-1',
      name: '네일',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    Category(
      id: 'cat-2',
      name: '헤어',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
  ];

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const SetShopCategoriesParams(shopId: 'shop-1', categoryIds: []),
    );
  });

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockSetShopCategoriesUseCase = MockSetShopCategoriesUseCase();
    notifier = CategoryStateNotifier(
      getCategoriesUseCase: mockGetCategoriesUseCase,
      setShopCategoriesUseCase: mockSetShopCategoriesUseCase,
    );
  });

  group('CategoryStateNotifier', () {
    test('initial state should be CategoryInitial', () {
      expect(notifier.state, isA<CategoryInitial>());
    });

    group('loadCategories', () {
      test('should emit CategoryLoaded when successful', () async {
        when(() => mockGetCategoriesUseCase(any()))
            .thenAnswer((_) async => Right(testCategories));

        await notifier.loadCategories();

        expect(notifier.state, isA<CategoryLoaded>());
        final state = notifier.state as CategoryLoaded;
        expect(state.categories, testCategories);
        expect(state.selectedCategoryIds, isEmpty);
      });

      test('should set initial selected ids when provided', () async {
        when(() => mockGetCategoriesUseCase(any()))
            .thenAnswer((_) async => Right(testCategories));

        await notifier.loadCategories(initialSelectedIds: {'cat-1'});

        expect(notifier.state, isA<CategoryLoaded>());
        final state = notifier.state as CategoryLoaded;
        expect(state.selectedCategoryIds, {'cat-1'});
      });

      test('should emit CategoryError when failed', () async {
        when(() => mockGetCategoriesUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('서버 오류')));

        await notifier.loadCategories();

        expect(notifier.state, isA<CategoryError>());
        final state = notifier.state as CategoryError;
        expect(state.message, '서버 오류');
      });
    });

    group('toggleCategory', () {
      test('should add category id when not selected', () async {
        when(() => mockGetCategoriesUseCase(any()))
            .thenAnswer((_) async => Right(testCategories));

        await notifier.loadCategories();
        notifier.toggleCategory('cat-1');

        expect(notifier.state, isA<CategoryLoaded>());
        final state = notifier.state as CategoryLoaded;
        expect(state.selectedCategoryIds, {'cat-1'});
      });

      test('should remove category id when already selected', () async {
        when(() => mockGetCategoriesUseCase(any()))
            .thenAnswer((_) async => Right(testCategories));

        await notifier.loadCategories(initialSelectedIds: {'cat-1'});
        notifier.toggleCategory('cat-1');

        expect(notifier.state, isA<CategoryLoaded>());
        final state = notifier.state as CategoryLoaded;
        expect(state.selectedCategoryIds, isEmpty);
      });

      test('should do nothing when state is not CategoryLoaded', () {
        notifier.toggleCategory('cat-1');
        expect(notifier.state, isA<CategoryInitial>());
      });
    });

    group('setSelectedCategories', () {
      test('should set selected category ids', () async {
        when(() => mockGetCategoriesUseCase(any()))
            .thenAnswer((_) async => Right(testCategories));

        await notifier.loadCategories();
        notifier.setSelectedCategories({'cat-1', 'cat-2'});

        expect(notifier.state, isA<CategoryLoaded>());
        final state = notifier.state as CategoryLoaded;
        expect(state.selectedCategoryIds, {'cat-1', 'cat-2'});
      });

      test('should do nothing when state is not CategoryLoaded', () {
        notifier.setSelectedCategories({'cat-1'});
        expect(notifier.state, isA<CategoryInitial>());
      });
    });

    group('saveCategories', () {
      test('should return true and emit CategorySaved when successful',
          () async {
        when(() => mockGetCategoriesUseCase(any()))
            .thenAnswer((_) async => Right(testCategories));
        when(() => mockSetShopCategoriesUseCase(any()))
            .thenAnswer((_) async => Right(testCategories));

        await notifier.loadCategories(initialSelectedIds: {'cat-1'});
        final result = await notifier.saveCategories('shop-1');

        expect(result, isTrue);
        expect(notifier.state, isA<CategorySaved>());
        final state = notifier.state as CategorySaved;
        expect(state.savedCategories, testCategories);
      });

      test('should return false and emit CategoryError when failed', () async {
        when(() => mockGetCategoriesUseCase(any()))
            .thenAnswer((_) async => Right(testCategories));
        when(() => mockSetShopCategoriesUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('저장 실패')));

        await notifier.loadCategories(initialSelectedIds: {'cat-1'});
        final result = await notifier.saveCategories('shop-1');

        expect(result, isFalse);
        expect(notifier.state, isA<CategoryError>());
        final state = notifier.state as CategoryError;
        expect(state.message, '저장 실패');
      });

      test('should return false when state is not CategoryLoaded', () async {
        final result = await notifier.saveCategories('shop-1');
        expect(result, isFalse);
      });
    });

    group('reset', () {
      test('should reset state to CategoryInitial', () async {
        when(() => mockGetCategoriesUseCase(any()))
            .thenAnswer((_) async => Right(testCategories));

        await notifier.loadCategories();
        expect(notifier.state, isA<CategoryLoaded>());

        notifier.reset();
        expect(notifier.state, isA<CategoryInitial>());
      });
    });
  });
}

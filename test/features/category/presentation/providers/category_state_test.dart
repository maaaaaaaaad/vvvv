import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';
import 'package:jellomark_mobile_owner/features/category/presentation/providers/category_state.dart';

void main() {
  group('CategoryState', () {
    final testCategory = Category(
      id: 'cat-1',
      name: '네일',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    final testCategories = [
      testCategory,
      Category(
        id: 'cat-2',
        name: '헤어',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      ),
    ];

    group('CategoryInitial', () {
      test('should be a subclass of CategoryState', () {
        const state = CategoryInitial();
        expect(state, isA<CategoryState>());
      });

      test('props should be empty', () {
        const state = CategoryInitial();
        expect(state.props, isEmpty);
      });
    });

    group('CategoryLoading', () {
      test('should be a subclass of CategoryState', () {
        const state = CategoryLoading();
        expect(state, isA<CategoryState>());
      });

      test('props should be empty', () {
        const state = CategoryLoading();
        expect(state.props, isEmpty);
      });
    });

    group('CategoryLoaded', () {
      test('should be a subclass of CategoryState', () {
        final state = CategoryLoaded(categories: testCategories);
        expect(state, isA<CategoryState>());
      });

      test('should have default empty selectedCategoryIds', () {
        final state = CategoryLoaded(categories: testCategories);
        expect(state.selectedCategoryIds, isEmpty);
      });

      test('should support custom selectedCategoryIds', () {
        final state = CategoryLoaded(
          categories: testCategories,
          selectedCategoryIds: {'cat-1'},
        );
        expect(state.selectedCategoryIds, {'cat-1'});
      });

      test('copyWith should return new instance with updated values', () {
        final state = CategoryLoaded(categories: testCategories);
        final newState = state.copyWith(selectedCategoryIds: {'cat-1', 'cat-2'});

        expect(newState.categories, testCategories);
        expect(newState.selectedCategoryIds, {'cat-1', 'cat-2'});
      });

      test('copyWith should preserve existing values when not provided', () {
        final state = CategoryLoaded(
          categories: testCategories,
          selectedCategoryIds: {'cat-1'},
        );
        final newState = state.copyWith();

        expect(newState.categories, testCategories);
        expect(newState.selectedCategoryIds, {'cat-1'});
      });

      test('props should contain categories and selectedCategoryIds', () {
        final state = CategoryLoaded(
          categories: testCategories,
          selectedCategoryIds: {'cat-1'},
        );
        expect(state.props, [testCategories, {'cat-1'}]);
      });

      test('should support value equality', () {
        final state1 = CategoryLoaded(
          categories: testCategories,
          selectedCategoryIds: {'cat-1'},
        );
        final state2 = CategoryLoaded(
          categories: testCategories,
          selectedCategoryIds: {'cat-1'},
        );
        expect(state1, equals(state2));
      });
    });

    group('CategoryError', () {
      test('should be a subclass of CategoryState', () {
        const state = CategoryError('에러 메시지');
        expect(state, isA<CategoryState>());
      });

      test('should contain error message', () {
        const state = CategoryError('카테고리를 불러올 수 없습니다');
        expect(state.message, '카테고리를 불러올 수 없습니다');
      });

      test('props should contain message', () {
        const state = CategoryError('에러');
        expect(state.props, ['에러']);
      });
    });

    group('CategorySaving', () {
      test('should be a subclass of CategoryState', () {
        final state = CategorySaving(
          categories: testCategories,
          selectedCategoryIds: {'cat-1'},
        );
        expect(state, isA<CategoryState>());
      });

      test('props should contain categories and selectedCategoryIds', () {
        final state = CategorySaving(
          categories: testCategories,
          selectedCategoryIds: {'cat-1'},
        );
        expect(state.props, [testCategories, {'cat-1'}]);
      });
    });

    group('CategorySaved', () {
      test('should be a subclass of CategoryState', () {
        final state = CategorySaved(savedCategories: testCategories);
        expect(state, isA<CategoryState>());
      });

      test('should contain saved categories', () {
        final state = CategorySaved(savedCategories: testCategories);
        expect(state.savedCategories, testCategories);
      });

      test('props should contain savedCategories', () {
        final state = CategorySaved(savedCategories: testCategories);
        expect(state.props, [testCategories]);
      });
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';

void main() {
  final tCreatedAt = DateTime(2024, 1, 1);
  final tUpdatedAt = DateTime(2024, 1, 2);

  final tCategory = Category(
    id: 'cat-1',
    name: 'Hair',
    createdAt: tCreatedAt,
    updatedAt: tUpdatedAt,
  );

  group('Category', () {
    test('should be a valid Category entity with all required fields', () {
      expect(tCategory.id, 'cat-1');
      expect(tCategory.name, 'Hair');
      expect(tCategory.createdAt, tCreatedAt);
      expect(tCategory.updatedAt, tUpdatedAt);
    });

    test('should support value equality', () {
      final tCategory2 = Category(
        id: 'cat-1',
        name: 'Hair',
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      expect(tCategory, equals(tCategory2));
    });

    test('should not be equal when properties differ', () {
      final tCategoryDifferent = Category(
        id: 'cat-2',
        name: 'Nail',
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      expect(tCategory, isNot(equals(tCategoryDifferent)));
    });

    test('props should contain all properties', () {
      expect(tCategory.props, [
        'cat-1',
        'Hair',
        tCreatedAt,
        tUpdatedAt,
      ]);
    });
  });
}

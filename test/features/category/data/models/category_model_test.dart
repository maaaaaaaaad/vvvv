import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/category/data/models/category_model.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';

void main() {
  final tCreatedAt = DateTime.parse('2024-01-01T00:00:00Z');
  final tUpdatedAt = DateTime.parse('2024-01-01T00:00:00Z');

  final tCategoryModel = CategoryModel(
    id: 'cat-uuid',
    name: 'nail',
    createdAt: tCreatedAt,
    updatedAt: tUpdatedAt,
  );

  final tJson = {
    'id': 'cat-uuid',
    'name': 'nail',
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-01T00:00:00.000Z',
  };

  group('CategoryModel', () {
    test('should be a subclass of Category entity', () {
      expect(tCategoryModel, isA<Category>());
    });

    test('should create CategoryModel from JSON', () {
      final result = CategoryModel.fromJson(tJson);

      expect(result.id, 'cat-uuid');
      expect(result.name, 'nail');
      expect(result.createdAt, tCreatedAt);
      expect(result.updatedAt, tUpdatedAt);
    });

    test('should convert CategoryModel to JSON', () {
      final result = tCategoryModel.toJson();

      expect(result['id'], 'cat-uuid');
      expect(result['name'], 'nail');
      expect(result['createdAt'], '2024-01-01T00:00:00.000Z');
      expect(result['updatedAt'], '2024-01-01T00:00:00.000Z');
    });
  });
}

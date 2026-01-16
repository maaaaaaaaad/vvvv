import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/category_summary_model.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/category_summary.dart';

void main() {
  group('CategorySummaryModel', () {
    const tCategorySummaryModel = CategorySummaryModel(
      id: 'category-uuid',
      name: 'nail',
    );

    final tJson = {
      'id': 'category-uuid',
      'name': 'nail',
    };

    test('should be a subclass of CategorySummary entity', () {
      expect(tCategorySummaryModel, isA<CategorySummary>());
    });

    test('should create CategorySummaryModel from JSON', () {
      final result = CategorySummaryModel.fromJson(tJson);

      expect(result, tCategorySummaryModel);
      expect(result.id, 'category-uuid');
      expect(result.name, 'nail');
    });

    test('should return correct JSON map', () {
      final result = tCategorySummaryModel.toJson();

      expect(result, tJson);
    });
  });
}

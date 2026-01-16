import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/category/data/models/set_categories_request.dart';

void main() {
  group('SetCategoriesRequest', () {
    test('should convert to JSON correctly', () {
      const request = SetCategoriesRequest(
        categoryIds: ['cat-1', 'cat-2', 'cat-3'],
      );

      final result = request.toJson();

      expect(result, {
        'categoryIds': ['cat-1', 'cat-2', 'cat-3'],
      });
    });

    test('should convert empty list to JSON correctly', () {
      const request = SetCategoriesRequest(categoryIds: []);

      final result = request.toJson();

      expect(result, {'categoryIds': []});
    });
  });
}

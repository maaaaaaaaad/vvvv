import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/category_summary.dart';

void main() {
  group('CategorySummary', () {
    test('should be equal when properties are the same', () {
      const category1 = CategorySummary(id: '1', name: 'Hair');
      const category2 = CategorySummary(id: '1', name: 'Hair');

      expect(category1, equals(category2));
    });

    test('should not be equal when properties are different', () {
      const category1 = CategorySummary(id: '1', name: 'Hair');
      const category2 = CategorySummary(id: '2', name: 'Nail');

      expect(category1, isNot(equals(category2)));
    });

    test('props should contain id and name', () {
      const category = CategorySummary(id: '1', name: 'Hair');

      expect(category.props, ['1', 'Hair']);
    });
  });

  group('Beautishop', () {
    final tCategories = const [
      CategorySummary(id: '1', name: 'Hair'),
      CategorySummary(id: '2', name: 'Nail'),
    ];

    final tOperatingTime = {
      'MON': '09:00-18:00',
      'TUE': '09:00-18:00',
      'WED': '09:00-18:00',
      'THU': '09:00-18:00',
      'FRI': '09:00-18:00',
      'SAT': '10:00-15:00',
      'SUN': 'CLOSED',
    };

    final tCreatedAt = DateTime(2024, 1, 1);
    final tUpdatedAt = DateTime(2024, 1, 2);

    test('should be equal when all properties are the same', () {
      final shop1 = Beautishop(
        id: 'shop-1',
        name: 'Test Beauty Shop',
        regNum: '123-45-67890',
        phoneNumber: '02-1234-5678',
        address: 'Seoul, Korea',
        latitude: 37.5665,
        longitude: 126.9780,
        operatingTime: tOperatingTime,
        description: 'A beautiful shop',
        image: 'https://example.com/image.jpg',
        averageRating: 4.5,
        reviewCount: 100,
        categories: tCategories,
        distance: 1.5,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      final shop2 = Beautishop(
        id: 'shop-1',
        name: 'Test Beauty Shop',
        regNum: '123-45-67890',
        phoneNumber: '02-1234-5678',
        address: 'Seoul, Korea',
        latitude: 37.5665,
        longitude: 126.9780,
        operatingTime: tOperatingTime,
        description: 'A beautiful shop',
        image: 'https://example.com/image.jpg',
        averageRating: 4.5,
        reviewCount: 100,
        categories: tCategories,
        distance: 1.5,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      expect(shop1, equals(shop2));
    });

    test('should not be equal when id is different', () {
      final shop1 = Beautishop(
        id: 'shop-1',
        name: 'Test Beauty Shop',
        regNum: '123-45-67890',
        phoneNumber: '02-1234-5678',
        address: 'Seoul, Korea',
        latitude: 37.5665,
        longitude: 126.9780,
        operatingTime: tOperatingTime,
        averageRating: 4.5,
        reviewCount: 100,
        categories: tCategories,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      final shop2 = Beautishop(
        id: 'shop-2',
        name: 'Test Beauty Shop',
        regNum: '123-45-67890',
        phoneNumber: '02-1234-5678',
        address: 'Seoul, Korea',
        latitude: 37.5665,
        longitude: 126.9780,
        operatingTime: tOperatingTime,
        averageRating: 4.5,
        reviewCount: 100,
        categories: tCategories,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      expect(shop1, isNot(equals(shop2)));
    });

    test('should allow null description, image, and distance', () {
      final shop = Beautishop(
        id: 'shop-1',
        name: 'Test Beauty Shop',
        regNum: '123-45-67890',
        phoneNumber: '02-1234-5678',
        address: 'Seoul, Korea',
        latitude: 37.5665,
        longitude: 126.9780,
        operatingTime: tOperatingTime,
        description: null,
        image: null,
        averageRating: 4.5,
        reviewCount: 100,
        categories: tCategories,
        distance: null,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      expect(shop.description, isNull);
      expect(shop.image, isNull);
      expect(shop.distance, isNull);
    });

    test('props should contain all properties', () {
      final shop = Beautishop(
        id: 'shop-1',
        name: 'Test Beauty Shop',
        regNum: '123-45-67890',
        phoneNumber: '02-1234-5678',
        address: 'Seoul, Korea',
        latitude: 37.5665,
        longitude: 126.9780,
        operatingTime: tOperatingTime,
        description: 'A beautiful shop',
        image: 'https://example.com/image.jpg',
        averageRating: 4.5,
        reviewCount: 100,
        categories: tCategories,
        distance: 1.5,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      expect(shop.props, [
        'shop-1',
        'Test Beauty Shop',
        '123-45-67890',
        '02-1234-5678',
        'Seoul, Korea',
        37.5665,
        126.9780,
        tOperatingTime,
        'A beautiful shop',
        'https://example.com/image.jpg',
        4.5,
        100,
        tCategories,
        1.5,
        tCreatedAt,
        tUpdatedAt,
      ]);
    });
  });
}

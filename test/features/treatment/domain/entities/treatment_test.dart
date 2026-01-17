import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';

void main() {
  group('Treatment', () {
    final tCreatedAt = DateTime(2024, 1, 1);
    final tUpdatedAt = DateTime(2024, 1, 2);

    test('should be equal when all properties are the same', () {
      final treatment1 = Treatment(
        id: 'treatment-1',
        name: 'Hair Cut',
        description: 'Basic hair cutting service',
        price: 30000,
        duration: 60,
        imageUrl: 'https://example.com/haircut.jpg',
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      final treatment2 = Treatment(
        id: 'treatment-1',
        name: 'Hair Cut',
        description: 'Basic hair cutting service',
        price: 30000,
        duration: 60,
        imageUrl: 'https://example.com/haircut.jpg',
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      expect(treatment1, equals(treatment2));
    });

    test('should not be equal when id is different', () {
      final treatment1 = Treatment(
        id: 'treatment-1',
        name: 'Hair Cut',
        description: 'Basic hair cutting service',
        price: 30000,
        duration: 60,
        imageUrl: 'https://example.com/haircut.jpg',
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      final treatment2 = Treatment(
        id: 'treatment-2',
        name: 'Hair Cut',
        description: 'Basic hair cutting service',
        price: 30000,
        duration: 60,
        imageUrl: 'https://example.com/haircut.jpg',
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      expect(treatment1, isNot(equals(treatment2)));
    });

    test('should allow null description and imageUrl', () {
      final treatment = Treatment(
        id: 'treatment-1',
        name: 'Hair Cut',
        description: null,
        price: 30000,
        duration: 60,
        imageUrl: null,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      expect(treatment.description, isNull);
      expect(treatment.imageUrl, isNull);
    });

    test('props should contain all properties', () {
      final treatment = Treatment(
        id: 'treatment-1',
        name: 'Hair Cut',
        description: 'Basic hair cutting service',
        price: 30000,
        duration: 60,
        imageUrl: 'https://example.com/haircut.jpg',
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      expect(treatment.props, [
        'treatment-1',
        'Hair Cut',
        'Basic hair cutting service',
        30000,
        60,
        'https://example.com/haircut.jpg',
        tCreatedAt,
        tUpdatedAt,
      ]);
    });

    test('should not be equal when price is different', () {
      final treatment1 = Treatment(
        id: 'treatment-1',
        name: 'Hair Cut',
        description: 'Basic hair cutting service',
        price: 30000,
        duration: 60,
        imageUrl: 'https://example.com/haircut.jpg',
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      final treatment2 = Treatment(
        id: 'treatment-1',
        name: 'Hair Cut',
        description: 'Basic hair cutting service',
        price: 35000,
        duration: 60,
        imageUrl: 'https://example.com/haircut.jpg',
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      expect(treatment1, isNot(equals(treatment2)));
    });

    test('should not be equal when duration is different', () {
      final treatment1 = Treatment(
        id: 'treatment-1',
        name: 'Hair Cut',
        description: 'Basic hair cutting service',
        price: 30000,
        duration: 60,
        imageUrl: 'https://example.com/haircut.jpg',
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      final treatment2 = Treatment(
        id: 'treatment-1',
        name: 'Hair Cut',
        description: 'Basic hair cutting service',
        price: 30000,
        duration: 90,
        imageUrl: 'https://example.com/haircut.jpg',
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      expect(treatment1, isNot(equals(treatment2)));
    });
  });
}

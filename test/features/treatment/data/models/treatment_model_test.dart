import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/treatment_model.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';

void main() {
  group('TreatmentModel', () {
    final tCreatedAt = DateTime.parse('2024-01-01T00:00:00Z');
    final tUpdatedAt = DateTime.parse('2024-01-01T00:00:00Z');

    final tTreatmentModel = TreatmentModel(
      id: 'treatment-uuid',
      name: 'Basic Nail Care',
      description: 'Professional nail care service',
      price: 50000,
      duration: 60,
      imageUrl: 'https://example.com/nail.jpg',
      createdAt: tCreatedAt,
      updatedAt: tUpdatedAt,
    );

    final tJson = {
      'id': 'treatment-uuid',
      'name': 'Basic Nail Care',
      'description': 'Professional nail care service',
      'price': 50000,
      'duration': 60,
      'imageUrl': 'https://example.com/nail.jpg',
      'createdAt': '2024-01-01T00:00:00.000Z',
      'updatedAt': '2024-01-01T00:00:00.000Z',
    };

    test('should be a subclass of Treatment entity', () {
      expect(tTreatmentModel, isA<Treatment>());
    });

    test('should create TreatmentModel from JSON', () {
      final result = TreatmentModel.fromJson(tJson);

      expect(result.id, 'treatment-uuid');
      expect(result.name, 'Basic Nail Care');
      expect(result.description, 'Professional nail care service');
      expect(result.price, 50000);
      expect(result.duration, 60);
      expect(result.imageUrl, 'https://example.com/nail.jpg');
      expect(result.createdAt, tCreatedAt);
      expect(result.updatedAt, tUpdatedAt);
    });

    test('should create TreatmentModel from JSON with null optional fields', () {
      final jsonWithNulls = {
        'id': 'treatment-uuid',
        'name': 'Basic Nail Care',
        'description': null,
        'price': 50000,
        'duration': 60,
        'imageUrl': null,
        'createdAt': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-01-01T00:00:00.000Z',
      };

      final result = TreatmentModel.fromJson(jsonWithNulls);

      expect(result.id, 'treatment-uuid');
      expect(result.name, 'Basic Nail Care');
      expect(result.description, isNull);
      expect(result.price, 50000);
      expect(result.duration, 60);
      expect(result.imageUrl, isNull);
    });

    test('should return correct JSON map', () {
      final result = tTreatmentModel.toJson();

      expect(result['id'], 'treatment-uuid');
      expect(result['name'], 'Basic Nail Care');
      expect(result['description'], 'Professional nail care service');
      expect(result['price'], 50000);
      expect(result['duration'], 60);
      expect(result['imageUrl'], 'https://example.com/nail.jpg');
      expect(result['createdAt'], '2024-01-01T00:00:00.000Z');
      expect(result['updatedAt'], '2024-01-01T00:00:00.000Z');
    });

    test('should return JSON map with null optional fields', () {
      final modelWithNulls = TreatmentModel(
        id: 'treatment-uuid',
        name: 'Basic Nail Care',
        description: null,
        price: 50000,
        duration: 60,
        imageUrl: null,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      final result = modelWithNulls.toJson();

      expect(result['description'], isNull);
      expect(result['imageUrl'], isNull);
    });
  });
}

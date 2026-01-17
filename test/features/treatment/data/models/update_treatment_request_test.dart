import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/update_treatment_request.dart';

void main() {
  group('UpdateTreatmentRequest', () {
    const tUpdateTreatmentRequest = UpdateTreatmentRequest(
      name: 'Updated Nail Care',
      description: 'Updated description',
      price: 60000,
      duration: 90,
      imageUrl: 'https://example.com/new-nail.jpg',
    );

    test('should create UpdateTreatmentRequest with all fields', () {
      expect(tUpdateTreatmentRequest.name, 'Updated Nail Care');
      expect(tUpdateTreatmentRequest.description, 'Updated description');
      expect(tUpdateTreatmentRequest.price, 60000);
      expect(tUpdateTreatmentRequest.duration, 90);
      expect(tUpdateTreatmentRequest.imageUrl, 'https://example.com/new-nail.jpg');
    });

    test('should create UpdateTreatmentRequest with all null fields', () {
      const request = UpdateTreatmentRequest();

      expect(request.name, isNull);
      expect(request.description, isNull);
      expect(request.price, isNull);
      expect(request.duration, isNull);
      expect(request.imageUrl, isNull);
    });

    test('should create UpdateTreatmentRequest with partial fields', () {
      const request = UpdateTreatmentRequest(
        name: 'Only name updated',
        price: 70000,
      );

      expect(request.name, 'Only name updated');
      expect(request.description, isNull);
      expect(request.price, 70000);
      expect(request.duration, isNull);
      expect(request.imageUrl, isNull);
    });

    test('should return correct JSON map with all fields', () {
      final result = tUpdateTreatmentRequest.toJson();

      expect(result['name'], 'Updated Nail Care');
      expect(result['description'], 'Updated description');
      expect(result['price'], 60000);
      expect(result['duration'], 90);
      expect(result['imageUrl'], 'https://example.com/new-nail.jpg');
    });

    test('should return empty JSON map when all fields are null', () {
      const request = UpdateTreatmentRequest();

      final result = request.toJson();

      expect(result, isEmpty);
    });

    test('should return JSON map with only non-null fields', () {
      const request = UpdateTreatmentRequest(
        name: 'Only name updated',
        price: 70000,
      );

      final result = request.toJson();

      expect(result['name'], 'Only name updated');
      expect(result['price'], 70000);
      expect(result.containsKey('description'), isFalse);
      expect(result.containsKey('duration'), isFalse);
      expect(result.containsKey('imageUrl'), isFalse);
    });
  });
}

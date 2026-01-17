import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/create_treatment_request.dart';

void main() {
  group('CreateTreatmentRequest', () {
    const tCreateTreatmentRequest = CreateTreatmentRequest(
      name: 'Basic Nail Care',
      description: 'Professional nail care service',
      price: 50000,
      duration: 60,
      imageUrl: 'https://example.com/nail.jpg',
    );

    test('should create CreateTreatmentRequest with all fields', () {
      expect(tCreateTreatmentRequest.name, 'Basic Nail Care');
      expect(tCreateTreatmentRequest.description, 'Professional nail care service');
      expect(tCreateTreatmentRequest.price, 50000);
      expect(tCreateTreatmentRequest.duration, 60);
      expect(tCreateTreatmentRequest.imageUrl, 'https://example.com/nail.jpg');
    });

    test('should create CreateTreatmentRequest with null optional fields', () {
      const request = CreateTreatmentRequest(
        name: 'Basic Nail Care',
        price: 50000,
        duration: 60,
      );

      expect(request.name, 'Basic Nail Care');
      expect(request.description, isNull);
      expect(request.price, 50000);
      expect(request.duration, 60);
      expect(request.imageUrl, isNull);
    });

    test('should return correct JSON map', () {
      final result = tCreateTreatmentRequest.toJson();

      expect(result['name'], 'Basic Nail Care');
      expect(result['description'], 'Professional nail care service');
      expect(result['price'], 50000);
      expect(result['duration'], 60);
      expect(result['imageUrl'], 'https://example.com/nail.jpg');
    });

    test('should return JSON map without null optional fields', () {
      const request = CreateTreatmentRequest(
        name: 'Basic Nail Care',
        price: 50000,
        duration: 60,
      );

      final result = request.toJson();

      expect(result['name'], 'Basic Nail Care');
      expect(result['price'], 50000);
      expect(result['duration'], 60);
      expect(result.containsKey('description'), isFalse);
      expect(result.containsKey('imageUrl'), isFalse);
    });
  });
}

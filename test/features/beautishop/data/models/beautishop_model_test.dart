import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/beautishop_model.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/category_summary_model.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';

void main() {
  group('BeautishopModel', () {
    final tCreatedAt = DateTime.parse('2024-01-01T00:00:00Z');
    final tUpdatedAt = DateTime.parse('2024-01-01T00:00:00Z');

    final tBeautishopModel = BeautishopModel(
      id: 'shop-uuid',
      name: 'Beautiful Nail',
      regNum: '1234567890',
      phoneNumber: '02-1234-5678',
      address: 'Seoul, Gangnam',
      latitude: 37.5665,
      longitude: 126.9780,
      operatingTime: {'MON': '09:00-18:00', 'TUE': '09:00-18:00'},
      description: 'Best nail shop',
      image: 'https://example.com/image.jpg',
      averageRating: 4.5,
      reviewCount: 10,
      categories: const [
        CategorySummaryModel(id: 'cat-uuid', name: 'nail'),
      ],
      distance: null,
      createdAt: tCreatedAt,
      updatedAt: tUpdatedAt,
    );

    final tJson = {
      'id': 'shop-uuid',
      'name': 'Beautiful Nail',
      'regNum': '1234567890',
      'phoneNumber': '02-1234-5678',
      'address': 'Seoul, Gangnam',
      'latitude': 37.5665,
      'longitude': 126.9780,
      'operatingTime': {'MON': '09:00-18:00', 'TUE': '09:00-18:00'},
      'description': 'Best nail shop',
      'image': 'https://example.com/image.jpg',
      'averageRating': 4.5,
      'reviewCount': 10,
      'categories': [
        {'id': 'cat-uuid', 'name': 'nail'},
      ],
      'distance': null,
      'createdAt': '2024-01-01T00:00:00.000Z',
      'updatedAt': '2024-01-01T00:00:00.000Z',
    };

    test('should be a subclass of Beautishop entity', () {
      expect(tBeautishopModel, isA<Beautishop>());
    });

    test('should create BeautishopModel from JSON', () {
      final result = BeautishopModel.fromJson(tJson);

      expect(result.id, 'shop-uuid');
      expect(result.name, 'Beautiful Nail');
      expect(result.regNum, '1234567890');
      expect(result.phoneNumber, '02-1234-5678');
      expect(result.address, 'Seoul, Gangnam');
      expect(result.latitude, 37.5665);
      expect(result.longitude, 126.9780);
      expect(result.operatingTime, {'MON': '09:00-18:00', 'TUE': '09:00-18:00'});
      expect(result.description, 'Best nail shop');
      expect(result.image, 'https://example.com/image.jpg');
      expect(result.averageRating, 4.5);
      expect(result.reviewCount, 10);
      expect(result.categories.length, 1);
      expect(result.categories[0].id, 'cat-uuid');
      expect(result.distance, isNull);
    });

    test('should create BeautishopModel from JSON with null optional fields', () {
      final jsonWithNulls = {
        'id': 'shop-uuid',
        'name': 'Beautiful Nail',
        'regNum': '1234567890',
        'phoneNumber': '02-1234-5678',
        'address': 'Seoul, Gangnam',
        'latitude': 37.5665,
        'longitude': 126.9780,
        'operatingTime': {'MON': '09:00-18:00'},
        'description': null,
        'image': null,
        'averageRating': 0.0,
        'reviewCount': 0,
        'categories': <Map<String, dynamic>>[],
        'distance': null,
        'createdAt': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-01-01T00:00:00.000Z',
      };

      final result = BeautishopModel.fromJson(jsonWithNulls);

      expect(result.description, isNull);
      expect(result.image, isNull);
      expect(result.distance, isNull);
      expect(result.categories, isEmpty);
    });

    test('should create BeautishopModel from JSON with distance', () {
      final jsonWithDistance = {
        ...tJson,
        'distance': 1.5,
      };

      final result = BeautishopModel.fromJson(jsonWithDistance);

      expect(result.distance, 1.5);
    });

    test('should return correct JSON map', () {
      final result = tBeautishopModel.toJson();

      expect(result['id'], 'shop-uuid');
      expect(result['name'], 'Beautiful Nail');
      expect(result['regNum'], '1234567890');
      expect(result['phoneNumber'], '02-1234-5678');
      expect(result['address'], 'Seoul, Gangnam');
      expect(result['latitude'], 37.5665);
      expect(result['longitude'], 126.9780);
      expect(result['operatingTime'], {'MON': '09:00-18:00', 'TUE': '09:00-18:00'});
      expect(result['description'], 'Best nail shop');
      expect(result['image'], 'https://example.com/image.jpg');
      expect(result['averageRating'], 4.5);
      expect(result['reviewCount'], 10);
      expect(result['categories'], isA<List>());
      expect(result['distance'], isNull);
    });

    test('should handle integer averageRating from JSON', () {
      final jsonWithIntRating = {
        ...tJson,
        'averageRating': 4,
      };

      final result = BeautishopModel.fromJson(jsonWithIntRating);

      expect(result.averageRating, 4.0);
    });
  });
}

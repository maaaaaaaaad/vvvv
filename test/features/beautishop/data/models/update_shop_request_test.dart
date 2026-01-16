import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/update_shop_request.dart';

void main() {
  group('UpdateShopRequest', () {
    const tUpdateShopRequest = UpdateShopRequest(
      operatingTime: {'MON': '10:00-19:00', 'TUE': '10:00-19:00'},
      shopDescription: 'Updated description',
      shopImage: 'https://example.com/new-image.jpg',
    );

    test('should create UpdateShopRequest with all fields', () {
      expect(tUpdateShopRequest.operatingTime, {'MON': '10:00-19:00', 'TUE': '10:00-19:00'});
      expect(tUpdateShopRequest.shopDescription, 'Updated description');
      expect(tUpdateShopRequest.shopImage, 'https://example.com/new-image.jpg');
    });

    test('should create UpdateShopRequest with all null fields', () {
      const request = UpdateShopRequest();

      expect(request.operatingTime, isNull);
      expect(request.shopDescription, isNull);
      expect(request.shopImage, isNull);
    });

    test('should create UpdateShopRequest with partial fields', () {
      const request = UpdateShopRequest(
        shopDescription: 'Only description updated',
      );

      expect(request.operatingTime, isNull);
      expect(request.shopDescription, 'Only description updated');
      expect(request.shopImage, isNull);
    });

    test('should return correct JSON map with all fields', () {
      final result = tUpdateShopRequest.toJson();

      expect(result['operatingTime'], {'MON': '10:00-19:00', 'TUE': '10:00-19:00'});
      expect(result['shopDescription'], 'Updated description');
      expect(result['shopImage'], 'https://example.com/new-image.jpg');
    });

    test('should return empty JSON map when all fields are null', () {
      const request = UpdateShopRequest();

      final result = request.toJson();

      expect(result, isEmpty);
    });

    test('should return JSON map with only non-null fields', () {
      const request = UpdateShopRequest(
        shopDescription: 'Only description updated',
      );

      final result = request.toJson();

      expect(result.containsKey('operatingTime'), isFalse);
      expect(result['shopDescription'], 'Only description updated');
      expect(result.containsKey('shopImage'), isFalse);
    });
  });
}

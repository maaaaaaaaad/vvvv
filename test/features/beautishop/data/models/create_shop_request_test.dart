import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/create_shop_request.dart';

void main() {
  group('CreateShopRequest', () {
    const tCreateShopRequest = CreateShopRequest(
      shopName: 'Beautiful Nail',
      shopRegNum: '1234567890',
      shopPhoneNumber: '02-1234-5678',
      shopAddress: 'Seoul, Gangnam',
      latitude: 37.5665,
      longitude: 126.9780,
      operatingTime: {'MON': '09:00-18:00', 'TUE': '09:00-18:00'},
      shopDescription: 'Best nail shop',
      shopImage: 'https://example.com/image.jpg',
    );

    test('should create CreateShopRequest with all fields', () {
      expect(tCreateShopRequest.shopName, 'Beautiful Nail');
      expect(tCreateShopRequest.shopRegNum, '1234567890');
      expect(tCreateShopRequest.shopPhoneNumber, '02-1234-5678');
      expect(tCreateShopRequest.shopAddress, 'Seoul, Gangnam');
      expect(tCreateShopRequest.latitude, 37.5665);
      expect(tCreateShopRequest.longitude, 126.9780);
      expect(tCreateShopRequest.operatingTime, {'MON': '09:00-18:00', 'TUE': '09:00-18:00'});
      expect(tCreateShopRequest.shopDescription, 'Best nail shop');
      expect(tCreateShopRequest.shopImage, 'https://example.com/image.jpg');
    });

    test('should create CreateShopRequest with null optional fields', () {
      const request = CreateShopRequest(
        shopName: 'Beautiful Nail',
        shopRegNum: '1234567890',
        shopPhoneNumber: '02-1234-5678',
        shopAddress: 'Seoul, Gangnam',
        latitude: 37.5665,
        longitude: 126.9780,
        operatingTime: {'MON': '09:00-18:00'},
      );

      expect(request.shopDescription, isNull);
      expect(request.shopImage, isNull);
    });

    test('should return correct JSON map', () {
      final result = tCreateShopRequest.toJson();

      expect(result['shopName'], 'Beautiful Nail');
      expect(result['shopRegNum'], '1234567890');
      expect(result['shopPhoneNumber'], '02-1234-5678');
      expect(result['shopAddress'], 'Seoul, Gangnam');
      expect(result['latitude'], 37.5665);
      expect(result['longitude'], 126.9780);
      expect(result['operatingTime'], {'MON': '09:00-18:00', 'TUE': '09:00-18:00'});
      expect(result['shopDescription'], 'Best nail shop');
      expect(result['shopImage'], 'https://example.com/image.jpg');
    });

    test('should return JSON map without null optional fields', () {
      const request = CreateShopRequest(
        shopName: 'Beautiful Nail',
        shopRegNum: '1234567890',
        shopPhoneNumber: '02-1234-5678',
        shopAddress: 'Seoul, Gangnam',
        latitude: 37.5665,
        longitude: 126.9780,
        operatingTime: {'MON': '09:00-18:00'},
      );

      final result = request.toJson();

      expect(result.containsKey('shopDescription'), isFalse);
      expect(result.containsKey('shopImage'), isFalse);
    });
  });
}

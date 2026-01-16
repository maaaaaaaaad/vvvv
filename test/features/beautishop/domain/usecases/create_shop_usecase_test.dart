import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/repositories/shop_repository.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/usecases/create_shop_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockShopRepository extends Mock implements ShopRepository {}

void main() {
  late CreateShopUseCase useCase;
  late MockShopRepository mockRepository;

  setUp(() {
    mockRepository = MockShopRepository();
    useCase = CreateShopUseCase(repository: mockRepository);
  });

  final tOperatingTime = {
    'MON': '09:00-18:00',
    'TUE': '09:00-18:00',
    'WED': '09:00-18:00',
    'THU': '09:00-18:00',
    'FRI': '09:00-18:00',
    'SAT': '10:00-15:00',
    'SUN': 'CLOSED',
  };

  final tParams = CreateShopParams(
    shopName: 'Test Beauty Shop',
    shopRegNum: '123-45-67890',
    shopPhoneNumber: '02-1234-5678',
    shopAddress: 'Seoul, Korea',
    latitude: 37.5665,
    longitude: 126.9780,
    operatingTime: tOperatingTime,
    shopDescription: 'A beautiful shop',
    shopImage: 'https://example.com/image.jpg',
  );

  final tBeautishop = Beautishop(
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
    averageRating: 0.0,
    reviewCount: 0,
    categories: const [],
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  group('CreateShopUseCase', () {
    test('should create shop and save shopId to local storage when successful',
        () async {
      when(() => mockRepository.createShop(
            shopName: any(named: 'shopName'),
            shopRegNum: any(named: 'shopRegNum'),
            shopPhoneNumber: any(named: 'shopPhoneNumber'),
            shopAddress: any(named: 'shopAddress'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            operatingTime: any(named: 'operatingTime'),
            shopDescription: any(named: 'shopDescription'),
            shopImage: any(named: 'shopImage'),
          )).thenAnswer((_) async => Right(tBeautishop));
      when(() => mockRepository.saveMyShopId(any()))
          .thenAnswer((_) async => const Right(unit));

      final result = await useCase(tParams);

      expect(result, Right(tBeautishop));
      verify(() => mockRepository.createShop(
            shopName: tParams.shopName,
            shopRegNum: tParams.shopRegNum,
            shopPhoneNumber: tParams.shopPhoneNumber,
            shopAddress: tParams.shopAddress,
            latitude: tParams.latitude,
            longitude: tParams.longitude,
            operatingTime: tParams.operatingTime,
            shopDescription: tParams.shopDescription,
            shopImage: tParams.shopImage,
          )).called(1);
      verify(() => mockRepository.saveMyShopId(tBeautishop.id)).called(1);
    });

    test('should return failure when createShop fails', () async {
      const tFailure = ServerFailure('Failed to create shop');
      when(() => mockRepository.createShop(
            shopName: any(named: 'shopName'),
            shopRegNum: any(named: 'shopRegNum'),
            shopPhoneNumber: any(named: 'shopPhoneNumber'),
            shopAddress: any(named: 'shopAddress'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            operatingTime: any(named: 'operatingTime'),
            shopDescription: any(named: 'shopDescription'),
            shopImage: any(named: 'shopImage'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(tParams);

      expect(result, const Left(tFailure));
      verifyNever(() => mockRepository.saveMyShopId(any()));
    });

    test('should create shop without optional fields', () async {
      final paramsWithoutOptional = CreateShopParams(
        shopName: 'Test Beauty Shop',
        shopRegNum: '123-45-67890',
        shopPhoneNumber: '02-1234-5678',
        shopAddress: 'Seoul, Korea',
        latitude: 37.5665,
        longitude: 126.9780,
        operatingTime: tOperatingTime,
      );

      final shopWithoutOptional = Beautishop(
        id: 'shop-1',
        name: 'Test Beauty Shop',
        regNum: '123-45-67890',
        phoneNumber: '02-1234-5678',
        address: 'Seoul, Korea',
        latitude: 37.5665,
        longitude: 126.9780,
        operatingTime: tOperatingTime,
        averageRating: 0.0,
        reviewCount: 0,
        categories: const [],
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      when(() => mockRepository.createShop(
            shopName: any(named: 'shopName'),
            shopRegNum: any(named: 'shopRegNum'),
            shopPhoneNumber: any(named: 'shopPhoneNumber'),
            shopAddress: any(named: 'shopAddress'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            operatingTime: any(named: 'operatingTime'),
            shopDescription: any(named: 'shopDescription'),
            shopImage: any(named: 'shopImage'),
          )).thenAnswer((_) async => Right(shopWithoutOptional));
      when(() => mockRepository.saveMyShopId(any()))
          .thenAnswer((_) async => const Right(unit));

      final result = await useCase(paramsWithoutOptional);

      expect(result, Right(shopWithoutOptional));
      verify(() => mockRepository.createShop(
            shopName: paramsWithoutOptional.shopName,
            shopRegNum: paramsWithoutOptional.shopRegNum,
            shopPhoneNumber: paramsWithoutOptional.shopPhoneNumber,
            shopAddress: paramsWithoutOptional.shopAddress,
            latitude: paramsWithoutOptional.latitude,
            longitude: paramsWithoutOptional.longitude,
            operatingTime: paramsWithoutOptional.operatingTime,
            shopDescription: null,
            shopImage: null,
          )).called(1);
    });
  });

  group('CreateShopParams', () {
    test('should be equal when properties are the same', () {
      final params1 = CreateShopParams(
        shopName: 'Test Shop',
        shopRegNum: '123-45-67890',
        shopPhoneNumber: '02-1234-5678',
        shopAddress: 'Seoul',
        latitude: 37.0,
        longitude: 127.0,
        operatingTime: tOperatingTime,
      );
      final params2 = CreateShopParams(
        shopName: 'Test Shop',
        shopRegNum: '123-45-67890',
        shopPhoneNumber: '02-1234-5678',
        shopAddress: 'Seoul',
        latitude: 37.0,
        longitude: 127.0,
        operatingTime: tOperatingTime,
      );

      expect(params1, equals(params2));
    });

    test('props should contain all properties', () {
      final params = CreateShopParams(
        shopName: 'Test Shop',
        shopRegNum: '123-45-67890',
        shopPhoneNumber: '02-1234-5678',
        shopAddress: 'Seoul',
        latitude: 37.0,
        longitude: 127.0,
        operatingTime: tOperatingTime,
        shopDescription: 'Description',
        shopImage: 'image.jpg',
      );

      expect(params.props, [
        'Test Shop',
        '123-45-67890',
        '02-1234-5678',
        'Seoul',
        37.0,
        127.0,
        tOperatingTime,
        'Description',
        'image.jpg',
      ]);
    });
  });
}

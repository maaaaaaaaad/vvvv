import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/category_summary.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/repositories/shop_repository.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/usecases/update_shop_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockShopRepository extends Mock implements ShopRepository {}

void main() {
  late UpdateShopUseCase useCase;
  late MockShopRepository mockRepository;

  setUp(() {
    mockRepository = MockShopRepository();
    useCase = UpdateShopUseCase(repository: mockRepository);
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

  final tUpdatedOperatingTime = {
    'MON': '10:00-20:00',
    'TUE': '10:00-20:00',
    'WED': '10:00-20:00',
    'THU': '10:00-20:00',
    'FRI': '10:00-20:00',
    'SAT': '10:00-18:00',
    'SUN': 'CLOSED',
  };

  final tUpdatedBeautishop = Beautishop(
    id: 'shop-1',
    name: 'Test Beauty Shop',
    regNum: '123-45-67890',
    phoneNumber: '02-1234-5678',
    address: 'Seoul, Korea',
    latitude: 37.5665,
    longitude: 126.9780,
    operatingTime: tUpdatedOperatingTime,
    description: 'Updated description',
    image: 'https://example.com/new-image.jpg',
    averageRating: 4.5,
    reviewCount: 100,
    categories: const [
      CategorySummary(id: '1', name: 'Hair'),
      CategorySummary(id: '2', name: 'Nail'),
    ],
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 3),
  );

  group('UpdateShopUseCase', () {
    test('should return updated Beautishop when update is successful',
        () async {
      final params = UpdateShopParams(
        shopId: 'shop-1',
        operatingTime: tUpdatedOperatingTime,
        shopDescription: 'Updated description',
        shopImage: 'https://example.com/new-image.jpg',
      );

      when(() => mockRepository.updateShop(
            shopId: any(named: 'shopId'),
            operatingTime: any(named: 'operatingTime'),
            shopDescription: any(named: 'shopDescription'),
            shopImage: any(named: 'shopImage'),
          )).thenAnswer((_) async => Right(tUpdatedBeautishop));

      final result = await useCase(params);

      expect(result, Right(tUpdatedBeautishop));
      verify(() => mockRepository.updateShop(
            shopId: params.shopId,
            operatingTime: params.operatingTime,
            shopDescription: params.shopDescription,
            shopImage: params.shopImage,
          )).called(1);
    });

    test('should return failure when update fails', () async {
      const tFailure = ServerFailure('Failed to update shop');
      final params = UpdateShopParams(
        shopId: 'shop-1',
        shopDescription: 'Updated description',
      );

      when(() => mockRepository.updateShop(
            shopId: any(named: 'shopId'),
            operatingTime: any(named: 'operatingTime'),
            shopDescription: any(named: 'shopDescription'),
            shopImage: any(named: 'shopImage'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(params);

      expect(result, const Left(tFailure));
    });

    test('should update only description when only description is provided',
        () async {
      final params = UpdateShopParams(
        shopId: 'shop-1',
        shopDescription: 'Only description updated',
      );

      final shopWithUpdatedDescription = Beautishop(
        id: 'shop-1',
        name: 'Test Beauty Shop',
        regNum: '123-45-67890',
        phoneNumber: '02-1234-5678',
        address: 'Seoul, Korea',
        latitude: 37.5665,
        longitude: 126.9780,
        operatingTime: tOperatingTime,
        description: 'Only description updated',
        image: 'https://example.com/image.jpg',
        averageRating: 4.5,
        reviewCount: 100,
        categories: const [
          CategorySummary(id: '1', name: 'Hair'),
        ],
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 3),
      );

      when(() => mockRepository.updateShop(
            shopId: any(named: 'shopId'),
            operatingTime: any(named: 'operatingTime'),
            shopDescription: any(named: 'shopDescription'),
            shopImage: any(named: 'shopImage'),
          )).thenAnswer((_) async => Right(shopWithUpdatedDescription));

      final result = await useCase(params);

      expect(result, Right(shopWithUpdatedDescription));
      verify(() => mockRepository.updateShop(
            shopId: 'shop-1',
            operatingTime: null,
            shopDescription: 'Only description updated',
            shopImage: null,
          )).called(1);
    });

    test('should return AuthFailure when not authorized', () async {
      const tFailure = AuthFailure('Not authorized to update this shop');
      final params = UpdateShopParams(
        shopId: 'shop-1',
        shopDescription: 'Updated description',
      );

      when(() => mockRepository.updateShop(
            shopId: any(named: 'shopId'),
            operatingTime: any(named: 'operatingTime'),
            shopDescription: any(named: 'shopDescription'),
            shopImage: any(named: 'shopImage'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(params);

      expect(result, const Left(tFailure));
    });
  });

  group('UpdateShopParams', () {
    test('should be equal when properties are the same', () {
      final params1 = UpdateShopParams(
        shopId: 'shop-1',
        operatingTime: tUpdatedOperatingTime,
        shopDescription: 'Description',
        shopImage: 'image.jpg',
      );
      final params2 = UpdateShopParams(
        shopId: 'shop-1',
        operatingTime: tUpdatedOperatingTime,
        shopDescription: 'Description',
        shopImage: 'image.jpg',
      );

      expect(params1, equals(params2));
    });

    test('props should contain all properties', () {
      final params = UpdateShopParams(
        shopId: 'shop-1',
        operatingTime: tUpdatedOperatingTime,
        shopDescription: 'Description',
        shopImage: 'image.jpg',
      );

      expect(params.props, [
        'shop-1',
        tUpdatedOperatingTime,
        'Description',
        'image.jpg',
      ]);
    });
  });
}

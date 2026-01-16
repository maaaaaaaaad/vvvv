import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/category_summary.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/repositories/shop_repository.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/usecases/get_shop_by_id_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockShopRepository extends Mock implements ShopRepository {}

void main() {
  late GetShopByIdUseCase useCase;
  late MockShopRepository mockRepository;

  setUp(() {
    mockRepository = MockShopRepository();
    useCase = GetShopByIdUseCase(repository: mockRepository);
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
    averageRating: 4.5,
    reviewCount: 100,
    categories: const [
      CategorySummary(id: '1', name: 'Hair'),
      CategorySummary(id: '2', name: 'Nail'),
    ],
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 2),
  );

  const tShopId = 'shop-1';

  group('GetShopByIdUseCase', () {
    test('should return Beautishop when shop is found', () async {
      when(() => mockRepository.getShopById(any()))
          .thenAnswer((_) async => Right(tBeautishop));

      final result = await useCase(const GetShopByIdParams(shopId: tShopId));

      expect(result, Right(tBeautishop));
      verify(() => mockRepository.getShopById(tShopId)).called(1);
    });

    test('should return ServerFailure when shop is not found', () async {
      const tFailure = ServerFailure('Shop not found');
      when(() => mockRepository.getShopById(any()))
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(const GetShopByIdParams(shopId: tShopId));

      expect(result, const Left(tFailure));
      verify(() => mockRepository.getShopById(tShopId)).called(1);
    });

    test('should return NetworkFailure when network error occurs', () async {
      const tFailure = NetworkFailure('Network error');
      when(() => mockRepository.getShopById(any()))
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(const GetShopByIdParams(shopId: tShopId));

      expect(result, const Left(tFailure));
    });
  });

  group('GetShopByIdParams', () {
    test('should be equal when properties are the same', () {
      const params1 = GetShopByIdParams(shopId: 'shop-1');
      const params2 = GetShopByIdParams(shopId: 'shop-1');

      expect(params1, equals(params2));
    });

    test('props should contain shopId', () {
      const params = GetShopByIdParams(shopId: 'shop-1');

      expect(params.props, ['shop-1']);
    });
  });
}

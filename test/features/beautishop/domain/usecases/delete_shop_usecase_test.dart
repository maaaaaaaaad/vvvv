import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/repositories/shop_repository.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/usecases/delete_shop_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockShopRepository extends Mock implements ShopRepository {}

void main() {
  late DeleteShopUseCase useCase;
  late MockShopRepository mockRepository;

  setUp(() {
    mockRepository = MockShopRepository();
    useCase = DeleteShopUseCase(repository: mockRepository);
  });

  const tShopId = 'shop-1';

  group('DeleteShopUseCase', () {
    test(
        'should delete shop and clear shopId from local storage when successful',
        () async {
      when(() => mockRepository.deleteShop(any()))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockRepository.clearMyShopId())
          .thenAnswer((_) async => const Right(unit));

      final result =
          await useCase(const DeleteShopParams(shopId: tShopId));

      expect(result, const Right(unit));
      verify(() => mockRepository.deleteShop(tShopId)).called(1);
      verify(() => mockRepository.clearMyShopId()).called(1);
    });

    test('should return failure when deleteShop fails', () async {
      const tFailure = ServerFailure('Failed to delete shop');
      when(() => mockRepository.deleteShop(any()))
          .thenAnswer((_) async => const Left(tFailure));

      final result =
          await useCase(const DeleteShopParams(shopId: tShopId));

      expect(result, const Left(tFailure));
      verify(() => mockRepository.deleteShop(tShopId)).called(1);
      verifyNever(() => mockRepository.clearMyShopId());
    });

    test('should return AuthFailure when not authorized', () async {
      const tFailure = AuthFailure('Not authorized to delete this shop');
      when(() => mockRepository.deleteShop(any()))
          .thenAnswer((_) async => const Left(tFailure));

      final result =
          await useCase(const DeleteShopParams(shopId: tShopId));

      expect(result, const Left(tFailure));
      verifyNever(() => mockRepository.clearMyShopId());
    });

    test('should still return success even if clearMyShopId fails', () async {
      const tCacheFailure = CacheFailure('Failed to clear shop id');
      when(() => mockRepository.deleteShop(any()))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockRepository.clearMyShopId())
          .thenAnswer((_) async => const Left(tCacheFailure));

      final result =
          await useCase(const DeleteShopParams(shopId: tShopId));

      expect(result, const Right(unit));
      verify(() => mockRepository.deleteShop(tShopId)).called(1);
      verify(() => mockRepository.clearMyShopId()).called(1);
    });
  });

  group('DeleteShopParams', () {
    test('should be equal when properties are the same', () {
      const params1 = DeleteShopParams(shopId: 'shop-1');
      const params2 = DeleteShopParams(shopId: 'shop-1');

      expect(params1, equals(params2));
    });

    test('props should contain shopId', () {
      const params = DeleteShopParams(shopId: 'shop-1');

      expect(params.props, ['shop-1']);
    });
  });
}

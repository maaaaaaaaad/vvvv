import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/repositories/treatment_repository.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/get_shop_treatments_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTreatmentRepository extends Mock implements TreatmentRepository {}

void main() {
  late GetShopTreatmentsUseCase useCase;
  late MockTreatmentRepository mockRepository;

  setUp(() {
    mockRepository = MockTreatmentRepository();
    useCase = GetShopTreatmentsUseCase(repository: mockRepository);
  });

  const tShopId = 'shop-1';

  final tTreatments = [
    Treatment(
      id: 'treatment-1',
      name: 'Hair Cut',
      description: 'Basic hair cutting service',
      price: 30000,
      duration: 60,
      imageUrl: 'https://example.com/haircut.jpg',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    Treatment(
      id: 'treatment-2',
      name: 'Hair Coloring',
      description: 'Professional hair coloring',
      price: 80000,
      duration: 120,
      imageUrl: 'https://example.com/coloring.jpg',
      createdAt: DateTime(2024, 1, 2),
      updatedAt: DateTime(2024, 1, 2),
    ),
  ];

  group('GetShopTreatmentsUseCase', () {
    test('should return list of treatments when successful', () async {
      when(() => mockRepository.getShopTreatments(any()))
          .thenAnswer((_) async => Right(tTreatments));

      final result = await useCase(
        const GetShopTreatmentsParams(shopId: tShopId),
      );

      expect(result, Right(tTreatments));
      verify(() => mockRepository.getShopTreatments(tShopId)).called(1);
    });

    test('should return empty list when shop has no treatments', () async {
      when(() => mockRepository.getShopTreatments(any()))
          .thenAnswer((_) async => const Right([]));

      final result = await useCase(
        const GetShopTreatmentsParams(shopId: tShopId),
      );

      expect(result, const Right(<Treatment>[]));
      verify(() => mockRepository.getShopTreatments(tShopId)).called(1);
    });

    test('should return ServerFailure when repository fails', () async {
      const tFailure = ServerFailure('Failed to get treatments');
      when(() => mockRepository.getShopTreatments(any()))
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(
        const GetShopTreatmentsParams(shopId: tShopId),
      );

      expect(result, const Left(tFailure));
      verify(() => mockRepository.getShopTreatments(tShopId)).called(1);
    });

    test('should return NotFoundFailure when shop does not exist', () async {
      const tFailure = NotFoundFailure('Shop not found');
      when(() => mockRepository.getShopTreatments(any()))
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(
        const GetShopTreatmentsParams(shopId: 'non-existent-shop'),
      );

      expect(result, const Left(tFailure));
    });
  });

  group('GetShopTreatmentsParams', () {
    test('should be equal when properties are the same', () {
      const params1 = GetShopTreatmentsParams(shopId: 'shop-1');
      const params2 = GetShopTreatmentsParams(shopId: 'shop-1');

      expect(params1, equals(params2));
    });

    test('should not be equal when shopId is different', () {
      const params1 = GetShopTreatmentsParams(shopId: 'shop-1');
      const params2 = GetShopTreatmentsParams(shopId: 'shop-2');

      expect(params1, isNot(equals(params2)));
    });

    test('props should contain shopId', () {
      const params = GetShopTreatmentsParams(shopId: 'shop-1');

      expect(params.props, ['shop-1']);
    });
  });
}

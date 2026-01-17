import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/repositories/treatment_repository.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/create_treatment_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTreatmentRepository extends Mock implements TreatmentRepository {}

void main() {
  late CreateTreatmentUseCase useCase;
  late MockTreatmentRepository mockRepository;

  setUp(() {
    mockRepository = MockTreatmentRepository();
    useCase = CreateTreatmentUseCase(repository: mockRepository);
  });

  final tParams = CreateTreatmentParams(
    shopId: 'shop-1',
    name: 'Hair Cut',
    description: 'Basic hair cutting service',
    price: 30000,
    duration: 60,
    imageUrl: 'https://example.com/haircut.jpg',
  );

  final tTreatment = Treatment(
    id: 'treatment-1',
    name: 'Hair Cut',
    description: 'Basic hair cutting service',
    price: 30000,
    duration: 60,
    imageUrl: 'https://example.com/haircut.jpg',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  group('CreateTreatmentUseCase', () {
    test('should create treatment and return it when successful', () async {
      when(() => mockRepository.createTreatment(
            shopId: any(named: 'shopId'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            duration: any(named: 'duration'),
            imageUrl: any(named: 'imageUrl'),
          )).thenAnswer((_) async => Right(tTreatment));

      final result = await useCase(tParams);

      expect(result, Right(tTreatment));
      verify(() => mockRepository.createTreatment(
            shopId: tParams.shopId,
            name: tParams.name,
            description: tParams.description,
            price: tParams.price,
            duration: tParams.duration,
            imageUrl: tParams.imageUrl,
          )).called(1);
    });

    test('should return failure when createTreatment fails', () async {
      const tFailure = ServerFailure('Failed to create treatment');
      when(() => mockRepository.createTreatment(
            shopId: any(named: 'shopId'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            duration: any(named: 'duration'),
            imageUrl: any(named: 'imageUrl'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(tParams);

      expect(result, const Left(tFailure));
    });

    test('should create treatment without optional fields', () async {
      final paramsWithoutOptional = CreateTreatmentParams(
        shopId: 'shop-1',
        name: 'Hair Cut',
        price: 30000,
        duration: 60,
      );

      final treatmentWithoutOptional = Treatment(
        id: 'treatment-1',
        name: 'Hair Cut',
        price: 30000,
        duration: 60,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      when(() => mockRepository.createTreatment(
            shopId: any(named: 'shopId'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            duration: any(named: 'duration'),
            imageUrl: any(named: 'imageUrl'),
          )).thenAnswer((_) async => Right(treatmentWithoutOptional));

      final result = await useCase(paramsWithoutOptional);

      expect(result, Right(treatmentWithoutOptional));
      verify(() => mockRepository.createTreatment(
            shopId: paramsWithoutOptional.shopId,
            name: paramsWithoutOptional.name,
            description: null,
            price: paramsWithoutOptional.price,
            duration: paramsWithoutOptional.duration,
            imageUrl: null,
          )).called(1);
    });

    test('should return AuthFailure when not authorized', () async {
      const tFailure = AuthFailure('Not authorized to create treatment');
      when(() => mockRepository.createTreatment(
            shopId: any(named: 'shopId'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            duration: any(named: 'duration'),
            imageUrl: any(named: 'imageUrl'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(tParams);

      expect(result, const Left(tFailure));
    });

    test('should return NotFoundFailure when shop does not exist', () async {
      const tFailure = NotFoundFailure('Shop not found');
      when(() => mockRepository.createTreatment(
            shopId: any(named: 'shopId'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            duration: any(named: 'duration'),
            imageUrl: any(named: 'imageUrl'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(tParams);

      expect(result, const Left(tFailure));
    });
  });

  group('CreateTreatmentParams', () {
    test('should be equal when properties are the same', () {
      final params1 = CreateTreatmentParams(
        shopId: 'shop-1',
        name: 'Hair Cut',
        description: 'Description',
        price: 30000,
        duration: 60,
        imageUrl: 'image.jpg',
      );
      final params2 = CreateTreatmentParams(
        shopId: 'shop-1',
        name: 'Hair Cut',
        description: 'Description',
        price: 30000,
        duration: 60,
        imageUrl: 'image.jpg',
      );

      expect(params1, equals(params2));
    });

    test('props should contain all properties', () {
      final params = CreateTreatmentParams(
        shopId: 'shop-1',
        name: 'Hair Cut',
        description: 'Description',
        price: 30000,
        duration: 60,
        imageUrl: 'image.jpg',
      );

      expect(params.props, [
        'shop-1',
        'Hair Cut',
        'Description',
        30000,
        60,
        'image.jpg',
      ]);
    });
  });
}

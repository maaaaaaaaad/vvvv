import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/repositories/treatment_repository.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/update_treatment_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTreatmentRepository extends Mock implements TreatmentRepository {}

void main() {
  late UpdateTreatmentUseCase useCase;
  late MockTreatmentRepository mockRepository;

  setUp(() {
    mockRepository = MockTreatmentRepository();
    useCase = UpdateTreatmentUseCase(repository: mockRepository);
  });

  final tUpdatedTreatment = Treatment(
    id: 'treatment-1',
    name: 'Premium Hair Cut',
    description: 'Updated hair cutting service',
    price: 35000,
    duration: 90,
    imageUrl: 'https://example.com/new-haircut.jpg',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 3),
  );

  group('UpdateTreatmentUseCase', () {
    test('should return updated Treatment when update is successful', () async {
      final params = UpdateTreatmentParams(
        treatmentId: 'treatment-1',
        name: 'Premium Hair Cut',
        description: 'Updated hair cutting service',
        price: 35000,
        duration: 90,
        imageUrl: 'https://example.com/new-haircut.jpg',
      );

      when(() => mockRepository.updateTreatment(
            treatmentId: any(named: 'treatmentId'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            duration: any(named: 'duration'),
            imageUrl: any(named: 'imageUrl'),
          )).thenAnswer((_) async => Right(tUpdatedTreatment));

      final result = await useCase(params);

      expect(result, Right(tUpdatedTreatment));
      verify(() => mockRepository.updateTreatment(
            treatmentId: params.treatmentId,
            name: params.name,
            description: params.description,
            price: params.price,
            duration: params.duration,
            imageUrl: params.imageUrl,
          )).called(1);
    });

    test('should return failure when update fails', () async {
      const tFailure = ServerFailure('Failed to update treatment');
      final params = UpdateTreatmentParams(
        treatmentId: 'treatment-1',
        name: 'Premium Hair Cut',
      );

      when(() => mockRepository.updateTreatment(
            treatmentId: any(named: 'treatmentId'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            duration: any(named: 'duration'),
            imageUrl: any(named: 'imageUrl'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(params);

      expect(result, const Left(tFailure));
    });

    test('should update only price when only price is provided', () async {
      final params = UpdateTreatmentParams(
        treatmentId: 'treatment-1',
        price: 40000,
      );

      final treatmentWithUpdatedPrice = Treatment(
        id: 'treatment-1',
        name: 'Hair Cut',
        description: 'Basic hair cutting service',
        price: 40000,
        duration: 60,
        imageUrl: 'https://example.com/haircut.jpg',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 3),
      );

      when(() => mockRepository.updateTreatment(
            treatmentId: any(named: 'treatmentId'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            duration: any(named: 'duration'),
            imageUrl: any(named: 'imageUrl'),
          )).thenAnswer((_) async => Right(treatmentWithUpdatedPrice));

      final result = await useCase(params);

      expect(result, Right(treatmentWithUpdatedPrice));
      verify(() => mockRepository.updateTreatment(
            treatmentId: 'treatment-1',
            name: null,
            description: null,
            price: 40000,
            duration: null,
            imageUrl: null,
          )).called(1);
    });

    test('should return AuthFailure when not authorized', () async {
      const tFailure = AuthFailure('Not authorized to update this treatment');
      final params = UpdateTreatmentParams(
        treatmentId: 'treatment-1',
        name: 'Premium Hair Cut',
      );

      when(() => mockRepository.updateTreatment(
            treatmentId: any(named: 'treatmentId'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            duration: any(named: 'duration'),
            imageUrl: any(named: 'imageUrl'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(params);

      expect(result, const Left(tFailure));
    });

    test('should return NotFoundFailure when treatment does not exist',
        () async {
      const tFailure = NotFoundFailure('Treatment not found');
      final params = UpdateTreatmentParams(
        treatmentId: 'non-existent-treatment',
        name: 'Premium Hair Cut',
      );

      when(() => mockRepository.updateTreatment(
            treatmentId: any(named: 'treatmentId'),
            name: any(named: 'name'),
            description: any(named: 'description'),
            price: any(named: 'price'),
            duration: any(named: 'duration'),
            imageUrl: any(named: 'imageUrl'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(params);

      expect(result, const Left(tFailure));
    });
  });

  group('UpdateTreatmentParams', () {
    test('should be equal when properties are the same', () {
      final params1 = UpdateTreatmentParams(
        treatmentId: 'treatment-1',
        name: 'Hair Cut',
        description: 'Description',
        price: 30000,
        duration: 60,
        imageUrl: 'image.jpg',
      );
      final params2 = UpdateTreatmentParams(
        treatmentId: 'treatment-1',
        name: 'Hair Cut',
        description: 'Description',
        price: 30000,
        duration: 60,
        imageUrl: 'image.jpg',
      );

      expect(params1, equals(params2));
    });

    test('props should contain all properties', () {
      final params = UpdateTreatmentParams(
        treatmentId: 'treatment-1',
        name: 'Hair Cut',
        description: 'Description',
        price: 30000,
        duration: 60,
        imageUrl: 'image.jpg',
      );

      expect(params.props, [
        'treatment-1',
        'Hair Cut',
        'Description',
        30000,
        60,
        'image.jpg',
      ]);
    });
  });
}

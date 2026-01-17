import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/repositories/treatment_repository.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/delete_treatment_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTreatmentRepository extends Mock implements TreatmentRepository {}

void main() {
  late DeleteTreatmentUseCase useCase;
  late MockTreatmentRepository mockRepository;

  setUp(() {
    mockRepository = MockTreatmentRepository();
    useCase = DeleteTreatmentUseCase(repository: mockRepository);
  });

  const tTreatmentId = 'treatment-1';

  group('DeleteTreatmentUseCase', () {
    test('should delete treatment when successful', () async {
      when(() => mockRepository.deleteTreatment(any()))
          .thenAnswer((_) async => const Right(unit));

      final result = await useCase(
        const DeleteTreatmentParams(treatmentId: tTreatmentId),
      );

      expect(result, const Right(unit));
      verify(() => mockRepository.deleteTreatment(tTreatmentId)).called(1);
    });

    test('should return failure when deleteTreatment fails', () async {
      const tFailure = ServerFailure('Failed to delete treatment');
      when(() => mockRepository.deleteTreatment(any()))
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(
        const DeleteTreatmentParams(treatmentId: tTreatmentId),
      );

      expect(result, const Left(tFailure));
      verify(() => mockRepository.deleteTreatment(tTreatmentId)).called(1);
    });

    test('should return AuthFailure when not authorized', () async {
      const tFailure = AuthFailure('Not authorized to delete this treatment');
      when(() => mockRepository.deleteTreatment(any()))
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(
        const DeleteTreatmentParams(treatmentId: tTreatmentId),
      );

      expect(result, const Left(tFailure));
    });

    test('should return NotFoundFailure when treatment does not exist',
        () async {
      const tFailure = NotFoundFailure('Treatment not found');
      when(() => mockRepository.deleteTreatment(any()))
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(
        const DeleteTreatmentParams(treatmentId: 'non-existent-treatment'),
      );

      expect(result, const Left(tFailure));
    });
  });

  group('DeleteTreatmentParams', () {
    test('should be equal when properties are the same', () {
      const params1 = DeleteTreatmentParams(treatmentId: 'treatment-1');
      const params2 = DeleteTreatmentParams(treatmentId: 'treatment-1');

      expect(params1, equals(params2));
    });

    test('should not be equal when treatmentId is different', () {
      const params1 = DeleteTreatmentParams(treatmentId: 'treatment-1');
      const params2 = DeleteTreatmentParams(treatmentId: 'treatment-2');

      expect(params1, isNot(equals(params2)));
    });

    test('props should contain treatmentId', () {
      const params = DeleteTreatmentParams(treatmentId: 'treatment-1');

      expect(params.props, ['treatment-1']);
    });
  });
}

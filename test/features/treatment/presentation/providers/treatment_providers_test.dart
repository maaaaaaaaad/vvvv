import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/create_treatment_usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/delete_treatment_usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/get_shop_treatments_usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/update_treatment_usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/providers/treatment_providers.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/providers/treatment_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetShopTreatmentsUseCase extends Mock
    implements GetShopTreatmentsUseCase {}

class MockCreateTreatmentUseCase extends Mock
    implements CreateTreatmentUseCase {}

class MockUpdateTreatmentUseCase extends Mock
    implements UpdateTreatmentUseCase {}

class MockDeleteTreatmentUseCase extends Mock
    implements DeleteTreatmentUseCase {}

class FakeGetShopTreatmentsParams extends Fake
    implements GetShopTreatmentsParams {}

class FakeCreateTreatmentParams extends Fake implements CreateTreatmentParams {}

class FakeUpdateTreatmentParams extends Fake implements UpdateTreatmentParams {}

class FakeDeleteTreatmentParams extends Fake implements DeleteTreatmentParams {}

void main() {
  late TreatmentStateNotifier notifier;
  late MockGetShopTreatmentsUseCase mockGetShopTreatmentsUseCase;
  late MockCreateTreatmentUseCase mockCreateTreatmentUseCase;
  late MockUpdateTreatmentUseCase mockUpdateTreatmentUseCase;
  late MockDeleteTreatmentUseCase mockDeleteTreatmentUseCase;

  setUpAll(() {
    registerFallbackValue(FakeGetShopTreatmentsParams());
    registerFallbackValue(FakeCreateTreatmentParams());
    registerFallbackValue(FakeUpdateTreatmentParams());
    registerFallbackValue(FakeDeleteTreatmentParams());
  });

  setUp(() {
    mockGetShopTreatmentsUseCase = MockGetShopTreatmentsUseCase();
    mockCreateTreatmentUseCase = MockCreateTreatmentUseCase();
    mockUpdateTreatmentUseCase = MockUpdateTreatmentUseCase();
    mockDeleteTreatmentUseCase = MockDeleteTreatmentUseCase();
    notifier = TreatmentStateNotifier(
      getShopTreatmentsUseCase: mockGetShopTreatmentsUseCase,
      createTreatmentUseCase: mockCreateTreatmentUseCase,
      updateTreatmentUseCase: mockUpdateTreatmentUseCase,
      deleteTreatmentUseCase: mockDeleteTreatmentUseCase,
    );
  });

  final tTreatment = Treatment(
    id: 'treatment-uuid',
    name: 'Test Treatment',
    description: 'A test treatment',
    price: 50000,
    duration: 60,
    imageUrl: 'https://example.com/image.jpg',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final tTreatmentList = [
    tTreatment,
    Treatment(
      id: 'treatment-uuid-2',
      name: 'Another Treatment',
      description: 'Another test treatment',
      price: 30000,
      duration: 30,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
  ];

  group('TreatmentStateNotifier', () {
    test('initial state should be TreatmentInitial', () {
      expect(notifier.state, const TreatmentInitial());
    });
  });

  group('loadTreatments', () {
    test(
      'should emit TreatmentLoading then TreatmentListLoaded when use case returns treatments',
      () async {
        when(() => mockGetShopTreatmentsUseCase(any()))
            .thenAnswer((_) async => Right(tTreatmentList));

        expect(notifier.state, const TreatmentInitial());

        await notifier.loadTreatments('shop-uuid');

        expect(
            notifier.state, TreatmentListLoaded(treatments: tTreatmentList));
        verify(() => mockGetShopTreatmentsUseCase(any())).called(1);
      },
    );

    test(
      'should emit TreatmentLoading then TreatmentEmpty when use case returns empty list',
      () async {
        when(() => mockGetShopTreatmentsUseCase(any()))
            .thenAnswer((_) async => const Right([]));

        expect(notifier.state, const TreatmentInitial());

        await notifier.loadTreatments('shop-uuid');

        expect(notifier.state, const TreatmentEmpty());
      },
    );

    test(
      'should emit TreatmentLoading then TreatmentError when use case returns failure',
      () async {
        const tFailure = ServerFailure('Server error');
        when(() => mockGetShopTreatmentsUseCase(any()))
            .thenAnswer((_) async => const Left(tFailure));

        expect(notifier.state, const TreatmentInitial());

        await notifier.loadTreatments('shop-uuid');

        expect(notifier.state, const TreatmentError('Server error'));
      },
    );
  });

  group('createTreatment', () {
    final tParams = CreateTreatmentParams(
      shopId: 'shop-uuid',
      name: 'New Treatment',
      description: 'A new treatment',
      price: 40000,
      duration: 45,
    );

    test(
      'should emit TreatmentCreating then TreatmentCreated when use case returns success',
      () async {
        when(() => mockCreateTreatmentUseCase(any()))
            .thenAnswer((_) async => Right(tTreatment));

        await notifier.createTreatment(tParams);

        expect(notifier.state, TreatmentCreated(treatment: tTreatment));
        verify(() => mockCreateTreatmentUseCase(any())).called(1);
      },
    );

    test(
      'should emit TreatmentCreating then TreatmentError when use case returns failure',
      () async {
        const tFailure = ServerFailure('Creation failed');
        when(() => mockCreateTreatmentUseCase(any()))
            .thenAnswer((_) async => const Left(tFailure));

        await notifier.createTreatment(tParams);

        expect(notifier.state, const TreatmentError('Creation failed'));
      },
    );
  });

  group('updateTreatment', () {
    final tParams = UpdateTreatmentParams(
      treatmentId: 'treatment-uuid',
      name: 'Updated Treatment',
      price: 55000,
    );

    test(
      'should emit TreatmentUpdating then TreatmentUpdated when use case returns success',
      () async {
        when(() => mockUpdateTreatmentUseCase(any()))
            .thenAnswer((_) async => Right(tTreatment));

        await notifier.updateTreatment(tParams);

        expect(notifier.state, TreatmentUpdated(treatment: tTreatment));
        verify(() => mockUpdateTreatmentUseCase(any())).called(1);
      },
    );

    test(
      'should emit TreatmentUpdating then TreatmentError when use case returns failure',
      () async {
        const tFailure = ServerFailure('Update failed');
        when(() => mockUpdateTreatmentUseCase(any()))
            .thenAnswer((_) async => const Left(tFailure));

        await notifier.updateTreatment(tParams);

        expect(notifier.state, const TreatmentError('Update failed'));
      },
    );
  });

  group('deleteTreatment', () {
    test(
      'should emit TreatmentDeleting then TreatmentDeleted when use case returns success',
      () async {
        when(() => mockDeleteTreatmentUseCase(any()))
            .thenAnswer((_) async => const Right(unit));

        await notifier.deleteTreatment('treatment-uuid');

        expect(notifier.state, const TreatmentDeleted());
        verify(() => mockDeleteTreatmentUseCase(any())).called(1);
      },
    );

    test(
      'should emit TreatmentDeleting then TreatmentError when use case returns failure',
      () async {
        const tFailure = ServerFailure('Delete failed');
        when(() => mockDeleteTreatmentUseCase(any()))
            .thenAnswer((_) async => const Left(tFailure));

        await notifier.deleteTreatment('treatment-uuid');

        expect(notifier.state, const TreatmentError('Delete failed'));
      },
    );
  });

  group('reset', () {
    test('should reset state to TreatmentInitial', () async {
      when(() => mockGetShopTreatmentsUseCase(any()))
          .thenAnswer((_) async => Right(tTreatmentList));
      await notifier.loadTreatments('shop-uuid');
      expect(notifier.state, isA<TreatmentListLoaded>());

      notifier.reset();

      expect(notifier.state, const TreatmentInitial());
    });
  });
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/datasources/treatment_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/create_treatment_request.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/treatment_model.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/update_treatment_request.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/repositories/treatment_repository_impl.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:mocktail/mocktail.dart';

class MockTreatmentRemoteDataSource extends Mock implements TreatmentRemoteDataSource {}

void main() {
  late TreatmentRepositoryImpl repository;
  late MockTreatmentRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockTreatmentRemoteDataSource();
    repository = TreatmentRepositoryImpl(remoteDataSource: mockDataSource);
  });

  setUpAll(() {
    registerFallbackValue(const CreateTreatmentRequest(
      name: '',
      price: 0,
      duration: 0,
    ));
    registerFallbackValue(const UpdateTreatmentRequest());
  });

  final tCreatedAt = DateTime.parse('2024-01-01T00:00:00Z');
  final tUpdatedAt = DateTime.parse('2024-01-01T00:00:00Z');

  final tTreatmentModel = TreatmentModel(
    id: 'treatment-uuid',
    name: 'Basic Nail Care',
    description: 'Professional nail care service',
    price: 50000,
    duration: 60,
    imageUrl: 'https://example.com/nail.jpg',
    createdAt: tCreatedAt,
    updatedAt: tUpdatedAt,
  );

  final tTreatmentModelList = [tTreatmentModel];

  group('getShopTreatments', () {
    const tShopId = 'shop-uuid';

    test('should return List<Treatment> when data source call is successful', () async {
      when(() => mockDataSource.getShopTreatments(tShopId))
          .thenAnswer((_) async => tTreatmentModelList);

      final result = await repository.getShopTreatments(tShopId);

      expect(result, isA<Right<Failure, List<Treatment>>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (treatments) {
          expect(treatments.length, 1);
          expect(treatments[0].id, 'treatment-uuid');
          expect(treatments[0].name, 'Basic Nail Care');
        },
      );
      verify(() => mockDataSource.getShopTreatments(tShopId)).called(1);
    });

    test('should return NotFoundFailure when DioException with 404 occurs', () async {
      when(() => mockDataSource.getShopTreatments(tShopId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
            statusCode: 404,
            data: {'message': 'Shop not found'},
          ),
        ),
      );

      final result = await repository.getShopTreatments(tShopId);

      expect(result, isA<Left<Failure, List<Treatment>>>());
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return AuthFailure when DioException with 401 occurs', () async {
      when(() => mockDataSource.getShopTreatments(tShopId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      final result = await repository.getShopTreatments(tShopId);

      expect(result, isA<Left<Failure, List<Treatment>>>());
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when unknown exception occurs', () async {
      when(() => mockDataSource.getShopTreatments(tShopId))
          .thenThrow(Exception('Unknown error'));

      final result = await repository.getShopTreatments(tShopId);

      expect(result, isA<Left<Failure, List<Treatment>>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('getTreatmentById', () {
    const tTreatmentId = 'treatment-uuid';

    test('should return Treatment when data source call is successful', () async {
      when(() => mockDataSource.getTreatmentById(tTreatmentId))
          .thenAnswer((_) async => tTreatmentModel);

      final result = await repository.getTreatmentById(tTreatmentId);

      expect(result, isA<Right<Failure, Treatment>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (treatment) {
          expect(treatment.id, 'treatment-uuid');
          expect(treatment.name, 'Basic Nail Care');
        },
      );
      verify(() => mockDataSource.getTreatmentById(tTreatmentId)).called(1);
    });

    test('should return NotFoundFailure when DioException with 404 occurs', () async {
      when(() => mockDataSource.getTreatmentById(tTreatmentId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
            statusCode: 404,
            data: {'message': 'Treatment not found'},
          ),
        ),
      );

      final result = await repository.getTreatmentById(tTreatmentId);

      expect(result, isA<Left<Failure, Treatment>>());
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return AuthFailure when DioException with 401 occurs', () async {
      when(() => mockDataSource.getTreatmentById(tTreatmentId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      final result = await repository.getTreatmentById(tTreatmentId);

      expect(result, isA<Left<Failure, Treatment>>());
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('createTreatment', () {
    const tShopId = 'shop-uuid';
    const tName = 'Basic Nail Care';
    const tDescription = 'Professional nail care service';
    const tPrice = 50000;
    const tDuration = 60;
    const tImageUrl = 'https://example.com/nail.jpg';

    test('should return Treatment when data source call is successful', () async {
      when(() => mockDataSource.createTreatment(tShopId, any()))
          .thenAnswer((_) async => tTreatmentModel);

      final result = await repository.createTreatment(
        shopId: tShopId,
        name: tName,
        description: tDescription,
        price: tPrice,
        duration: tDuration,
        imageUrl: tImageUrl,
      );

      expect(result, isA<Right<Failure, Treatment>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (treatment) {
          expect(treatment.id, 'treatment-uuid');
          expect(treatment.name, 'Basic Nail Care');
        },
      );
      verify(() => mockDataSource.createTreatment(tShopId, any())).called(1);
    });

    test('should return AuthFailure when DioException with 401 occurs', () async {
      when(() => mockDataSource.createTreatment(tShopId, any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      final result = await repository.createTreatment(
        shopId: tShopId,
        name: tName,
        price: tPrice,
        duration: tDuration,
      );

      expect(result, isA<Left<Failure, Treatment>>());
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return NotFoundFailure when DioException with 404 occurs', () async {
      when(() => mockDataSource.createTreatment(tShopId, any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
            statusCode: 404,
            data: {'message': 'Shop not found'},
          ),
        ),
      );

      final result = await repository.createTreatment(
        shopId: tShopId,
        name: tName,
        price: tPrice,
        duration: tDuration,
      );

      expect(result, isA<Left<Failure, Treatment>>());
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when DioException with other status occurs', () async {
      when(() => mockDataSource.createTreatment(tShopId, any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
            statusCode: 400,
            data: {'message': 'Bad request'},
          ),
        ),
      );

      final result = await repository.createTreatment(
        shopId: tShopId,
        name: tName,
        price: tPrice,
        duration: tDuration,
      );

      expect(result, isA<Left<Failure, Treatment>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when unknown exception occurs', () async {
      when(() => mockDataSource.createTreatment(tShopId, any()))
          .thenThrow(Exception('Unknown error'));

      final result = await repository.createTreatment(
        shopId: tShopId,
        name: tName,
        price: tPrice,
        duration: tDuration,
      );

      expect(result, isA<Left<Failure, Treatment>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('updateTreatment', () {
    const tTreatmentId = 'treatment-uuid';
    const tName = 'Updated Nail Care';
    const tPrice = 60000;

    test('should return Treatment when data source call is successful', () async {
      when(() => mockDataSource.updateTreatment(tTreatmentId, any()))
          .thenAnswer((_) async => tTreatmentModel);

      final result = await repository.updateTreatment(
        treatmentId: tTreatmentId,
        name: tName,
        price: tPrice,
      );

      expect(result, isA<Right<Failure, Treatment>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (treatment) => expect(treatment.id, 'treatment-uuid'),
      );
      verify(() => mockDataSource.updateTreatment(tTreatmentId, any())).called(1);
    });

    test('should return NotFoundFailure when DioException with 404 occurs', () async {
      when(() => mockDataSource.updateTreatment(tTreatmentId, any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
            statusCode: 404,
            data: {'message': 'Treatment not found'},
          ),
        ),
      );

      final result = await repository.updateTreatment(
        treatmentId: tTreatmentId,
        name: tName,
      );

      expect(result, isA<Left<Failure, Treatment>>());
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return AuthFailure when DioException with 401 occurs', () async {
      when(() => mockDataSource.updateTreatment(tTreatmentId, any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      final result = await repository.updateTreatment(
        treatmentId: tTreatmentId,
        name: tName,
      );

      expect(result, isA<Left<Failure, Treatment>>());
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('deleteTreatment', () {
    const tTreatmentId = 'treatment-uuid';

    test('should return Unit when data source call is successful', () async {
      when(() => mockDataSource.deleteTreatment(tTreatmentId))
          .thenAnswer((_) async => {});

      final result = await repository.deleteTreatment(tTreatmentId);

      expect(result, isA<Right<Failure, Unit>>());
      verify(() => mockDataSource.deleteTreatment(tTreatmentId)).called(1);
    });

    test('should return NotFoundFailure when DioException with 404 occurs', () async {
      when(() => mockDataSource.deleteTreatment(tTreatmentId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
            statusCode: 404,
            data: {'message': 'Treatment not found'},
          ),
        ),
      );

      final result = await repository.deleteTreatment(tTreatmentId);

      expect(result, isA<Left<Failure, Unit>>());
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return AuthFailure when DioException with 401 occurs', () async {
      when(() => mockDataSource.deleteTreatment(tTreatmentId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      final result = await repository.deleteTreatment(tTreatmentId);

      expect(result, isA<Left<Failure, Unit>>());
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when unknown exception occurs', () async {
      when(() => mockDataSource.deleteTreatment(tTreatmentId))
          .thenThrow(Exception('Unknown error'));

      final result = await repository.deleteTreatment(tTreatmentId);

      expect(result, isA<Left<Failure, Unit>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });
}

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/datasources/treatment_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/create_treatment_request.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/treatment_model.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/update_treatment_request.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late TreatmentRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;
  late MockDio mockDio;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();
    when(() => mockApiClient.dio).thenReturn(mockDio);
    dataSource = TreatmentRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  setUpAll(() {
    registerFallbackValue(const CreateTreatmentRequest(
      name: '',
      price: 0,
      duration: 0,
    ));
    registerFallbackValue(const UpdateTreatmentRequest());
    registerFallbackValue(RequestOptions(path: ''));
  });

  final tTreatmentJson = {
    'id': 'treatment-uuid',
    'name': 'Basic Nail Care',
    'description': 'Professional nail care service',
    'price': 50000,
    'duration': 60,
    'imageUrl': 'https://example.com/nail.jpg',
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-01T00:00:00.000Z',
  };

  group('getShopTreatments', () {
    const tShopId = 'shop-uuid';

    test('should return List<TreatmentModel> when GET /api/beautishops/{shopId}/treatments succeeds', () async {
      when(() => mockDio.get('/api/beautishops/$tShopId/treatments')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
          statusCode: 200,
          data: [tTreatmentJson],
        ),
      );

      final result = await dataSource.getShopTreatments(tShopId);

      expect(result, isA<List<TreatmentModel>>());
      expect(result.length, 1);
      expect(result[0].id, 'treatment-uuid');
      expect(result[0].name, 'Basic Nail Care');
      verify(() => mockDio.get('/api/beautishops/$tShopId/treatments')).called(1);
    });

    test('should return empty list when no treatments exist', () async {
      when(() => mockDio.get('/api/beautishops/$tShopId/treatments')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
          statusCode: 200,
          data: <Map<String, dynamic>>[],
        ),
      );

      final result = await dataSource.getShopTreatments(tShopId);

      expect(result, isEmpty);
    });

    test('should throw DioException when shop is not found', () async {
      when(() => mockDio.get('/api/beautishops/$tShopId/treatments')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
            statusCode: 404,
            data: {'message': 'Shop not found'},
          ),
        ),
      );

      expect(
        () => dataSource.getShopTreatments(tShopId),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('getTreatmentById', () {
    const tTreatmentId = 'treatment-uuid';

    test('should return TreatmentModel when GET /api/treatments/{treatmentId} succeeds', () async {
      when(() => mockDio.get('/api/treatments/$tTreatmentId')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
          statusCode: 200,
          data: tTreatmentJson,
        ),
      );

      final result = await dataSource.getTreatmentById(tTreatmentId);

      expect(result, isA<TreatmentModel>());
      expect(result.id, 'treatment-uuid');
      expect(result.name, 'Basic Nail Care');
      verify(() => mockDio.get('/api/treatments/$tTreatmentId')).called(1);
    });

    test('should throw DioException when treatment is not found', () async {
      when(() => mockDio.get('/api/treatments/$tTreatmentId')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
            statusCode: 404,
            data: {'message': 'Treatment not found'},
          ),
        ),
      );

      expect(
        () => dataSource.getTreatmentById(tTreatmentId),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('createTreatment', () {
    const tShopId = 'shop-uuid';
    const tRequest = CreateTreatmentRequest(
      name: 'Basic Nail Care',
      description: 'Professional nail care service',
      price: 50000,
      duration: 60,
      imageUrl: 'https://example.com/nail.jpg',
    );

    test('should return TreatmentModel when POST /api/beautishops/{shopId}/treatments succeeds', () async {
      when(() => mockDio.post(
            '/api/beautishops/$tShopId/treatments',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
          statusCode: 201,
          data: tTreatmentJson,
        ),
      );

      final result = await dataSource.createTreatment(tShopId, tRequest);

      expect(result, isA<TreatmentModel>());
      expect(result.id, 'treatment-uuid');
      expect(result.name, 'Basic Nail Care');
      verify(() => mockDio.post(
            '/api/beautishops/$tShopId/treatments',
            data: tRequest.toJson(),
          )).called(1);
    });

    test('should throw DioException when POST fails', () async {
      when(() => mockDio.post(
            '/api/beautishops/$tShopId/treatments',
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
            statusCode: 400,
            data: {'message': 'Bad request'},
          ),
        ),
      );

      expect(
        () => dataSource.createTreatment(tShopId, tRequest),
        throwsA(isA<DioException>()),
      );
    });

    test('should throw DioException when unauthorized', () async {
      when(() => mockDio.post(
            '/api/beautishops/$tShopId/treatments',
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      expect(
        () => dataSource.createTreatment(tShopId, tRequest),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('updateTreatment', () {
    const tTreatmentId = 'treatment-uuid';
    const tRequest = UpdateTreatmentRequest(
      name: 'Updated Nail Care',
      price: 60000,
    );

    test('should return TreatmentModel when PUT /api/treatments/{treatmentId} succeeds', () async {
      when(() => mockDio.put(
            '/api/treatments/$tTreatmentId',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
          statusCode: 200,
          data: tTreatmentJson,
        ),
      );

      final result = await dataSource.updateTreatment(tTreatmentId, tRequest);

      expect(result, isA<TreatmentModel>());
      expect(result.id, 'treatment-uuid');
      verify(() => mockDio.put(
            '/api/treatments/$tTreatmentId',
            data: tRequest.toJson(),
          )).called(1);
    });

    test('should throw DioException when treatment not found', () async {
      when(() => mockDio.put(
            '/api/treatments/$tTreatmentId',
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
            statusCode: 404,
            data: {'message': 'Treatment not found'},
          ),
        ),
      );

      expect(
        () => dataSource.updateTreatment(tTreatmentId, tRequest),
        throwsA(isA<DioException>()),
      );
    });

    test('should throw DioException when unauthorized', () async {
      when(() => mockDio.put(
            '/api/treatments/$tTreatmentId',
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      expect(
        () => dataSource.updateTreatment(tTreatmentId, tRequest),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('deleteTreatment', () {
    const tTreatmentId = 'treatment-uuid';

    test('should complete when DELETE /api/treatments/{treatmentId} succeeds', () async {
      when(() => mockDio.delete('/api/treatments/$tTreatmentId')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
          statusCode: 204,
        ),
      );

      await expectLater(
        dataSource.deleteTreatment(tTreatmentId),
        completes,
      );
      verify(() => mockDio.delete('/api/treatments/$tTreatmentId')).called(1);
    });

    test('should throw DioException when treatment not found', () async {
      when(() => mockDio.delete('/api/treatments/$tTreatmentId')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
            statusCode: 404,
            data: {'message': 'Treatment not found'},
          ),
        ),
      );

      expect(
        () => dataSource.deleteTreatment(tTreatmentId),
        throwsA(isA<DioException>()),
      );
    });

    test('should throw DioException when unauthorized', () async {
      when(() => mockDio.delete('/api/treatments/$tTreatmentId')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/treatments/$tTreatmentId'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      expect(
        () => dataSource.deleteTreatment(tTreatmentId),
        throwsA(isA<DioException>()),
      );
    });
  });
}

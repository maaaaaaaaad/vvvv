import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/category/data/datasources/category_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/category/data/models/category_model.dart';
import 'package:jellomark_mobile_owner/features/category/data/models/set_categories_request.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late CategoryRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;
  late MockDio mockDio;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();
    when(() => mockApiClient.dio).thenReturn(mockDio);
    dataSource = CategoryRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(const SetCategoriesRequest(categoryIds: []));
  });

  final tCategoryJson1 = {
    'id': 'cat-uuid-1',
    'name': 'nail',
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-01T00:00:00.000Z',
  };

  final tCategoryJson2 = {
    'id': 'cat-uuid-2',
    'name': 'hair',
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-01T00:00:00.000Z',
  };

  group('getCategories', () {
    test('should return List<CategoryModel> when GET /api/categories succeeds',
        () async {
      when(() => mockDio.get('/api/categories')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/categories'),
          statusCode: 200,
          data: [tCategoryJson1, tCategoryJson2],
        ),
      );

      final result = await dataSource.getCategories();

      expect(result, isA<List<CategoryModel>>());
      expect(result.length, 2);
      expect(result[0].id, 'cat-uuid-1');
      expect(result[0].name, 'nail');
      expect(result[1].id, 'cat-uuid-2');
      expect(result[1].name, 'hair');
      verify(() => mockDio.get('/api/categories')).called(1);
    });

    test('should return empty list when no categories exist', () async {
      when(() => mockDio.get('/api/categories')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/categories'),
          statusCode: 200,
          data: [],
        ),
      );

      final result = await dataSource.getCategories();

      expect(result, isEmpty);
      verify(() => mockDio.get('/api/categories')).called(1);
    });

    test('should throw DioException when GET /api/categories fails', () async {
      when(() => mockDio.get('/api/categories')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/categories'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/categories'),
            statusCode: 500,
            data: {'message': 'Internal server error'},
          ),
        ),
      );

      expect(
        () => dataSource.getCategories(),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('setShopCategories', () {
    const tShopId = 'shop-uuid';
    const tRequest = SetCategoriesRequest(categoryIds: ['cat-uuid-1']);

    test(
        'should return List<CategoryModel> when PUT /api/beautishops/{shopId}/categories succeeds',
        () async {
      when(() => mockDio.put(
            '/api/beautishops/$tShopId/categories',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions:
              RequestOptions(path: '/api/beautishops/$tShopId/categories'),
          statusCode: 200,
          data: [tCategoryJson1],
        ),
      );

      final result = await dataSource.setShopCategories(tShopId, tRequest);

      expect(result, isA<List<CategoryModel>>());
      expect(result.length, 1);
      expect(result[0].id, 'cat-uuid-1');
      verify(() => mockDio.put(
            '/api/beautishops/$tShopId/categories',
            data: tRequest.toJson(),
          )).called(1);
    });

    test('should throw DioException when unauthorized (401)', () async {
      when(() => mockDio.put(
            '/api/beautishops/$tShopId/categories',
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/api/beautishops/$tShopId/categories'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/api/beautishops/$tShopId/categories'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      expect(
        () => dataSource.setShopCategories(tShopId, tRequest),
        throwsA(isA<DioException>()),
      );
    });

    test('should throw DioException when forbidden (403)', () async {
      when(() => mockDio.put(
            '/api/beautishops/$tShopId/categories',
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/api/beautishops/$tShopId/categories'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/api/beautishops/$tShopId/categories'),
            statusCode: 403,
            data: {'message': 'Forbidden'},
          ),
        ),
      );

      expect(
        () => dataSource.setShopCategories(tShopId, tRequest),
        throwsA(isA<DioException>()),
      );
    });

    test('should throw DioException when shop not found (404)', () async {
      when(() => mockDio.put(
            '/api/beautishops/$tShopId/categories',
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/api/beautishops/$tShopId/categories'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/api/beautishops/$tShopId/categories'),
            statusCode: 404,
            data: {'message': 'Shop not found'},
          ),
        ),
      );

      expect(
        () => dataSource.setShopCategories(tShopId, tRequest),
        throwsA(isA<DioException>()),
      );
    });
  });
}

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/datasources/shop_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/beautishop_model.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/create_shop_request.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/update_shop_request.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late ShopRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;
  late MockDio mockDio;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();
    when(() => mockApiClient.dio).thenReturn(mockDio);
    dataSource = ShopRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  setUpAll(() {
    registerFallbackValue(const CreateShopRequest(
      shopName: '',
      shopRegNum: '',
      shopPhoneNumber: '',
      shopAddress: '',
      latitude: 0,
      longitude: 0,
      operatingTime: {},
    ));
    registerFallbackValue(const UpdateShopRequest());
    registerFallbackValue(RequestOptions(path: ''));
  });

  final tShopJson = {
    'id': 'shop-uuid',
    'name': 'Beautiful Nail',
    'regNum': '1234567890',
    'phoneNumber': '02-1234-5678',
    'address': 'Seoul, Gangnam',
    'latitude': 37.5665,
    'longitude': 126.9780,
    'operatingTime': {'MON': '09:00-18:00'},
    'description': 'Best nail shop',
    'image': 'https://example.com/image.jpg',
    'averageRating': 4.5,
    'reviewCount': 10,
    'categories': [
      {'id': 'cat-uuid', 'name': 'nail'},
    ],
    'distance': null,
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-01T00:00:00.000Z',
  };

  group('createShop', () {
    const tRequest = CreateShopRequest(
      shopName: 'Beautiful Nail',
      shopRegNum: '1234567890',
      shopPhoneNumber: '02-1234-5678',
      shopAddress: 'Seoul, Gangnam',
      latitude: 37.5665,
      longitude: 126.9780,
      operatingTime: {'MON': '09:00-18:00'},
      shopDescription: 'Best nail shop',
      shopImage: 'https://example.com/image.jpg',
    );

    test('should return BeautishopModel when POST /api/beautishops succeeds', () async {
      when(() => mockDio.post(
            '/api/beautishops',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/beautishops'),
          statusCode: 201,
          data: tShopJson,
        ),
      );

      final result = await dataSource.createShop(tRequest);

      expect(result, isA<BeautishopModel>());
      expect(result.id, 'shop-uuid');
      expect(result.name, 'Beautiful Nail');
      verify(() => mockDio.post(
            '/api/beautishops',
            data: tRequest.toJson(),
          )).called(1);
    });

    test('should throw DioException when POST /api/beautishops fails', () async {
      when(() => mockDio.post(
            '/api/beautishops',
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops'),
            statusCode: 400,
            data: {'message': 'Bad request'},
          ),
        ),
      );

      expect(
        () => dataSource.createShop(tRequest),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('getShopById', () {
    const tShopId = 'shop-uuid';

    test('should return BeautishopModel when GET /api/beautishops/{id} succeeds', () async {
      when(() => mockDio.get('/api/beautishops/$tShopId')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
          statusCode: 200,
          data: tShopJson,
        ),
      );

      final result = await dataSource.getShopById(tShopId);

      expect(result, isA<BeautishopModel>());
      expect(result.id, 'shop-uuid');
      verify(() => mockDio.get('/api/beautishops/$tShopId')).called(1);
    });

    test('should throw DioException when shop is not found', () async {
      when(() => mockDio.get('/api/beautishops/$tShopId')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
            statusCode: 404,
            data: {'message': 'Shop not found'},
          ),
        ),
      );

      expect(
        () => dataSource.getShopById(tShopId),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('updateShop', () {
    const tShopId = 'shop-uuid';
    const tRequest = UpdateShopRequest(
      shopDescription: 'Updated description',
    );

    test('should return BeautishopModel when PUT /api/beautishops/{id} succeeds', () async {
      when(() => mockDio.put(
            '/api/beautishops/$tShopId',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
          statusCode: 200,
          data: tShopJson,
        ),
      );

      final result = await dataSource.updateShop(tShopId, tRequest);

      expect(result, isA<BeautishopModel>());
      expect(result.id, 'shop-uuid');
      verify(() => mockDio.put(
            '/api/beautishops/$tShopId',
            data: tRequest.toJson(),
          )).called(1);
    });

    test('should throw DioException when unauthorized', () async {
      when(() => mockDio.put(
            '/api/beautishops/$tShopId',
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      expect(
        () => dataSource.updateShop(tShopId, tRequest),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('deleteShop', () {
    const tShopId = 'shop-uuid';

    test('should complete when DELETE /api/beautishops/{id} succeeds', () async {
      when(() => mockDio.delete('/api/beautishops/$tShopId')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
          statusCode: 204,
        ),
      );

      await expectLater(
        dataSource.deleteShop(tShopId),
        completes,
      );
      verify(() => mockDio.delete('/api/beautishops/$tShopId')).called(1);
    });

    test('should throw DioException when unauthorized', () async {
      when(() => mockDio.delete('/api/beautishops/$tShopId')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      expect(
        () => dataSource.deleteShop(tShopId),
        throwsA(isA<DioException>()),
      );
    });

    test('should throw DioException when shop not found', () async {
      when(() => mockDio.delete('/api/beautishops/$tShopId')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
            statusCode: 404,
            data: {'message': 'Shop not found'},
          ),
        ),
      );

      expect(
        () => dataSource.deleteShop(tShopId),
        throwsA(isA<DioException>()),
      );
    });
  });
}

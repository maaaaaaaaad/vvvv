import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/review/data/datasources/review_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/review/data/models/paged_reviews_model.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late ReviewRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;
  late MockDio mockDio;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();
    when(() => mockApiClient.dio).thenReturn(mockDio);
    dataSource = ReviewRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  final tPagedReviewsJson = {
    'reviews': [
      {
        'id': 'review-1',
        'content': '좋은 서비스였습니다',
        'rating': 5,
        'memberNickname': '홍길동',
        'createdAt': '2024-01-15T10:30:00.000Z',
      },
      {
        'id': 'review-2',
        'content': '친절한 서비스',
        'rating': 4,
        'memberNickname': '김철수',
        'createdAt': '2024-01-16T14:00:00.000Z',
      },
    ],
    'totalCount': 100,
    'hasNext': true,
  };

  group('getShopReviews', () {
    const tShopId = 'shop-uuid';
    const tPage = 0;
    const tSize = 10;

    test('should return PagedReviewsModel when GET /api/beautishops/{shopId}/reviews succeeds', () async {
      when(() => mockDio.get(
            '/api/beautishops/$tShopId/reviews',
            queryParameters: {'page': tPage, 'size': tSize},
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
          statusCode: 200,
          data: tPagedReviewsJson,
        ),
      );

      final result = await dataSource.getShopReviews(tShopId, page: tPage, size: tSize);

      expect(result, isA<PagedReviewsModel>());
      expect(result.reviews.length, 2);
      expect(result.reviews[0].id, 'review-1');
      expect(result.reviews[0].content, '좋은 서비스였습니다');
      expect(result.totalCount, 100);
      expect(result.hasNext, true);
      verify(() => mockDio.get(
            '/api/beautishops/$tShopId/reviews',
            queryParameters: {'page': tPage, 'size': tSize},
          )).called(1);
    });

    test('should return PagedReviewsModel with empty reviews when no reviews exist', () async {
      final emptyReviewsJson = {
        'reviews': <Map<String, dynamic>>[],
        'totalCount': 0,
        'hasNext': false,
      };

      when(() => mockDio.get(
            '/api/beautishops/$tShopId/reviews',
            queryParameters: {'page': tPage, 'size': tSize},
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
          statusCode: 200,
          data: emptyReviewsJson,
        ),
      );

      final result = await dataSource.getShopReviews(tShopId, page: tPage, size: tSize);

      expect(result.reviews, isEmpty);
      expect(result.totalCount, 0);
      expect(result.hasNext, false);
    });

    test('should use default page and size values', () async {
      when(() => mockDio.get(
            '/api/beautishops/$tShopId/reviews',
            queryParameters: {'page': 0, 'size': 10},
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
          statusCode: 200,
          data: tPagedReviewsJson,
        ),
      );

      await dataSource.getShopReviews(tShopId);

      verify(() => mockDio.get(
            '/api/beautishops/$tShopId/reviews',
            queryParameters: {'page': 0, 'size': 10},
          )).called(1);
    });

    test('should throw DioException when shop is not found', () async {
      when(() => mockDio.get(
            '/api/beautishops/$tShopId/reviews',
            queryParameters: {'page': tPage, 'size': tSize},
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
            statusCode: 404,
            data: {'message': 'Shop not found'},
          ),
        ),
      );

      expect(
        () => dataSource.getShopReviews(tShopId, page: tPage, size: tSize),
        throwsA(isA<DioException>()),
      );
    });

    test('should throw DioException when server error occurs', () async {
      when(() => mockDio.get(
            '/api/beautishops/$tShopId/reviews',
            queryParameters: {'page': tPage, 'size': tSize},
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
            statusCode: 500,
            data: {'message': 'Internal server error'},
          ),
        ),
      );

      expect(
        () => dataSource.getShopReviews(tShopId, page: tPage, size: tSize),
        throwsA(isA<DioException>()),
      );
    });
  });
}

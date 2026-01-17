import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/home/data/repositories/dashboard_repository_impl.dart';
import 'package:jellomark_mobile_owner/features/home/domain/entities/dashboard_stats.dart';
import 'package:jellomark_mobile_owner/features/review/data/datasources/review_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/review/data/models/paged_reviews_model.dart';
import 'package:jellomark_mobile_owner/features/review/data/models/review_model.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/datasources/treatment_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/treatment_model.dart';
import 'package:mocktail/mocktail.dart';

class MockTreatmentRemoteDataSource extends Mock
    implements TreatmentRemoteDataSource {}

class MockReviewRemoteDataSource extends Mock
    implements ReviewRemoteDataSource {}

void main() {
  late DashboardRepositoryImpl repository;
  late MockTreatmentRemoteDataSource mockTreatmentDataSource;
  late MockReviewRemoteDataSource mockReviewDataSource;

  setUp(() {
    mockTreatmentDataSource = MockTreatmentRemoteDataSource();
    mockReviewDataSource = MockReviewRemoteDataSource();
    repository = DashboardRepositoryImpl(
      treatmentRemoteDataSource: mockTreatmentDataSource,
      reviewRemoteDataSource: mockReviewDataSource,
    );
  });

  const tShopId = 'shop-uuid-123';
  final tCreatedAt = DateTime.parse('2024-01-01T00:00:00Z');
  final tUpdatedAt = DateTime.parse('2024-01-01T00:00:00Z');

  final tTreatments = [
    TreatmentModel(
      id: 'treatment-1',
      name: 'Treatment 1',
      description: 'Description 1',
      price: 10000,
      duration: 30,
      imageUrl: null,
      createdAt: tCreatedAt,
      updatedAt: tUpdatedAt,
    ),
    TreatmentModel(
      id: 'treatment-2',
      name: 'Treatment 2',
      description: 'Description 2',
      price: 20000,
      duration: 60,
      imageUrl: null,
      createdAt: tCreatedAt,
      updatedAt: tUpdatedAt,
    ),
  ];

  final tReviews = [
    ReviewModel(
      id: 'review-1',
      content: 'Great service!',
      rating: 5,
      memberNickname: 'User1',
      createdAt: tCreatedAt,
    ),
    ReviewModel(
      id: 'review-2',
      content: 'Good!',
      rating: 4,
      memberNickname: 'User2',
      createdAt: tCreatedAt,
    ),
    ReviewModel(
      id: 'review-3',
      content: 'Nice!',
      rating: 3,
      memberNickname: 'User3',
      createdAt: tCreatedAt,
    ),
  ];

  final tPagedReviews = PagedReviewsModel(
    reviews: tReviews,
    totalCount: 10,
    hasNext: true,
  );

  group('getDashboardStats', () {
    test(
        'should return DashboardStats when both data source calls are successful',
        () async {
      when(() => mockTreatmentDataSource.getShopTreatments(tShopId))
          .thenAnswer((_) async => tTreatments);
      when(() => mockReviewDataSource.getShopReviews(
            tShopId,
            page: 0,
            size: 3,
          )).thenAnswer((_) async => tPagedReviews);

      final result = await repository.getDashboardStats(tShopId);

      expect(result, isA<Right<Failure, DashboardStats>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (stats) {
          expect(stats.treatmentCount, 2);
          expect(stats.reviewCount, 10);
          expect(stats.averageRating, 4.0);
          expect(stats.recentReviews.length, 3);
        },
      );
      verify(() => mockTreatmentDataSource.getShopTreatments(tShopId)).called(1);
      verify(() =>
              mockReviewDataSource.getShopReviews(tShopId, page: 0, size: 3))
          .called(1);
    });

    test('should return AuthFailure when treatment data source throws 401',
        () async {
      when(() => mockTreatmentDataSource.getShopTreatments(tShopId)).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );
      when(() => mockReviewDataSource.getShopReviews(
            tShopId,
            page: 0,
            size: 3,
          )).thenAnswer((_) async => tPagedReviews);

      final result = await repository.getDashboardStats(tShopId);

      expect(result, isA<Left<Failure, DashboardStats>>());
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'Unauthorized');
        },
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return AuthFailure when review data source throws 401',
        () async {
      when(() => mockTreatmentDataSource.getShopTreatments(tShopId))
          .thenAnswer((_) async => tTreatments);
      when(() => mockReviewDataSource.getShopReviews(
            tShopId,
            page: 0,
            size: 3,
          )).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      final result = await repository.getDashboardStats(tShopId);

      expect(result, isA<Left<Failure, DashboardStats>>());
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'Unauthorized');
        },
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return NotFoundFailure when data source throws 404', () async {
      when(() => mockTreatmentDataSource.getShopTreatments(tShopId)).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
            statusCode: 404,
            data: {'message': 'Shop not found'},
          ),
        ),
      );

      final result = await repository.getDashboardStats(tShopId);

      expect(result, isA<Left<Failure, DashboardStats>>());
      result.fold(
        (failure) {
          expect(failure, isA<NotFoundFailure>());
          expect(failure.message, 'Shop not found');
        },
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when data source throws 500', () async {
      when(() => mockTreatmentDataSource.getShopTreatments(tShopId)).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
            statusCode: 500,
            data: {'message': 'Internal server error'},
          ),
        ),
      );

      final result = await repository.getDashboardStats(tShopId);

      expect(result, isA<Left<Failure, DashboardStats>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Internal server error');
        },
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when unknown exception occurs', () async {
      when(() => mockTreatmentDataSource.getShopTreatments(tShopId))
          .thenThrow(Exception('Unknown error'));

      final result = await repository.getDashboardStats(tShopId);

      expect(result, isA<Left<Failure, DashboardStats>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('알 수 없는 오류'));
        },
        (_) => fail('Expected Left but got Right'),
      );
    });

    test(
        'should return ServerFailure with default message when response data is null',
        () async {
      when(() => mockTreatmentDataSource.getShopTreatments(tShopId)).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/api/beautishops/$tShopId/treatments'),
            statusCode: 500,
            data: null,
          ),
        ),
      );

      final result = await repository.getDashboardStats(tShopId);

      expect(result, isA<Left<Failure, DashboardStats>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, '서버 오류가 발생했습니다');
        },
        (_) => fail('Expected Left but got Right'),
      );
    });
  });
}

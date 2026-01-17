import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/review/data/datasources/review_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/review/data/models/paged_reviews_model.dart';
import 'package:jellomark_mobile_owner/features/review/data/models/review_model.dart';
import 'package:jellomark_mobile_owner/features/review/data/repositories/review_repository_impl.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/paged_reviews.dart';
import 'package:mocktail/mocktail.dart';

class MockReviewRemoteDataSource extends Mock implements ReviewRemoteDataSource {}

void main() {
  late ReviewRepositoryImpl repository;
  late MockReviewRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockReviewRemoteDataSource();
    repository = ReviewRepositoryImpl(remoteDataSource: mockDataSource);
  });

  final tCreatedAt = DateTime.parse('2024-01-15T10:30:00Z');

  final tReviewModel = ReviewModel(
    id: 'review-1',
    content: '좋은 서비스였습니다',
    rating: 5,
    memberNickname: '홍길동',
    createdAt: tCreatedAt,
  );

  final tPagedReviewsModel = PagedReviewsModel(
    reviews: [tReviewModel],
    totalCount: 100,
    hasNext: true,
  );

  group('getShopReviews', () {
    const tShopId = 'shop-uuid';
    const tPage = 0;
    const tSize = 10;

    test('should return PagedReviews when data source call is successful', () async {
      when(() => mockDataSource.getShopReviews(tShopId, page: tPage, size: tSize))
          .thenAnswer((_) async => tPagedReviewsModel);

      final result = await repository.getShopReviews(tShopId, page: tPage, size: tSize);

      expect(result, isA<Right<Failure, PagedReviews>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (pagedReviews) {
          expect(pagedReviews.reviews.length, 1);
          expect(pagedReviews.reviews[0].id, 'review-1');
          expect(pagedReviews.reviews[0].content, '좋은 서비스였습니다');
          expect(pagedReviews.totalCount, 100);
          expect(pagedReviews.hasNext, true);
        },
      );
      verify(() => mockDataSource.getShopReviews(tShopId, page: tPage, size: tSize)).called(1);
    });

    test('should return PagedReviews with empty reviews when no reviews exist', () async {
      final emptyPagedReviewsModel = PagedReviewsModel(
        reviews: const [],
        totalCount: 0,
        hasNext: false,
      );

      when(() => mockDataSource.getShopReviews(tShopId, page: tPage, size: tSize))
          .thenAnswer((_) async => emptyPagedReviewsModel);

      final result = await repository.getShopReviews(tShopId, page: tPage, size: tSize);

      expect(result, isA<Right<Failure, PagedReviews>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (pagedReviews) {
          expect(pagedReviews.reviews, isEmpty);
          expect(pagedReviews.totalCount, 0);
          expect(pagedReviews.hasNext, false);
        },
      );
    });

    test('should return NotFoundFailure when DioException with 404 occurs', () async {
      when(() => mockDataSource.getShopReviews(tShopId, page: tPage, size: tSize)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
            statusCode: 404,
            data: {'message': 'Shop not found'},
          ),
        ),
      );

      final result = await repository.getShopReviews(tShopId, page: tPage, size: tSize);

      expect(result, isA<Left<Failure, PagedReviews>>());
      result.fold(
        (failure) {
          expect(failure, isA<NotFoundFailure>());
          expect(failure.message, 'Shop not found');
        },
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return AuthFailure when DioException with 401 occurs', () async {
      when(() => mockDataSource.getShopReviews(tShopId, page: tPage, size: tSize)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      final result = await repository.getShopReviews(tShopId, page: tPage, size: tSize);

      expect(result, isA<Left<Failure, PagedReviews>>());
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'Unauthorized');
        },
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when DioException with 500 occurs', () async {
      when(() => mockDataSource.getShopReviews(tShopId, page: tPage, size: tSize)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
            statusCode: 500,
            data: {'message': 'Internal server error'},
          ),
        ),
      );

      final result = await repository.getShopReviews(tShopId, page: tPage, size: tSize);

      expect(result, isA<Left<Failure, PagedReviews>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Internal server error');
        },
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when DioException without response occurs', () async {
      when(() => mockDataSource.getShopReviews(tShopId, page: tPage, size: tSize)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId/reviews'),
        ),
      );

      final result = await repository.getShopReviews(tShopId, page: tPage, size: tSize);

      expect(result, isA<Left<Failure, PagedReviews>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when unknown exception occurs', () async {
      when(() => mockDataSource.getShopReviews(tShopId, page: tPage, size: tSize))
          .thenThrow(Exception('Unknown error'));

      final result = await repository.getShopReviews(tShopId, page: tPage, size: tSize);

      expect(result, isA<Left<Failure, PagedReviews>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, '알 수 없는 오류가 발생했습니다');
        },
        (_) => fail('Expected Left but got Right'),
      );
    });
  });
}

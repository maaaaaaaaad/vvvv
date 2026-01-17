import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/paged_reviews.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';
import 'package:jellomark_mobile_owner/features/review/domain/repositories/review_repository.dart';
import 'package:jellomark_mobile_owner/features/review/domain/usecases/get_shop_reviews_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockReviewRepository extends Mock implements ReviewRepository {}

void main() {
  late GetShopReviewsUseCase useCase;
  late MockReviewRepository mockRepository;

  setUp(() {
    mockRepository = MockReviewRepository();
    useCase = GetShopReviewsUseCase(repository: mockRepository);
  });

  const tShopId = 'shop-1';
  const tPage = 0;
  const tSize = 20;

  final tReviews = [
    Review(
      id: 'review-1',
      content: 'Great service!',
      rating: 5,
      memberNickname: 'John',
      createdAt: DateTime(2024, 1, 1),
    ),
    Review(
      id: 'review-2',
      content: 'Good experience',
      rating: 4,
      memberNickname: 'Jane',
      createdAt: DateTime(2024, 1, 2),
    ),
  ];

  final tPagedReviews = PagedReviews(
    reviews: tReviews,
    totalCount: 10,
    hasNext: true,
  );

  group('GetShopReviewsUseCase', () {
    test('should return PagedReviews when successful', () async {
      when(() => mockRepository.getShopReviews(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => Right(tPagedReviews));

      final result = await useCase(
        const GetShopReviewsParams(shopId: tShopId),
      );

      expect(result, Right(tPagedReviews));
      verify(() => mockRepository.getShopReviews(
            tShopId,
            page: tPage,
            size: tSize,
          )).called(1);
    });

    test('should use custom page and size when provided', () async {
      const customPage = 2;
      const customSize = 10;

      when(() => mockRepository.getShopReviews(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => Right(tPagedReviews));

      final result = await useCase(
        const GetShopReviewsParams(
          shopId: tShopId,
          page: customPage,
          size: customSize,
        ),
      );

      expect(result, Right(tPagedReviews));
      verify(() => mockRepository.getShopReviews(
            tShopId,
            page: customPage,
            size: customSize,
          )).called(1);
    });

    test('should return empty PagedReviews when shop has no reviews', () async {
      final emptyPagedReviews = PagedReviews(
        reviews: const [],
        totalCount: 0,
        hasNext: false,
      );

      when(() => mockRepository.getShopReviews(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => Right(emptyPagedReviews));

      final result = await useCase(
        const GetShopReviewsParams(shopId: tShopId),
      );

      expect(result, Right(emptyPagedReviews));
    });

    test('should return ServerFailure when repository fails', () async {
      const tFailure = ServerFailure('Failed to get reviews');
      when(() => mockRepository.getShopReviews(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(
        const GetShopReviewsParams(shopId: tShopId),
      );

      expect(result, const Left(tFailure));
    });

    test('should return NotFoundFailure when shop does not exist', () async {
      const tFailure = NotFoundFailure('Shop not found');
      when(() => mockRepository.getShopReviews(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(
        const GetShopReviewsParams(shopId: 'non-existent-shop'),
      );

      expect(result, const Left(tFailure));
    });
  });

  group('GetShopReviewsParams', () {
    test('should be equal when properties are the same', () {
      const params1 = GetShopReviewsParams(shopId: 'shop-1');
      const params2 = GetShopReviewsParams(shopId: 'shop-1');

      expect(params1, equals(params2));
    });

    test('should not be equal when shopId is different', () {
      const params1 = GetShopReviewsParams(shopId: 'shop-1');
      const params2 = GetShopReviewsParams(shopId: 'shop-2');

      expect(params1, isNot(equals(params2)));
    });

    test('should not be equal when page is different', () {
      const params1 = GetShopReviewsParams(shopId: 'shop-1', page: 0);
      const params2 = GetShopReviewsParams(shopId: 'shop-1', page: 1);

      expect(params1, isNot(equals(params2)));
    });

    test('should not be equal when size is different', () {
      const params1 = GetShopReviewsParams(shopId: 'shop-1', size: 20);
      const params2 = GetShopReviewsParams(shopId: 'shop-1', size: 10);

      expect(params1, isNot(equals(params2)));
    });

    test('props should contain all properties', () {
      const params = GetShopReviewsParams(
        shopId: 'shop-1',
        page: 1,
        size: 10,
      );

      expect(params.props, ['shop-1', 1, 10]);
    });

    test('should use default values for page and size', () {
      const params = GetShopReviewsParams(shopId: 'shop-1');

      expect(params.page, 0);
      expect(params.size, 20);
    });
  });
}

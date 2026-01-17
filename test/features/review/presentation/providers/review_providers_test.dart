import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/paged_reviews.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';
import 'package:jellomark_mobile_owner/features/review/domain/usecases/get_shop_reviews_usecase.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/providers/review_providers.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/providers/review_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetShopReviewsUseCase extends Mock implements GetShopReviewsUseCase {}

void main() {
  late ReviewStateNotifier notifier;
  late MockGetShopReviewsUseCase mockGetShopReviewsUseCase;

  final testReviews = [
    Review(
      id: 'review-1',
      content: '시술이 정말 좋았습니다.',
      rating: 5,
      memberNickname: '김미영',
      createdAt: DateTime(2024, 1, 15),
    ),
    Review(
      id: 'review-2',
      content: '친절하고 결과도 만족스러워요.',
      rating: 4,
      memberNickname: '이수진',
      createdAt: DateTime(2024, 1, 14),
    ),
    Review(
      id: 'review-3',
      content: '괜찮았어요.',
      rating: 3,
      memberNickname: '박지은',
      createdAt: DateTime(2024, 1, 13),
    ),
  ];

  final testPagedReviews = PagedReviews(
    reviews: testReviews,
    totalCount: 10,
    hasNext: true,
  );

  final testPagedReviewsPage2 = PagedReviews(
    reviews: [
      Review(
        id: 'review-4',
        content: '다음 페이지 리뷰',
        rating: 5,
        memberNickname: '최지영',
        createdAt: DateTime(2024, 1, 12),
      ),
    ],
    totalCount: 10,
    hasNext: false,
  );

  setUp(() {
    mockGetShopReviewsUseCase = MockGetShopReviewsUseCase();
    notifier = ReviewStateNotifier(
      getShopReviewsUseCase: mockGetShopReviewsUseCase,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      const GetShopReviewsParams(shopId: 'shop-1'),
    );
  });

  group('ReviewStateNotifier', () {
    group('initial state', () {
      test('should have ReviewInitial as initial state', () {
        expect(notifier.state, const ReviewInitial());
      });
    });

    group('loadReviews', () {
      test('should emit ReviewLoading then ReviewLoaded on success', () async {
        when(() => mockGetShopReviewsUseCase(any()))
            .thenAnswer((_) async => Right(testPagedReviews));

        final states = <ReviewState>[];
        notifier.addListener(states.add);

        await notifier.loadReviews('shop-1');

        expect(states, [
          const ReviewInitial(),
          const ReviewLoading(),
          isA<ReviewLoaded>(),
        ]);

        final loadedState = states.last as ReviewLoaded;
        expect(loadedState.reviews, testReviews);
        expect(loadedState.totalCount, 10);
        expect(loadedState.hasNext, true);
      });

      test('should calculate average rating correctly', () async {
        when(() => mockGetShopReviewsUseCase(any()))
            .thenAnswer((_) async => Right(testPagedReviews));

        await notifier.loadReviews('shop-1');

        final loadedState = notifier.state as ReviewLoaded;
        expect(loadedState.averageRating, equals(4.0));
      });

      test('should set averageRating to 0.0 when reviews are empty', () async {
        when(() => mockGetShopReviewsUseCase(any())).thenAnswer(
          (_) async => const Right(
            PagedReviews(reviews: [], totalCount: 0, hasNext: false),
          ),
        );

        await notifier.loadReviews('shop-1');

        final loadedState = notifier.state as ReviewLoaded;
        expect(loadedState.averageRating, equals(0.0));
        expect(loadedState.reviews, isEmpty);
      });

      test('should emit ReviewLoading then ReviewError on failure', () async {
        when(() => mockGetShopReviewsUseCase(any())).thenAnswer(
          (_) async => const Left(ServerFailure('서버 오류')),
        );

        final states = <ReviewState>[];
        notifier.addListener(states.add);

        await notifier.loadReviews('shop-1');

        expect(states, [
          const ReviewInitial(),
          const ReviewLoading(),
          const ReviewError('서버 오류'),
        ]);
      });

      test('should reset page to 0 when loadReviews is called', () async {
        when(() => mockGetShopReviewsUseCase(any()))
            .thenAnswer((_) async => Right(testPagedReviews));

        await notifier.loadReviews('shop-1');
        await notifier.loadMoreReviews('shop-1');
        await notifier.loadReviews('shop-1');

        verify(() => mockGetShopReviewsUseCase(
              const GetShopReviewsParams(shopId: 'shop-1', page: 0),
            )).called(2);
      });

      test('should call usecase with correct params', () async {
        when(() => mockGetShopReviewsUseCase(any()))
            .thenAnswer((_) async => Right(testPagedReviews));

        await notifier.loadReviews('shop-123');

        verify(() => mockGetShopReviewsUseCase(
              const GetShopReviewsParams(shopId: 'shop-123', page: 0),
            )).called(1);
      });
    });

    group('loadMoreReviews', () {
      test('should not load more if not in ReviewLoaded state', () async {
        await notifier.loadMoreReviews('shop-1');

        verifyNever(() => mockGetShopReviewsUseCase(any()));
      });

      test('should not load more if hasNext is false', () async {
        when(() => mockGetShopReviewsUseCase(any())).thenAnswer(
          (_) async => const Right(
            PagedReviews(reviews: [], totalCount: 0, hasNext: false),
          ),
        );

        await notifier.loadReviews('shop-1');
        await notifier.loadMoreReviews('shop-1');

        verify(() => mockGetShopReviewsUseCase(any())).called(1);
      });

      test('should emit ReviewLoadingMore then ReviewLoadedMore on success',
          () async {
        when(() => mockGetShopReviewsUseCase(any()))
            .thenAnswer((_) async => Right(testPagedReviews));

        await notifier.loadReviews('shop-1');

        when(() => mockGetShopReviewsUseCase(any()))
            .thenAnswer((_) async => Right(testPagedReviewsPage2));

        final states = <ReviewState>[];
        notifier.addListener(states.add);

        await notifier.loadMoreReviews('shop-1');

        expect(states.length, 3);
        expect(states[1], const ReviewLoadingMore());
        expect(states[2], isA<ReviewLoadedMore>());
      });

      test('should append new reviews to existing reviews', () async {
        when(() => mockGetShopReviewsUseCase(any()))
            .thenAnswer((_) async => Right(testPagedReviews));

        await notifier.loadReviews('shop-1');

        when(() => mockGetShopReviewsUseCase(any()))
            .thenAnswer((_) async => Right(testPagedReviewsPage2));

        await notifier.loadMoreReviews('shop-1');

        final loadedMoreState = notifier.state as ReviewLoadedMore;
        expect(loadedMoreState.reviews.length, 4);
        expect(loadedMoreState.reviews[0].id, 'review-1');
        expect(loadedMoreState.reviews[3].id, 'review-4');
      });

      test('should update averageRating based on all reviews', () async {
        when(() => mockGetShopReviewsUseCase(any()))
            .thenAnswer((_) async => Right(testPagedReviews));

        await notifier.loadReviews('shop-1');

        when(() => mockGetShopReviewsUseCase(any()))
            .thenAnswer((_) async => Right(testPagedReviewsPage2));

        await notifier.loadMoreReviews('shop-1');

        final loadedMoreState = notifier.state as ReviewLoadedMore;
        expect(loadedMoreState.averageRating, equals(4.25));
      });

      test('should increment page number on each load more', () async {
        when(() => mockGetShopReviewsUseCase(any()))
            .thenAnswer((_) async => Right(testPagedReviews));

        await notifier.loadReviews('shop-1');

        when(() => mockGetShopReviewsUseCase(any())).thenAnswer(
          (_) async => Right(
            PagedReviews(
              reviews: testPagedReviewsPage2.reviews,
              totalCount: 10,
              hasNext: true,
            ),
          ),
        );

        await notifier.loadMoreReviews('shop-1');

        verify(() => mockGetShopReviewsUseCase(
              const GetShopReviewsParams(shopId: 'shop-1', page: 1),
            )).called(1);

        await notifier.loadMoreReviews('shop-1');

        verify(() => mockGetShopReviewsUseCase(
              const GetShopReviewsParams(shopId: 'shop-1', page: 2),
            )).called(1);
      });

      test('should emit ReviewError on failure during load more', () async {
        when(() => mockGetShopReviewsUseCase(any()))
            .thenAnswer((_) async => Right(testPagedReviews));

        await notifier.loadReviews('shop-1');

        when(() => mockGetShopReviewsUseCase(any())).thenAnswer(
          (_) async => const Left(ServerFailure('네트워크 오류')),
        );

        await notifier.loadMoreReviews('shop-1');

        expect(notifier.state, const ReviewError('네트워크 오류'));
      });
    });
  });
}

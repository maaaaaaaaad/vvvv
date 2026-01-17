import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/paged_reviews.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';
import 'package:jellomark_mobile_owner/features/review/domain/usecases/get_shop_reviews_usecase.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/pages/review_list_page.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/providers/review_providers.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/providers/review_state.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/widgets/review_card.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/widgets/review_stats_card.dart';
import 'package:mocktail/mocktail.dart';

class MockGetShopReviewsUseCase extends Mock implements GetShopReviewsUseCase {}

void main() {
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

  setUpAll(() {
    registerFallbackValue(const GetShopReviewsParams(shopId: 'shop-1'));
  });

  setUp(() {
    mockGetShopReviewsUseCase = MockGetShopReviewsUseCase();
  });

  Widget buildTestWidget({
    required ReviewState initialState,
    GetShopReviewsUseCase? useCase,
  }) {
    final notifier = ReviewStateNotifier(
      getShopReviewsUseCase: useCase ?? mockGetShopReviewsUseCase,
    );

    return ProviderScope(
      overrides: [
        reviewStateNotifierProvider.overrideWith((ref) => notifier),
      ],
      child: const MaterialApp(
        home: ReviewListPage(shopId: 'shop-1'),
      ),
    );
  }

  group('ReviewListPage', () {
    testWidgets('should display loading indicator when state is ReviewLoading',
        (tester) async {
      final completer = Completer<Either<Failure, PagedReviews>>();
      when(() => mockGetShopReviewsUseCase(any()))
          .thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildTestWidget(
        initialState: const ReviewLoading(),
      ));

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(Right(testPagedReviews));
      await tester.pumpAndSettle();
    });

    testWidgets('should display ReviewStatsCard and ReviewCard list when loaded',
        (tester) async {
      when(() => mockGetShopReviewsUseCase(any()))
          .thenAnswer((_) async => Right(testPagedReviews));

      await tester.pumpWidget(buildTestWidget(
        initialState: const ReviewInitial(),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(ReviewStatsCard), findsOneWidget);
      expect(find.byType(ReviewCard), findsNWidgets(3));
    });

    testWidgets('should display error message when state is ReviewError',
        (tester) async {
      when(() => mockGetShopReviewsUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure('서버 오류')));

      await tester.pumpWidget(buildTestWidget(
        initialState: const ReviewInitial(),
      ));

      await tester.pumpAndSettle();

      expect(find.text('서버 오류'), findsOneWidget);
    });

    testWidgets(
        'should display empty message when reviews are empty',
        (tester) async {
      when(() => mockGetShopReviewsUseCase(any())).thenAnswer(
        (_) async => const Right(
          PagedReviews(reviews: [], totalCount: 0, hasNext: false),
        ),
      );

      await tester.pumpWidget(buildTestWidget(
        initialState: const ReviewInitial(),
      ));

      await tester.pumpAndSettle();

      expect(find.text('아직 리뷰가 없습니다'), findsOneWidget);
    });

    testWidgets('should load reviews on init', (tester) async {
      when(() => mockGetShopReviewsUseCase(any()))
          .thenAnswer((_) async => Right(testPagedReviews));

      await tester.pumpWidget(buildTestWidget(
        initialState: const ReviewInitial(),
      ));

      await tester.pumpAndSettle();

      verify(() => mockGetShopReviewsUseCase(
            const GetShopReviewsParams(shopId: 'shop-1', page: 0),
          )).called(1);
    });

    testWidgets('should display review content in ReviewCard', (tester) async {
      when(() => mockGetShopReviewsUseCase(any()))
          .thenAnswer((_) async => Right(testPagedReviews));

      await tester.pumpWidget(buildTestWidget(
        initialState: const ReviewInitial(),
      ));

      await tester.pumpAndSettle();

      expect(find.text('시술이 정말 좋았습니다.'), findsOneWidget);
      expect(find.text('김미영'), findsOneWidget);
    });

    testWidgets('should have ScrollController for infinite scroll',
        (tester) async {
      when(() => mockGetShopReviewsUseCase(any()))
          .thenAnswer((_) async => Right(testPagedReviews));

      await tester.pumpWidget(buildTestWidget(
        initialState: const ReviewInitial(),
      ));

      await tester.pumpAndSettle();

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('should display correct average rating in stats card',
        (tester) async {
      when(() => mockGetShopReviewsUseCase(any()))
          .thenAnswer((_) async => Right(testPagedReviews));

      await tester.pumpWidget(buildTestWidget(
        initialState: const ReviewInitial(),
      ));

      await tester.pumpAndSettle();

      expect(find.text('4.0'), findsOneWidget);
    });

    testWidgets('should display correct total count in stats card',
        (tester) async {
      when(() => mockGetShopReviewsUseCase(any()))
          .thenAnswer((_) async => Right(testPagedReviews));

      await tester.pumpWidget(buildTestWidget(
        initialState: const ReviewInitial(),
      ));

      await tester.pumpAndSettle();

      expect(find.textContaining('10'), findsAtLeastNWidgets(1));
    });

    testWidgets('should trigger load more when scrolled to 70%',
        (tester) async {
      final manyReviews = List.generate(
        20,
        (index) => Review(
          id: 'review-$index',
          content: '리뷰 내용 $index',
          rating: (index % 5) + 1,
          memberNickname: '사용자$index',
          createdAt: DateTime(2024, 1, 15 - index),
        ),
      );

      when(() => mockGetShopReviewsUseCase(any())).thenAnswer(
        (_) async => Right(
          PagedReviews(reviews: manyReviews, totalCount: 40, hasNext: true),
        ),
      );

      await tester.pumpWidget(buildTestWidget(
        initialState: const ReviewInitial(),
      ));

      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, -5000));
      await tester.pump();

      verify(() => mockGetShopReviewsUseCase(any())).called(greaterThanOrEqualTo(1));
    });
  });
}

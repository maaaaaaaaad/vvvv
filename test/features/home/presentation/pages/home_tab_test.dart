import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/home/domain/entities/dashboard_stats.dart';
import 'package:jellomark_mobile_owner/features/home/domain/usecases/get_dashboard_usecase.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/pages/home_tab.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/providers/dashboard_providers.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/widgets/quick_actions_section.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/widgets/recent_reviews_section.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/widgets/stats_card.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDashboardUseCase extends Mock implements GetDashboardUseCase {}

void main() {
  late MockGetDashboardUseCase mockGetDashboardUseCase;

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
      content: '친절하고 좋았어요.',
      rating: 4,
      memberNickname: '이수진',
      createdAt: DateTime(2024, 1, 14),
    ),
    Review(
      id: 'review-3',
      content: '괜찮았습니다.',
      rating: 3,
      memberNickname: '박지은',
      createdAt: DateTime(2024, 1, 13),
    ),
  ];

  final testStats = DashboardStats(
    reviewCount: 10,
    averageRating: 4.5,
    treatmentCount: 5,
    recentReviews: testReviews,
  );

  setUpAll(() {
    registerFallbackValue(const GetDashboardParams(shopId: 'shop-1'));
  });

  setUp(() {
    mockGetDashboardUseCase = MockGetDashboardUseCase();
  });

  Widget buildTestWidget({
    GetDashboardUseCase? useCase,
    VoidCallback? onTreatmentTap,
    VoidCallback? onReviewTap,
  }) {
    final notifier = DashboardStateNotifier(
      getDashboardUseCase: useCase ?? mockGetDashboardUseCase,
    );

    return ProviderScope(
      overrides: [
        dashboardStateNotifierProvider.overrideWith((ref) => notifier),
      ],
      child: MaterialApp(
        home: HomeTab(
          shopId: 'shop-1',
          shopName: '젤로마크 뷰티샵',
          onTreatmentTap: onTreatmentTap ?? () {},
          onReviewTap: onReviewTap ?? () {},
        ),
      ),
    );
  }

  group('HomeTab', () {
    testWidgets('should display loading indicator when state is DashboardLoading',
        (tester) async {
      final completer = Completer<Either<Failure, DashboardStats>>();
      when(() => mockGetDashboardUseCase(any()))
          .thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(Right(testStats));
      await tester.pumpAndSettle();
    });

    testWidgets('should display welcome message with shop name', (tester) async {
      when(() => mockGetDashboardUseCase(any()))
          .thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('젤로마크 뷰티샵'), findsOneWidget);
    });

    testWidgets('should display StatsCard when loaded', (tester) async {
      when(() => mockGetDashboardUseCase(any()))
          .thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(StatsCard), findsOneWidget);
    });

    testWidgets('should display QuickActionsSection when loaded', (tester) async {
      when(() => mockGetDashboardUseCase(any()))
          .thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(QuickActionsSection), findsOneWidget);
    });

    testWidgets('should display RecentReviewsSection when loaded',
        (tester) async {
      when(() => mockGetDashboardUseCase(any()))
          .thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(RecentReviewsSection), findsOneWidget);
    });

    testWidgets('should display error message when state is DashboardError',
        (tester) async {
      when(() => mockGetDashboardUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure('서버 오류')));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('서버 오류'), findsOneWidget);
    });

    testWidgets('should display retry button when error occurs', (tester) async {
      when(() => mockGetDashboardUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure('서버 오류')));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('다시 시도'), findsOneWidget);
    });

    testWidgets('should reload data when retry button is tapped', (tester) async {
      var callCount = 0;
      when(() => mockGetDashboardUseCase(any())).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          return const Left(ServerFailure('서버 오류'));
        }
        return Right(testStats);
      });

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('서버 오류'), findsOneWidget);

      await tester.tap(find.text('다시 시도'));
      await tester.pumpAndSettle();

      expect(find.byType(StatsCard), findsOneWidget);
    });

    testWidgets('should load dashboard on init', (tester) async {
      when(() => mockGetDashboardUseCase(any()))
          .thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      verify(() => mockGetDashboardUseCase(
            const GetDashboardParams(shopId: 'shop-1'),
          )).called(1);
    });

    testWidgets('should call onTreatmentTap when treatment button is tapped',
        (tester) async {
      var tapped = false;
      when(() => mockGetDashboardUseCase(any()))
          .thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(buildTestWidget(
        onTreatmentTap: () => tapped = true,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('시술 관리'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should call onReviewTap when review button is tapped',
        (tester) async {
      var tapped = false;
      when(() => mockGetDashboardUseCase(any()))
          .thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(buildTestWidget(
        onReviewTap: () => tapped = true,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('리뷰 보기'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should support pull to refresh', (tester) async {
      when(() => mockGetDashboardUseCase(any()))
          .thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      await tester.fling(
        find.byType(RefreshIndicator),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      verify(() => mockGetDashboardUseCase(any())).called(greaterThanOrEqualTo(2));
    });

    testWidgets('should display correct stats values', (tester) async {
      when(() => mockGetDashboardUseCase(any()))
          .thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('10'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should display recent reviews', (tester) async {
      when(() => mockGetDashboardUseCase(any()))
          .thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('시술이 정말 좋았습니다.'), findsOneWidget);
      expect(find.text('친절하고 좋았어요.'), findsOneWidget);
      expect(find.text('괜찮았습니다.'), findsOneWidget);
    });
  });
}

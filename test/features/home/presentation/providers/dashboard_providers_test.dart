import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/home/domain/entities/dashboard_stats.dart';
import 'package:jellomark_mobile_owner/features/home/domain/usecases/get_dashboard_usecase.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/providers/dashboard_providers.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/providers/dashboard_state.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDashboardUseCase extends Mock implements GetDashboardUseCase {}

class FakeGetDashboardParams extends Fake implements GetDashboardParams {}

void main() {
  late DashboardStateNotifier notifier;
  late MockGetDashboardUseCase mockGetDashboardUseCase;

  setUpAll(() {
    registerFallbackValue(FakeGetDashboardParams());
  });

  setUp(() {
    mockGetDashboardUseCase = MockGetDashboardUseCase();
    notifier = DashboardStateNotifier(
      getDashboardUseCase: mockGetDashboardUseCase,
    );
  });

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

  group('DashboardStateNotifier', () {
    test('initial state should be DashboardInitial', () {
      expect(notifier.state, const DashboardInitial());
    });
  });

  group('loadDashboard', () {
    test(
      'should emit DashboardLoading then DashboardLoaded when use case returns success',
      () async {
        when(() => mockGetDashboardUseCase(any()))
            .thenAnswer((_) async => Right(testStats));

        expect(notifier.state, const DashboardInitial());

        await notifier.loadDashboard('shop-uuid');

        expect(notifier.state, DashboardLoaded(stats: testStats));
        verify(() => mockGetDashboardUseCase(any())).called(1);
      },
    );

    test(
      'should emit DashboardLoading then DashboardError when use case returns failure',
      () async {
        const tFailure = ServerFailure('서버 오류');
        when(() => mockGetDashboardUseCase(any()))
            .thenAnswer((_) async => const Left(tFailure));

        expect(notifier.state, const DashboardInitial());

        await notifier.loadDashboard('shop-uuid');

        expect(notifier.state, const DashboardError('서버 오류'));
      },
    );

    test(
      'should call use case with correct shopId parameter',
      () async {
        when(() => mockGetDashboardUseCase(any()))
            .thenAnswer((_) async => Right(testStats));

        await notifier.loadDashboard('shop-123');

        final captured = verify(() => mockGetDashboardUseCase(captureAny()))
            .captured
            .single as GetDashboardParams;

        expect(captured.shopId, 'shop-123');
      },
    );
  });

  group('refresh', () {
    test(
      'should emit DashboardLoading then DashboardLoaded when refresh succeeds',
      () async {
        when(() => mockGetDashboardUseCase(any()))
            .thenAnswer((_) async => Right(testStats));

        await notifier.refresh('shop-uuid');

        expect(notifier.state, DashboardLoaded(stats: testStats));
        verify(() => mockGetDashboardUseCase(any())).called(1);
      },
    );

    test(
      'should emit DashboardLoading then DashboardError when refresh fails',
      () async {
        const tFailure = ServerFailure('네트워크 오류');
        when(() => mockGetDashboardUseCase(any()))
            .thenAnswer((_) async => const Left(tFailure));

        await notifier.refresh('shop-uuid');

        expect(notifier.state, const DashboardError('네트워크 오류'));
      },
    );

    test(
      'should reload data even when already loaded',
      () async {
        when(() => mockGetDashboardUseCase(any()))
            .thenAnswer((_) async => Right(testStats));

        await notifier.loadDashboard('shop-uuid');
        expect(notifier.state, isA<DashboardLoaded>());

        final updatedStats = DashboardStats(
          reviewCount: 15,
          averageRating: 4.8,
          treatmentCount: 8,
          recentReviews: testReviews,
        );

        when(() => mockGetDashboardUseCase(any()))
            .thenAnswer((_) async => Right(updatedStats));

        await notifier.refresh('shop-uuid');

        expect(notifier.state, DashboardLoaded(stats: updatedStats));
        verify(() => mockGetDashboardUseCase(any())).called(2);
      },
    );
  });
}

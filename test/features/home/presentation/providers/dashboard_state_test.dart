import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/home/domain/entities/dashboard_stats.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/providers/dashboard_state.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';

void main() {
  final testReviews = [
    Review(
      id: 'review-1',
      content: '시술이 정말 좋았습니다.',
      rating: 5,
      memberNickname: '김미영',
      createdAt: DateTime(2024, 1, 15),
    ),
  ];

  final testStats = DashboardStats(
    reviewCount: 10,
    averageRating: 4.5,
    treatmentCount: 5,
    recentReviews: testReviews,
  );

  group('DashboardState', () {
    group('DashboardInitial', () {
      test('should be an instance of DashboardState', () {
        const state = DashboardInitial();

        expect(state, isA<DashboardState>());
      });

      test('should support value equality', () {
        const state1 = DashboardInitial();
        const state2 = DashboardInitial();

        expect(state1, equals(state2));
      });

      test('should have correct props', () {
        const state = DashboardInitial();

        expect(state.props, isEmpty);
      });
    });

    group('DashboardLoading', () {
      test('should be an instance of DashboardState', () {
        const state = DashboardLoading();

        expect(state, isA<DashboardState>());
      });

      test('should support value equality', () {
        const state1 = DashboardLoading();
        const state2 = DashboardLoading();

        expect(state1, equals(state2));
      });

      test('should have correct props', () {
        const state = DashboardLoading();

        expect(state.props, isEmpty);
      });
    });

    group('DashboardLoaded', () {
      test('should be an instance of DashboardState', () {
        final state = DashboardLoaded(stats: testStats);

        expect(state, isA<DashboardState>());
      });

      test('should contain DashboardStats', () {
        final state = DashboardLoaded(stats: testStats);

        expect(state.stats, equals(testStats));
        expect(state.stats.reviewCount, 10);
        expect(state.stats.averageRating, 4.5);
        expect(state.stats.treatmentCount, 5);
        expect(state.stats.recentReviews, testReviews);
      });

      test('should support value equality', () {
        final state1 = DashboardLoaded(stats: testStats);
        final state2 = DashboardLoaded(stats: testStats);

        expect(state1, equals(state2));
      });

      test('should have correct props', () {
        final state = DashboardLoaded(stats: testStats);

        expect(state.props, [testStats]);
      });
    });

    group('DashboardError', () {
      test('should be an instance of DashboardState', () {
        const state = DashboardError('에러 메시지');

        expect(state, isA<DashboardState>());
      });

      test('should contain error message', () {
        const state = DashboardError('에러 메시지');

        expect(state.message, '에러 메시지');
      });

      test('should support value equality', () {
        const state1 = DashboardError('에러 메시지');
        const state2 = DashboardError('에러 메시지');

        expect(state1, equals(state2));
      });

      test('should not be equal with different messages', () {
        const state1 = DashboardError('에러 메시지 1');
        const state2 = DashboardError('에러 메시지 2');

        expect(state1, isNot(equals(state2)));
      });

      test('should have correct props', () {
        const state = DashboardError('에러 메시지');

        expect(state.props, ['에러 메시지']);
      });
    });
  });
}

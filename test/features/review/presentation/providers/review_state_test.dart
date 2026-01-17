import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/providers/review_state.dart';

void main() {
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

  group('ReviewState', () {
    group('ReviewInitial', () {
      test('should be an instance of ReviewState', () {
        const state = ReviewInitial();
        expect(state, isA<ReviewState>());
      });

      test('should have empty props', () {
        const state = ReviewInitial();
        expect(state.props, isEmpty);
      });

      test('should support equality', () {
        const state1 = ReviewInitial();
        const state2 = ReviewInitial();
        expect(state1, equals(state2));
      });
    });

    group('ReviewLoading', () {
      test('should be an instance of ReviewState', () {
        const state = ReviewLoading();
        expect(state, isA<ReviewState>());
      });

      test('should have empty props', () {
        const state = ReviewLoading();
        expect(state.props, isEmpty);
      });

      test('should support equality', () {
        const state1 = ReviewLoading();
        const state2 = ReviewLoading();
        expect(state1, equals(state2));
      });
    });

    group('ReviewLoaded', () {
      test('should be an instance of ReviewState', () {
        final state = ReviewLoaded(
          reviews: testReviews,
          totalCount: 3,
          hasNext: false,
          averageRating: 4.0,
        );
        expect(state, isA<ReviewState>());
      });

      test('should contain correct properties', () {
        final state = ReviewLoaded(
          reviews: testReviews,
          totalCount: 10,
          hasNext: true,
          averageRating: 4.5,
        );
        expect(state.reviews, equals(testReviews));
        expect(state.totalCount, equals(10));
        expect(state.hasNext, isTrue);
        expect(state.averageRating, equals(4.5));
      });

      test('should have props with all fields', () {
        final state = ReviewLoaded(
          reviews: testReviews,
          totalCount: 3,
          hasNext: false,
          averageRating: 4.0,
        );
        expect(state.props, contains(testReviews));
        expect(state.props, contains(3));
        expect(state.props, contains(false));
        expect(state.props, contains(4.0));
      });

      test('should support equality', () {
        final state1 = ReviewLoaded(
          reviews: testReviews,
          totalCount: 3,
          hasNext: false,
          averageRating: 4.0,
        );
        final state2 = ReviewLoaded(
          reviews: testReviews,
          totalCount: 3,
          hasNext: false,
          averageRating: 4.0,
        );
        expect(state1, equals(state2));
      });

      test('should not be equal when reviews differ', () {
        final state1 = ReviewLoaded(
          reviews: testReviews,
          totalCount: 3,
          hasNext: false,
          averageRating: 4.0,
        );
        final state2 = ReviewLoaded(
          reviews: [],
          totalCount: 3,
          hasNext: false,
          averageRating: 4.0,
        );
        expect(state1, isNot(equals(state2)));
      });

      test('should calculate averageRating as 0.0 when reviews are empty', () {
        const state = ReviewLoaded(
          reviews: [],
          totalCount: 0,
          hasNext: false,
          averageRating: 0.0,
        );
        expect(state.averageRating, equals(0.0));
      });
    });

    group('ReviewLoadingMore', () {
      test('should be an instance of ReviewState', () {
        const state = ReviewLoadingMore();
        expect(state, isA<ReviewState>());
      });

      test('should have empty props', () {
        const state = ReviewLoadingMore();
        expect(state.props, isEmpty);
      });

      test('should support equality', () {
        const state1 = ReviewLoadingMore();
        const state2 = ReviewLoadingMore();
        expect(state1, equals(state2));
      });
    });

    group('ReviewLoadedMore', () {
      test('should be an instance of ReviewState', () {
        final state = ReviewLoadedMore(
          reviews: testReviews,
          totalCount: 10,
          hasNext: true,
          averageRating: 4.0,
        );
        expect(state, isA<ReviewState>());
      });

      test('should contain correct properties', () {
        final state = ReviewLoadedMore(
          reviews: testReviews,
          totalCount: 10,
          hasNext: true,
          averageRating: 4.5,
        );
        expect(state.reviews, equals(testReviews));
        expect(state.totalCount, equals(10));
        expect(state.hasNext, isTrue);
        expect(state.averageRating, equals(4.5));
      });

      test('should have props with all fields', () {
        final state = ReviewLoadedMore(
          reviews: testReviews,
          totalCount: 10,
          hasNext: true,
          averageRating: 4.0,
        );
        expect(state.props, contains(testReviews));
        expect(state.props, contains(10));
        expect(state.props, contains(true));
        expect(state.props, contains(4.0));
      });

      test('should support equality', () {
        final state1 = ReviewLoadedMore(
          reviews: testReviews,
          totalCount: 10,
          hasNext: true,
          averageRating: 4.0,
        );
        final state2 = ReviewLoadedMore(
          reviews: testReviews,
          totalCount: 10,
          hasNext: true,
          averageRating: 4.0,
        );
        expect(state1, equals(state2));
      });
    });

    group('ReviewError', () {
      test('should be an instance of ReviewState', () {
        const state = ReviewError('An error occurred');
        expect(state, isA<ReviewState>());
      });

      test('should contain error message', () {
        const state = ReviewError('Network error');
        expect(state.message, equals('Network error'));
      });

      test('should have props with message', () {
        const state = ReviewError('Server error');
        expect(state.props, contains('Server error'));
      });

      test('should support equality', () {
        const state1 = ReviewError('Same error');
        const state2 = ReviewError('Same error');
        expect(state1, equals(state2));
      });

      test('should not be equal when messages differ', () {
        const state1 = ReviewError('Error 1');
        const state2 = ReviewError('Error 2');
        expect(state1, isNot(equals(state2)));
      });
    });
  });
}

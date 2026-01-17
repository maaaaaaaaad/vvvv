import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/home/domain/entities/dashboard_stats.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';

void main() {
  group('DashboardStats', () {
    final tCreatedAt = DateTime(2024, 1, 1);
    final tReviews = [
      Review(
        id: 'review-1',
        content: 'Great service!',
        rating: 5,
        memberNickname: 'John',
        createdAt: tCreatedAt,
      ),
      Review(
        id: 'review-2',
        content: 'Good experience',
        rating: 4,
        memberNickname: 'Jane',
        createdAt: DateTime(2024, 1, 2),
      ),
    ];

    test('should be equal when all properties are the same', () {
      final stats1 = DashboardStats(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
        recentReviews: tReviews,
      );

      final stats2 = DashboardStats(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
        recentReviews: tReviews,
      );

      expect(stats1, equals(stats2));
    });

    test('should not be equal when reviewCount is different', () {
      final stats1 = DashboardStats(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
        recentReviews: tReviews,
      );

      final stats2 = DashboardStats(
        reviewCount: 20,
        averageRating: 4.5,
        treatmentCount: 5,
        recentReviews: tReviews,
      );

      expect(stats1, isNot(equals(stats2)));
    });

    test('should not be equal when averageRating is different', () {
      final stats1 = DashboardStats(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
        recentReviews: tReviews,
      );

      final stats2 = DashboardStats(
        reviewCount: 10,
        averageRating: 3.5,
        treatmentCount: 5,
        recentReviews: tReviews,
      );

      expect(stats1, isNot(equals(stats2)));
    });

    test('should not be equal when treatmentCount is different', () {
      final stats1 = DashboardStats(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
        recentReviews: tReviews,
      );

      final stats2 = DashboardStats(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 10,
        recentReviews: tReviews,
      );

      expect(stats1, isNot(equals(stats2)));
    });

    test('should not be equal when recentReviews is different', () {
      final stats1 = DashboardStats(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
        recentReviews: tReviews,
      );

      final stats2 = DashboardStats(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
        recentReviews: const [],
      );

      expect(stats1, isNot(equals(stats2)));
    });

    test('props should contain all properties', () {
      final stats = DashboardStats(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
        recentReviews: tReviews,
      );

      expect(stats.props, [
        10,
        4.5,
        5,
        tReviews,
      ]);
    });

    test('should handle empty recentReviews list', () {
      const stats = DashboardStats(
        reviewCount: 0,
        averageRating: 0.0,
        treatmentCount: 0,
        recentReviews: [],
      );

      expect(stats.reviewCount, 0);
      expect(stats.averageRating, 0.0);
      expect(stats.treatmentCount, 0);
      expect(stats.recentReviews, isEmpty);
    });

    test('should handle maximum 3 recent reviews', () {
      final threeReviews = [
        Review(
          id: 'review-1',
          content: 'Review 1',
          rating: 5,
          memberNickname: 'User1',
          createdAt: tCreatedAt,
        ),
        Review(
          id: 'review-2',
          content: 'Review 2',
          rating: 4,
          memberNickname: 'User2',
          createdAt: tCreatedAt,
        ),
        Review(
          id: 'review-3',
          content: 'Review 3',
          rating: 3,
          memberNickname: 'User3',
          createdAt: tCreatedAt,
        ),
      ];

      final stats = DashboardStats(
        reviewCount: 100,
        averageRating: 4.2,
        treatmentCount: 15,
        recentReviews: threeReviews,
      );

      expect(stats.recentReviews.length, 3);
    });
  });
}

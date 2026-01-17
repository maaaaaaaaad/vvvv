import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/home/data/models/dashboard_stats_model.dart';
import 'package:jellomark_mobile_owner/features/home/domain/entities/dashboard_stats.dart';
import 'package:jellomark_mobile_owner/features/review/data/models/paged_reviews_model.dart';
import 'package:jellomark_mobile_owner/features/review/data/models/review_model.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/treatment_model.dart';

void main() {
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

  group('DashboardStatsModel', () {
    test('should be a subclass of DashboardStats entity', () {
      final model = DashboardStatsModel(
        reviewCount: 10,
        averageRating: 4.0,
        treatmentCount: 2,
        recentReviews: const [],
      );

      expect(model, isA<DashboardStats>());
    });

    group('fromData', () {
      test('should create DashboardStatsModel from treatments and reviews data',
          () {
        final result = DashboardStatsModel.fromData(
          treatments: tTreatments,
          reviews: tPagedReviews,
        );

        expect(result.treatmentCount, 2);
        expect(result.reviewCount, 10);
        expect(result.recentReviews.length, 3);
        expect(result.averageRating, 4.0);
      });

      test('should calculate average rating correctly', () {
        final result = DashboardStatsModel.fromData(
          treatments: tTreatments,
          reviews: tPagedReviews,
        );

        expect(result.averageRating, 4.0);
      });

      test('should take only first 3 reviews as recent reviews', () {
        final fourReviews = [
          ...tReviews,
          ReviewModel(
            id: 'review-4',
            content: 'Another review',
            rating: 5,
            memberNickname: 'User4',
            createdAt: tCreatedAt,
          ),
        ];

        final pagedWithFourReviews = PagedReviewsModel(
          reviews: fourReviews,
          totalCount: 15,
          hasNext: true,
        );

        final result = DashboardStatsModel.fromData(
          treatments: tTreatments,
          reviews: pagedWithFourReviews,
        );

        expect(result.recentReviews.length, 3);
        expect(result.recentReviews[0].id, 'review-1');
        expect(result.recentReviews[1].id, 'review-2');
        expect(result.recentReviews[2].id, 'review-3');
      });

      test('should handle empty reviews', () {
        final emptyPagedReviews = const PagedReviewsModel(
          reviews: [],
          totalCount: 0,
          hasNext: false,
        );

        final result = DashboardStatsModel.fromData(
          treatments: tTreatments,
          reviews: emptyPagedReviews,
        );

        expect(result.reviewCount, 0);
        expect(result.averageRating, 0.0);
        expect(result.recentReviews, isEmpty);
      });

      test('should handle empty treatments', () {
        final result = DashboardStatsModel.fromData(
          treatments: const [],
          reviews: tPagedReviews,
        );

        expect(result.treatmentCount, 0);
        expect(result.reviewCount, 10);
      });
    });

    group('toEntity', () {
      test('should convert DashboardStatsModel to DashboardStats entity', () {
        final model = DashboardStatsModel.fromData(
          treatments: tTreatments,
          reviews: tPagedReviews,
        );

        final entity = model.toEntity();

        expect(entity, isA<DashboardStats>());
        expect(entity.treatmentCount, 2);
        expect(entity.reviewCount, 10);
        expect(entity.averageRating, 4.0);
        expect(entity.recentReviews.length, 3);
      });
    });
  });
}

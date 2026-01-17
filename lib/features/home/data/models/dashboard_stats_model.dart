import 'package:jellomark_mobile_owner/features/home/domain/entities/dashboard_stats.dart';
import 'package:jellomark_mobile_owner/features/review/data/models/paged_reviews_model.dart';
import 'package:jellomark_mobile_owner/features/review/data/models/review_model.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/treatment_model.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.reviewCount,
    required super.averageRating,
    required super.treatmentCount,
    required super.recentReviews,
  });

  factory DashboardStatsModel.fromData({
    required List<TreatmentModel> treatments,
    required PagedReviewsModel reviews,
  }) {
    final recentReviews = reviews.reviews.take(3).toList();
    final averageRating = reviews.reviews.isNotEmpty
        ? reviews.reviews
                .map((r) => (r as ReviewModel).rating)
                .reduce((a, b) => a + b) /
            reviews.reviews.length
        : 0.0;

    return DashboardStatsModel(
      reviewCount: reviews.totalCount,
      averageRating: averageRating,
      treatmentCount: treatments.length,
      recentReviews:
          recentReviews.map((r) => (r as ReviewModel).toEntity()).toList(),
    );
  }

  DashboardStats toEntity() {
    return DashboardStats(
      reviewCount: reviewCount,
      averageRating: averageRating,
      treatmentCount: treatmentCount,
      recentReviews: recentReviews,
    );
  }
}

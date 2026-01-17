import 'package:jellomark_mobile_owner/features/review/data/models/review_model.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/paged_reviews.dart';

class PagedReviewsModel extends PagedReviews {
  const PagedReviewsModel({
    required List<ReviewModel> super.reviews,
    required super.totalCount,
    required super.hasNext,
  });

  factory PagedReviewsModel.fromJson(Map<String, dynamic> json) {
    final reviewsJson = json['reviews'] as List<dynamic>;
    final reviews = reviewsJson
        .map((review) => ReviewModel.fromJson(review as Map<String, dynamic>))
        .toList();

    return PagedReviewsModel(
      reviews: reviews,
      totalCount: json['totalCount'] as int,
      hasNext: json['hasNext'] as bool,
    );
  }

  PagedReviews toEntity() {
    return PagedReviews(
      reviews: reviews.map((review) => (review as ReviewModel).toEntity()).toList(),
      totalCount: totalCount,
      hasNext: hasNext,
    );
  }
}

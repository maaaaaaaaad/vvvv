import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';

class DashboardStats extends Equatable {
  final int reviewCount;
  final double averageRating;
  final int treatmentCount;
  final List<Review> recentReviews;

  const DashboardStats({
    required this.reviewCount,
    required this.averageRating,
    required this.treatmentCount,
    required this.recentReviews,
  });

  @override
  List<Object?> get props => [
        reviewCount,
        averageRating,
        treatmentCount,
        recentReviews,
      ];
}

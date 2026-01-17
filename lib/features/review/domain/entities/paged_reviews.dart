import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';

class PagedReviews extends Equatable {
  final List<Review> reviews;
  final int totalCount;
  final bool hasNext;

  const PagedReviews({
    required this.reviews,
    required this.totalCount,
    required this.hasNext,
  });

  @override
  List<Object?> get props => [
        reviews,
        totalCount,
        hasNext,
      ];
}

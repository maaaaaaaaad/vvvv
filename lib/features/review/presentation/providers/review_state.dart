import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';

sealed class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {
  const ReviewInitial();
}

class ReviewLoading extends ReviewState {
  const ReviewLoading();
}

class ReviewLoaded extends ReviewState {
  final List<Review> reviews;
  final int totalCount;
  final bool hasNext;
  final double averageRating;

  const ReviewLoaded({
    required this.reviews,
    required this.totalCount,
    required this.hasNext,
    required this.averageRating,
  });

  @override
  List<Object?> get props => [reviews, totalCount, hasNext, averageRating];
}

class ReviewLoadingMore extends ReviewState {
  const ReviewLoadingMore();
}

class ReviewLoadedMore extends ReviewState {
  final List<Review> reviews;
  final int totalCount;
  final bool hasNext;
  final double averageRating;

  const ReviewLoadedMore({
    required this.reviews,
    required this.totalCount,
    required this.hasNext,
    required this.averageRating,
  });

  @override
  List<Object?> get props => [reviews, totalCount, hasNext, averageRating];
}

class ReviewError extends ReviewState {
  final String message;

  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}

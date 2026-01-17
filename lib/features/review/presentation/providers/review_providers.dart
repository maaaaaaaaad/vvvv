import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/core/di/injection_container.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/review/data/datasources/review_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/review/data/repositories/review_repository_impl.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';
import 'package:jellomark_mobile_owner/features/review/domain/repositories/review_repository.dart';
import 'package:jellomark_mobile_owner/features/review/domain/usecases/get_shop_reviews_usecase.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/providers/review_state.dart';

final reviewRemoteDataSourceProvider = Provider<ReviewRemoteDataSource>((ref) {
  return ReviewRemoteDataSourceImpl(apiClient: sl<ApiClient>());
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(
    remoteDataSource: ref.watch(reviewRemoteDataSourceProvider),
  );
});

final getShopReviewsUseCaseProvider = Provider<GetShopReviewsUseCase>((ref) {
  return GetShopReviewsUseCase(
    repository: ref.watch(reviewRepositoryProvider),
  );
});

final reviewStateNotifierProvider =
    StateNotifierProvider<ReviewStateNotifier, ReviewState>((ref) {
  return ReviewStateNotifier(
    getShopReviewsUseCase: ref.watch(getShopReviewsUseCaseProvider),
  );
});

class ReviewStateNotifier extends StateNotifier<ReviewState> {
  final GetShopReviewsUseCase getShopReviewsUseCase;

  int _currentPage = 0;
  List<Review> _currentReviews = [];
  bool _hasNext = false;

  ReviewStateNotifier({
    required this.getShopReviewsUseCase,
  }) : super(const ReviewInitial());

  Future<void> loadReviews(String shopId) async {
    _currentPage = 0;
    _currentReviews = [];
    state = const ReviewLoading();

    final result = await getShopReviewsUseCase(
      GetShopReviewsParams(shopId: shopId, page: _currentPage),
    );

    result.fold(
      (failure) => state = ReviewError(failure.message),
      (pagedReviews) {
        _currentReviews = pagedReviews.reviews;
        _hasNext = pagedReviews.hasNext;
        state = ReviewLoaded(
          reviews: _currentReviews,
          totalCount: pagedReviews.totalCount,
          hasNext: _hasNext,
          averageRating: _calculateAverageRating(_currentReviews),
        );
      },
    );
  }

  Future<void> loadMoreReviews(String shopId) async {
    if (state is! ReviewLoaded && state is! ReviewLoadedMore) {
      return;
    }

    if (!_hasNext) {
      return;
    }

    state = const ReviewLoadingMore();
    _currentPage++;

    final result = await getShopReviewsUseCase(
      GetShopReviewsParams(shopId: shopId, page: _currentPage),
    );

    result.fold(
      (failure) => state = ReviewError(failure.message),
      (pagedReviews) {
        _currentReviews = [..._currentReviews, ...pagedReviews.reviews];
        _hasNext = pagedReviews.hasNext;
        state = ReviewLoadedMore(
          reviews: _currentReviews,
          totalCount: pagedReviews.totalCount,
          hasNext: _hasNext,
          averageRating: _calculateAverageRating(_currentReviews),
        );
      },
    );
  }

  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) {
      return 0.0;
    }
    final totalRating = reviews.fold<int>(0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }
}

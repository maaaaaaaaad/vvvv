import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/paged_reviews.dart';
import 'package:jellomark_mobile_owner/features/review/domain/repositories/review_repository.dart';

class GetShopReviewsUseCase
    implements UseCase<Either<Failure, PagedReviews>, GetShopReviewsParams> {
  final ReviewRepository repository;

  GetShopReviewsUseCase({required this.repository});

  @override
  Future<Either<Failure, PagedReviews>> call(
    GetShopReviewsParams params,
  ) {
    return repository.getShopReviews(
      params.shopId,
      page: params.page,
      size: params.size,
    );
  }
}

class GetShopReviewsParams extends Equatable {
  final String shopId;
  final int page;
  final int size;

  const GetShopReviewsParams({
    required this.shopId,
    this.page = 0,
    this.size = 20,
  });

  @override
  List<Object?> get props => [shopId, page, size];
}

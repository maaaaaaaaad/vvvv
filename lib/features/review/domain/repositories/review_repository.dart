import 'package:dartz/dartz.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/paged_reviews.dart';

abstract class ReviewRepository {
  Future<Either<Failure, PagedReviews>> getShopReviews(
    String shopId, {
    int page,
    int size,
  });
}

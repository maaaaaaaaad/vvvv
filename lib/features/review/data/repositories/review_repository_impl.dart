import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/review/data/datasources/review_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/paged_reviews.dart';
import 'package:jellomark_mobile_owner/features/review/domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PagedReviews>> getShopReviews(
    String shopId, {
    int page = 0,
    int size = 10,
  }) async {
    try {
      final result = await remoteDataSource.getShopReviews(shopId, page: page, size: size);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return const Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }

  Failure _handleDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data?['message'] ?? '서버 오류가 발생했습니다';

    switch (statusCode) {
      case 401:
        return AuthFailure(message.toString());
      case 404:
        return NotFoundFailure(message.toString());
      default:
        return ServerFailure(message.toString());
    }
  }
}

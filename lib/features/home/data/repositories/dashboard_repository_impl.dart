import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/home/data/models/dashboard_stats_model.dart';
import 'package:jellomark_mobile_owner/features/home/domain/entities/dashboard_stats.dart';
import 'package:jellomark_mobile_owner/features/home/domain/repositories/dashboard_repository.dart';
import 'package:jellomark_mobile_owner/features/review/data/datasources/review_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/datasources/treatment_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final TreatmentRemoteDataSource treatmentRemoteDataSource;
  final ReviewRemoteDataSource reviewRemoteDataSource;

  DashboardRepositoryImpl({
    required this.treatmentRemoteDataSource,
    required this.reviewRemoteDataSource,
  });

  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats(
      String shopId) async {
    try {
      final treatments =
          await treatmentRemoteDataSource.getShopTreatments(shopId);
      final reviews =
          await reviewRemoteDataSource.getShopReviews(shopId, page: 0, size: 3);

      final dashboardStats = DashboardStatsModel.fromData(
        treatments: treatments,
        reviews: reviews,
      );

      return Right(dashboardStats.toEntity());
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

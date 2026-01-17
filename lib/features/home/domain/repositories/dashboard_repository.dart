import 'package:dartz/dartz.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/home/domain/entities/dashboard_stats.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardStats>> getDashboardStats(String shopId);
}

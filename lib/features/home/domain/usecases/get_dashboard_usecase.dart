import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/home/domain/entities/dashboard_stats.dart';
import 'package:jellomark_mobile_owner/features/home/domain/repositories/dashboard_repository.dart';

class GetDashboardUseCase
    implements UseCase<Either<Failure, DashboardStats>, GetDashboardParams> {
  final DashboardRepository repository;

  GetDashboardUseCase({required this.repository});

  @override
  Future<Either<Failure, DashboardStats>> call(GetDashboardParams params) {
    return repository.getDashboardStats(params.shopId);
  }
}

class GetDashboardParams extends Equatable {
  final String shopId;

  const GetDashboardParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

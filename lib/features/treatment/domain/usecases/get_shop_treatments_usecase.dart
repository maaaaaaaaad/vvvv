import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/repositories/treatment_repository.dart';

class GetShopTreatmentsUseCase
    implements UseCase<Either<Failure, List<Treatment>>, GetShopTreatmentsParams> {
  final TreatmentRepository repository;

  GetShopTreatmentsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Treatment>>> call(
    GetShopTreatmentsParams params,
  ) {
    return repository.getShopTreatments(params.shopId);
  }
}

class GetShopTreatmentsParams extends Equatable {
  final String shopId;

  const GetShopTreatmentsParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

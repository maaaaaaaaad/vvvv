import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/repositories/treatment_repository.dart';

class DeleteTreatmentUseCase
    implements UseCase<Either<Failure, Unit>, DeleteTreatmentParams> {
  final TreatmentRepository repository;

  DeleteTreatmentUseCase({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(DeleteTreatmentParams params) {
    return repository.deleteTreatment(params.treatmentId);
  }
}

class DeleteTreatmentParams extends Equatable {
  final String treatmentId;

  const DeleteTreatmentParams({required this.treatmentId});

  @override
  List<Object?> get props => [treatmentId];
}

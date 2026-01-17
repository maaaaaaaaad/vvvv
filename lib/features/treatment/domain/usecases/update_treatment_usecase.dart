import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/repositories/treatment_repository.dart';

class UpdateTreatmentUseCase
    implements UseCase<Either<Failure, Treatment>, UpdateTreatmentParams> {
  final TreatmentRepository repository;

  UpdateTreatmentUseCase({required this.repository});

  @override
  Future<Either<Failure, Treatment>> call(UpdateTreatmentParams params) {
    return repository.updateTreatment(
      treatmentId: params.treatmentId,
      name: params.name,
      description: params.description,
      price: params.price,
      duration: params.duration,
      imageUrl: params.imageUrl,
    );
  }
}

class UpdateTreatmentParams extends Equatable {
  final String treatmentId;
  final String? name;
  final String? description;
  final int? price;
  final int? duration;
  final String? imageUrl;

  const UpdateTreatmentParams({
    required this.treatmentId,
    this.name,
    this.description,
    this.price,
    this.duration,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        treatmentId,
        name,
        description,
        price,
        duration,
        imageUrl,
      ];
}

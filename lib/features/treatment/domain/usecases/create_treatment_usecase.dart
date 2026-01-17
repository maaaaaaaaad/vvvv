import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/repositories/treatment_repository.dart';

class CreateTreatmentUseCase
    implements UseCase<Either<Failure, Treatment>, CreateTreatmentParams> {
  final TreatmentRepository repository;

  CreateTreatmentUseCase({required this.repository});

  @override
  Future<Either<Failure, Treatment>> call(CreateTreatmentParams params) {
    return repository.createTreatment(
      shopId: params.shopId,
      name: params.name,
      description: params.description,
      price: params.price,
      duration: params.duration,
      imageUrl: params.imageUrl,
    );
  }
}

class CreateTreatmentParams extends Equatable {
  final String shopId;
  final String name;
  final String? description;
  final int price;
  final int duration;
  final String? imageUrl;

  const CreateTreatmentParams({
    required this.shopId,
    required this.name,
    this.description,
    required this.price,
    required this.duration,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        shopId,
        name,
        description,
        price,
        duration,
        imageUrl,
      ];
}

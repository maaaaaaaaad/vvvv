import 'package:dartz/dartz.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';

abstract class TreatmentRepository {
  Future<Either<Failure, List<Treatment>>> getShopTreatments(String shopId);

  Future<Either<Failure, Treatment>> getTreatmentById(String treatmentId);

  Future<Either<Failure, Treatment>> createTreatment({
    required String shopId,
    required String name,
    String? description,
    required int price,
    required int duration,
    String? imageUrl,
  });

  Future<Either<Failure, Treatment>> updateTreatment({
    required String treatmentId,
    String? name,
    String? description,
    int? price,
    int? duration,
    String? imageUrl,
  });

  Future<Either<Failure, Unit>> deleteTreatment(String treatmentId);
}

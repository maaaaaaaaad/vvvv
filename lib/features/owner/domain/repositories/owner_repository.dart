import 'package:dartz/dartz.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';

abstract class OwnerRepository {
  Future<Either<Failure, Owner>> getCurrentOwner();
}

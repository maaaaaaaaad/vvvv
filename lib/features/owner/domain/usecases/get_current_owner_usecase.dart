import 'package:dartz/dartz.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/features/owner/domain/repositories/owner_repository.dart';

class GetCurrentOwnerUseCase implements UseCase<Either<Failure, Owner>, NoParams> {
  final OwnerRepository repository;

  GetCurrentOwnerUseCase({required this.repository});

  @override
  Future<Either<Failure, Owner>> call(NoParams params) {
    return repository.getCurrentOwner();
  }
}

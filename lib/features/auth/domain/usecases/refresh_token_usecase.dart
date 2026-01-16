import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/token_pair.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/repositories/auth_repository.dart';

class RefreshTokenUseCase
    implements UseCase<Either<Failure, TokenPair>, RefreshTokenParams> {
  final AuthRepository repository;

  RefreshTokenUseCase({required this.repository});

  @override
  Future<Either<Failure, TokenPair>> call(RefreshTokenParams params) {
    return repository.refreshToken(
      refreshToken: params.refreshToken,
    );
  }
}

class RefreshTokenParams extends Equatable {
  final String refreshToken;

  const RefreshTokenParams({
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [refreshToken];
}

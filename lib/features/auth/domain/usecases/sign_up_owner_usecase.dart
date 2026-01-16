import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/auth_result.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/repositories/auth_repository.dart';

class SignUpOwnerUseCase implements UseCase<Either<Failure, AuthResult>, SignUpParams> {
  final AuthRepository repository;

  SignUpOwnerUseCase({required this.repository});

  @override
  Future<Either<Failure, AuthResult>> call(SignUpParams params) {
    return repository.signUp(
      businessNumber: params.businessNumber,
      phoneNumber: params.phoneNumber,
      nickname: params.nickname,
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpParams extends Equatable {
  final String businessNumber;
  final String phoneNumber;
  final String nickname;
  final String email;
  final String password;

  const SignUpParams({
    required this.businessNumber,
    required this.phoneNumber,
    required this.nickname,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [businessNumber, phoneNumber, nickname, email, password];
}

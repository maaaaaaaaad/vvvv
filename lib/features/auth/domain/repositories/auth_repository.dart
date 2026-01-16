import 'package:dartz/dartz.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/auth_result.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResult>> signUp({
    required String businessNumber,
    required String phoneNumber,
    required String nickname,
    required String email,
    required String password,
  });
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/sign_up_request.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/auth_result.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthResult>> signUp({
    required String businessNumber,
    required String phoneNumber,
    required String nickname,
    required String email,
    required String password,
  }) async {
    try {
      final request = SignUpRequest(
        businessNumber: businessNumber,
        phoneNumber: phoneNumber,
        nickname: nickname,
        email: email,
        password: password,
      );
      final response = await remoteDataSource.signUp(request);
      return Right(response.toAuthResult());
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? '서버 오류가 발생했습니다';
      return Left(ServerFailure(message.toString()));
    } catch (e) {
      return Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }
}

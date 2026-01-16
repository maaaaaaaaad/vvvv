import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/storage/secure_token_storage.dart';
import 'package:jellomark_mobile_owner/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/login_request.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/sign_up_request.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/auth_result.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/token_pair.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureTokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

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

  @override
  Future<Either<Failure, AuthResult>> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await remoteDataSource.login(request);
      return Right(response.toAuthResult());
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data?['message'] ?? '서버 오류가 발생했습니다';
      if (statusCode == 401) {
        return Left(AuthFailure(message.toString()));
      }
      return Left(ServerFailure(message.toString()));
    } catch (e) {
      return Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      final accessToken = await tokenStorage.getAccessToken();
      if (accessToken == null) {
        return const Left(NoTokenFailure());
      }
      await remoteDataSource.logout(accessToken);
      return const Right(unit);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data?['message'] ?? '서버 오류가 발생했습니다';
      if (statusCode == 401) {
        return Left(AuthFailure(message.toString()));
      }
      return Left(ServerFailure(message.toString()));
    } catch (e) {
      return Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, TokenPair>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final response = await remoteDataSource.refreshToken(refreshToken);
      return Right(response.toEntity());
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data?['message'] ?? '서버 오류가 발생했습니다';
      if (statusCode == 401) {
        return Left(AuthFailure(message.toString()));
      }
      return Left(ServerFailure(message.toString()));
    } catch (e) {
      return Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }
}

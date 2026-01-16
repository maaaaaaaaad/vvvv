import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/features/owner/data/datasources/owner_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/owner/domain/repositories/owner_repository.dart';

class OwnerRepositoryImpl implements OwnerRepository {
  final OwnerRemoteDataSource remoteDataSource;

  OwnerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Owner>> getCurrentOwner() async {
    try {
      final ownerModel = await remoteDataSource.getCurrentOwner();
      return Right(ownerModel);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data?['message'] ?? '서버 오류가 발생했습니다';
      if (statusCode == 401) {
        return Left(AuthFailure(message.toString()));
      }
      return Left(ServerFailure(message.toString()));
    } catch (e) {
      return Left(const ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }
}

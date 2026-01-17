import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/datasources/treatment_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/create_treatment_request.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/update_treatment_request.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/repositories/treatment_repository.dart';

class TreatmentRepositoryImpl implements TreatmentRepository {
  final TreatmentRemoteDataSource remoteDataSource;

  TreatmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Treatment>>> getShopTreatments(String shopId) async {
    try {
      final result = await remoteDataSource.getShopTreatments(shopId);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return const Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, Treatment>> getTreatmentById(String treatmentId) async {
    try {
      final result = await remoteDataSource.getTreatmentById(treatmentId);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return const Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, Treatment>> createTreatment({
    required String shopId,
    required String name,
    String? description,
    required int price,
    required int duration,
    String? imageUrl,
  }) async {
    try {
      final request = CreateTreatmentRequest(
        name: name,
        description: description,
        price: price,
        duration: duration,
        imageUrl: imageUrl,
      );
      final result = await remoteDataSource.createTreatment(shopId, request);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return const Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, Treatment>> updateTreatment({
    required String treatmentId,
    String? name,
    String? description,
    int? price,
    int? duration,
    String? imageUrl,
  }) async {
    try {
      final request = UpdateTreatmentRequest(
        name: name,
        description: description,
        price: price,
        duration: duration,
        imageUrl: imageUrl,
      );
      final result = await remoteDataSource.updateTreatment(treatmentId, request);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return const Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTreatment(String treatmentId) async {
    try {
      await remoteDataSource.deleteTreatment(treatmentId);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return const Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }

  Failure _handleDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data?['message'] ?? '서버 오류가 발생했습니다';

    switch (statusCode) {
      case 401:
        return AuthFailure(message.toString());
      case 404:
        return NotFoundFailure(message.toString());
      default:
        return ServerFailure(message.toString());
    }
  }
}

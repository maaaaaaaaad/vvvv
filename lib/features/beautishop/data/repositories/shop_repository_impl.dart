import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/storage/secure_token_storage.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/datasources/shop_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/create_shop_request.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/update_shop_request.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/repositories/shop_repository.dart';

class ShopRepositoryImpl implements ShopRepository {
  static const String _myShopIdKey = 'my_shop_id';

  final ShopRemoteDataSource remoteDataSource;
  final SecureStorageWrapper secureStorage;

  ShopRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<Either<Failure, Beautishop>> createShop({
    required String shopName,
    required String shopRegNum,
    required String shopPhoneNumber,
    required String shopAddress,
    required double latitude,
    required double longitude,
    required Map<String, String> operatingTime,
    String? shopDescription,
    String? shopImage,
  }) async {
    try {
      final request = CreateShopRequest(
        shopName: shopName,
        shopRegNum: shopRegNum,
        shopPhoneNumber: shopPhoneNumber,
        shopAddress: shopAddress,
        latitude: latitude,
        longitude: longitude,
        operatingTime: operatingTime,
        shopDescription: shopDescription,
        shopImage: shopImage,
      );
      final result = await remoteDataSource.createShop(request);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return const Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, Beautishop>> getShopById(String shopId) async {
    try {
      final result = await remoteDataSource.getShopById(shopId);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return const Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, Beautishop>> updateShop({
    required String shopId,
    Map<String, String>? operatingTime,
    String? shopDescription,
    String? shopImage,
  }) async {
    try {
      final request = UpdateShopRequest(
        operatingTime: operatingTime,
        shopDescription: shopDescription,
        shopImage: shopImage,
      );
      final result = await remoteDataSource.updateShop(shopId, request);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return const Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteShop(String shopId) async {
    try {
      await remoteDataSource.deleteShop(shopId);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return const Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, String?>> getMyShopId() async {
    try {
      final shopId = await secureStorage.read(key: _myShopIdKey);
      return Right(shopId);
    } catch (e) {
      return const Left(CacheFailure('저장소 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveMyShopId(String shopId) async {
    try {
      await secureStorage.write(key: _myShopIdKey, value: shopId);
      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure('저장소 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearMyShopId() async {
    try {
      await secureStorage.delete(key: _myShopIdKey);
      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure('저장소 오류가 발생했습니다'));
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

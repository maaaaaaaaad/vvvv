import 'package:dartz/dartz.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';

abstract class ShopRepository {
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
  });

  Future<Either<Failure, Beautishop>> getShopById(String shopId);

  Future<Either<Failure, Beautishop>> updateShop({
    required String shopId,
    Map<String, String>? operatingTime,
    String? shopDescription,
    String? shopImage,
  });

  Future<Either<Failure, Unit>> deleteShop(String shopId);

  Future<Either<Failure, String?>> getMyShopId();

  Future<Either<Failure, Unit>> saveMyShopId(String shopId);

  Future<Either<Failure, Unit>> clearMyShopId();
}

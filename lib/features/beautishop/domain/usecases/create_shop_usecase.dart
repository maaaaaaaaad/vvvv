import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/repositories/shop_repository.dart';

class CreateShopUseCase
    implements UseCase<Either<Failure, Beautishop>, CreateShopParams> {
  final ShopRepository repository;

  CreateShopUseCase({required this.repository});

  @override
  Future<Either<Failure, Beautishop>> call(CreateShopParams params) async {
    final result = await repository.createShop(
      shopName: params.shopName,
      shopRegNum: params.shopRegNum,
      shopPhoneNumber: params.shopPhoneNumber,
      shopAddress: params.shopAddress,
      latitude: params.latitude,
      longitude: params.longitude,
      operatingTime: params.operatingTime,
      shopDescription: params.shopDescription,
      shopImage: params.shopImage,
    );

    return result.fold(
      (failure) => Left(failure),
      (shop) async {
        await repository.saveMyShopId(shop.id);
        return Right(shop);
      },
    );
  }
}

class CreateShopParams extends Equatable {
  final String shopName;
  final String shopRegNum;
  final String shopPhoneNumber;
  final String shopAddress;
  final double latitude;
  final double longitude;
  final Map<String, String> operatingTime;
  final String? shopDescription;
  final String? shopImage;

  const CreateShopParams({
    required this.shopName,
    required this.shopRegNum,
    required this.shopPhoneNumber,
    required this.shopAddress,
    required this.latitude,
    required this.longitude,
    required this.operatingTime,
    this.shopDescription,
    this.shopImage,
  });

  @override
  List<Object?> get props => [
        shopName,
        shopRegNum,
        shopPhoneNumber,
        shopAddress,
        latitude,
        longitude,
        operatingTime,
        shopDescription,
        shopImage,
      ];
}

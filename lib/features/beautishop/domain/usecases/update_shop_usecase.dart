import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/repositories/shop_repository.dart';

class UpdateShopUseCase
    implements UseCase<Either<Failure, Beautishop>, UpdateShopParams> {
  final ShopRepository repository;

  UpdateShopUseCase({required this.repository});

  @override
  Future<Either<Failure, Beautishop>> call(UpdateShopParams params) {
    return repository.updateShop(
      shopId: params.shopId,
      operatingTime: params.operatingTime,
      shopDescription: params.shopDescription,
      shopImage: params.shopImage,
    );
  }
}

class UpdateShopParams extends Equatable {
  final String shopId;
  final Map<String, String>? operatingTime;
  final String? shopDescription;
  final String? shopImage;

  const UpdateShopParams({
    required this.shopId,
    this.operatingTime,
    this.shopDescription,
    this.shopImage,
  });

  @override
  List<Object?> get props => [
        shopId,
        operatingTime,
        shopDescription,
        shopImage,
      ];
}

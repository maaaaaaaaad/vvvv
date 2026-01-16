import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/repositories/shop_repository.dart';

class GetShopByIdUseCase
    implements UseCase<Either<Failure, Beautishop>, GetShopByIdParams> {
  final ShopRepository repository;

  GetShopByIdUseCase({required this.repository});

  @override
  Future<Either<Failure, Beautishop>> call(GetShopByIdParams params) {
    return repository.getShopById(params.shopId);
  }
}

class GetShopByIdParams extends Equatable {
  final String shopId;

  const GetShopByIdParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

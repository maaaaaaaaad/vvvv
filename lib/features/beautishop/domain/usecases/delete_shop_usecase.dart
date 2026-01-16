import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/repositories/shop_repository.dart';

class DeleteShopUseCase
    implements UseCase<Either<Failure, Unit>, DeleteShopParams> {
  final ShopRepository repository;

  DeleteShopUseCase({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(DeleteShopParams params) async {
    final result = await repository.deleteShop(params.shopId);

    return result.fold(
      (failure) => Left(failure),
      (_) async {
        await repository.clearMyShopId();
        return const Right(unit);
      },
    );
  }
}

class DeleteShopParams extends Equatable {
  final String shopId;

  const DeleteShopParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

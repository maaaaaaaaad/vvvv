import 'package:dartz/dartz.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/repositories/shop_repository.dart';

class GetMyShopUseCase
    implements UseCase<Either<Failure, Beautishop?>, NoParams> {
  final ShopRepository repository;

  GetMyShopUseCase({required this.repository});

  @override
  Future<Either<Failure, Beautishop?>> call(NoParams params) async {
    final shopIdResult = await repository.getMyShopId();

    return shopIdResult.fold(
      (failure) => Left(failure),
      (shopId) async {
        if (shopId == null) {
          return const Right(null);
        }
        return repository.getShopById(shopId);
      },
    );
  }
}

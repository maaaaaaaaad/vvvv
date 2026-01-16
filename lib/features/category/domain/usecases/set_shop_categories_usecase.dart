import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';
import 'package:jellomark_mobile_owner/features/category/domain/repositories/category_repository.dart';

class SetShopCategoriesParams extends Equatable {
  final String shopId;
  final List<String> categoryIds;

  const SetShopCategoriesParams({
    required this.shopId,
    required this.categoryIds,
  });

  @override
  List<Object?> get props => [shopId, categoryIds];
}

class SetShopCategoriesUseCase
    implements
        UseCase<Either<Failure, List<Category>>, SetShopCategoriesParams> {
  final CategoryRepository repository;

  SetShopCategoriesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Category>>> call(
      SetShopCategoriesParams params) {
    return repository.setShopCategories(
      shopId: params.shopId,
      categoryIds: params.categoryIds,
    );
  }
}

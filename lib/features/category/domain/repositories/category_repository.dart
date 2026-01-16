import 'package:dartz/dartz.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, List<Category>>> setShopCategories({
    required String shopId,
    required List<String> categoryIds,
  });
}

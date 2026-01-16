import 'package:dartz/dartz.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';
import 'package:jellomark_mobile_owner/features/category/domain/repositories/category_repository.dart';

class GetCategoriesUseCase
    implements UseCase<Either<Failure, List<Category>>, NoParams> {
  final CategoryRepository repository;

  GetCategoriesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) {
    return repository.getCategories();
  }
}

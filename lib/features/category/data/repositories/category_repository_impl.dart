import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/category/data/datasources/category_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/category/data/models/set_categories_request.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';
import 'package:jellomark_mobile_owner/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final result = await remoteDataSource.getCategories();
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return const Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> setShopCategories({
    required String shopId,
    required List<String> categoryIds,
  }) async {
    try {
      final request = SetCategoriesRequest(categoryIds: categoryIds);
      final result = await remoteDataSource.setShopCategories(shopId, request);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return const Left(ServerFailure('알 수 없는 오류가 발생했습니다'));
    }
  }

  Failure _handleDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data?['message'] ?? '서버 오류가 발생했습니다';

    switch (statusCode) {
      case 401:
        return AuthFailure(message.toString());
      case 403:
        return ForbiddenFailure(message.toString());
      case 404:
        return NotFoundFailure(message.toString());
      default:
        return ServerFailure(message.toString());
    }
  }
}

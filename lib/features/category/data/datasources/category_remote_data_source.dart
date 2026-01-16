import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/category/data/models/category_model.dart';
import 'package:jellomark_mobile_owner/features/category/data/models/set_categories_request.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<List<CategoryModel>> setShopCategories(
    String shopId,
    SetCategoriesRequest request,
  );
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiClient apiClient;

  CategoryRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.dio.get('/api/categories');
    final list = response.data as List;
    return list
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CategoryModel>> setShopCategories(
    String shopId,
    SetCategoriesRequest request,
  ) async {
    final response = await apiClient.dio.put(
      '/api/beautishops/$shopId/categories',
      data: request.toJson(),
    );
    final list = response.data as List;
    return list
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

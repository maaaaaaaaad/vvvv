import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/beautishop_model.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/create_shop_request.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/update_shop_request.dart';

abstract class ShopRemoteDataSource {
  Future<BeautishopModel> createShop(CreateShopRequest request);

  Future<BeautishopModel> getShopById(String shopId);

  Future<BeautishopModel> updateShop(String shopId, UpdateShopRequest request);

  Future<void> deleteShop(String shopId);
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  final ApiClient apiClient;

  ShopRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<BeautishopModel> createShop(CreateShopRequest request) async {
    final response = await apiClient.dio.post(
      '/api/beautishops',
      data: request.toJson(),
    );
    return BeautishopModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<BeautishopModel> getShopById(String shopId) async {
    final response = await apiClient.dio.get('/api/beautishops/$shopId');
    return BeautishopModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<BeautishopModel> updateShop(
    String shopId,
    UpdateShopRequest request,
  ) async {
    final response = await apiClient.dio.put(
      '/api/beautishops/$shopId',
      data: request.toJson(),
    );
    return BeautishopModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteShop(String shopId) async {
    await apiClient.dio.delete('/api/beautishops/$shopId');
  }
}

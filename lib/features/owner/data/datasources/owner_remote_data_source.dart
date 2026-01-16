import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/owner_model.dart';

abstract class OwnerRemoteDataSource {
  Future<OwnerModel> getCurrentOwner();
}

class OwnerRemoteDataSourceImpl implements OwnerRemoteDataSource {
  final ApiClient apiClient;

  OwnerRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OwnerModel> getCurrentOwner() async {
    final response = await apiClient.dio.get('/api/owners/me');
    return OwnerModel.fromJson(response.data as Map<String, dynamic>);
  }
}

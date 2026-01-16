import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/sign_up_request.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/sign_up_response.dart';

abstract class AuthRemoteDataSource {
  Future<SignUpResponse> signUp(SignUpRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SignUpResponse> signUp(SignUpRequest request) async {
    final response = await apiClient.dio.post(
      '/api/sign-up/owner',
      data: request.toJson(),
    );
    return SignUpResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

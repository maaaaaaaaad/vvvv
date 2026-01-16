import 'package:dio/dio.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/login_request.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/login_response.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/sign_up_request.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/sign_up_response.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/token_pair_model.dart';

abstract class AuthRemoteDataSource {
  Future<SignUpResponse> signUp(SignUpRequest request);

  Future<LoginResponse> login(LoginRequest request);

  Future<void> logout(String accessToken);

  Future<TokenPairModel> refreshToken(String refreshToken);
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

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await apiClient.dio.post(
      '/api/auth/authenticate',
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> logout(String accessToken) async {
    await apiClient.dio.post(
      '/api/auth/logout',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  @override
  Future<TokenPairModel> refreshToken(String refreshToken) async {
    final response = await apiClient.dio.post(
      '/api/auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    return TokenPairModel.fromJson(response.data as Map<String, dynamic>);
  }
}

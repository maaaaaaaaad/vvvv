import 'package:jellomark_mobile_owner/features/auth/data/models/owner_model.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/auth_result.dart';

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final OwnerModel owner;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.owner,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      owner: OwnerModel.fromJson(json['owner'] as Map<String, dynamic>),
    );
  }

  AuthResult toAuthResult() {
    return AuthResult(
      owner: owner,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

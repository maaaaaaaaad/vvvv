import 'package:jellomark_mobile_owner/features/auth/data/models/owner_model.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/auth_result.dart';

class SignUpResponse {
  final String id;
  final String userType;
  final String nickname;
  final String email;
  final String businessNumber;
  final String phoneNumber;
  final String createdAt;
  final String updatedAt;
  final String accessToken;
  final String refreshToken;

  const SignUpResponse({
    required this.id,
    required this.userType,
    required this.nickname,
    required this.email,
    required this.businessNumber,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.accessToken,
    required this.refreshToken,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      id: json['id'] as String,
      userType: json['userType'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      businessNumber: json['businessNumber'] as String,
      phoneNumber: json['phoneNumber'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  AuthResult toAuthResult() {
    return AuthResult(
      owner: OwnerModel(
        id: id,
        nickname: nickname,
        email: email,
        businessNumber: businessNumber,
        phoneNumber: phoneNumber,
        createdAt: DateTime.parse(createdAt),
        updatedAt: DateTime.parse(updatedAt),
      ),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

import 'package:jellomark_mobile_owner/features/auth/domain/entities/token_pair.dart';

class TokenPairModel {
  final String accessToken;
  final String refreshToken;

  const TokenPairModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokenPairModel.fromJson(Map<String, dynamic> json) {
    return TokenPairModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  TokenPair toEntity() {
    return TokenPair(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

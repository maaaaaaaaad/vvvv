import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';

class AuthResult extends Equatable {
  final Owner owner;
  final String accessToken;
  final String refreshToken;

  const AuthResult({
    required this.owner,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [owner, accessToken, refreshToken];
}

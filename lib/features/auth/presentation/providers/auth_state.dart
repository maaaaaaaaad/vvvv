import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final Owner owner;
  final String accessToken;
  final String refreshToken;

  const AuthAuthenticated({
    required this.owner,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [owner, accessToken, refreshToken];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

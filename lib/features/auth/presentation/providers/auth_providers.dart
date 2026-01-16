import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/core/di/injection_container.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/repositories/auth_repository.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/sign_up_owner_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/providers/auth_state.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(apiClient: sl<ApiClient>());
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(remoteDataSource: ref.watch(authRemoteDataSourceProvider));
});

final signUpOwnerUseCaseProvider = Provider<SignUpOwnerUseCase>((ref) {
  return SignUpOwnerUseCase(repository: ref.watch(authRepositoryProvider));
});

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(
    signUpOwnerUseCase: ref.watch(signUpOwnerUseCaseProvider),
  );
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final SignUpOwnerUseCase signUpOwnerUseCase;

  AuthStateNotifier({required this.signUpOwnerUseCase}) : super(const AuthInitial());

  Future<void> signUp({
    required String businessNumber,
    required String phoneNumber,
    required String nickname,
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();

    final result = await signUpOwnerUseCase(
      SignUpParams(
        businessNumber: businessNumber,
        phoneNumber: phoneNumber,
        nickname: nickname,
        email: email,
        password: password,
      ),
    );

    result.fold(
      (failure) => state = AuthError(failure.message),
      (authResult) => state = AuthAuthenticated(
        owner: authResult.owner,
        accessToken: authResult.accessToken,
        refreshToken: authResult.refreshToken,
      ),
    );
  }
}

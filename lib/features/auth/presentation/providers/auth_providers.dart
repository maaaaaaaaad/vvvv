import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/core/di/injection_container.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/core/storage/secure_token_storage.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/repositories/auth_repository.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/login_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/logout_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/sign_up_owner_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/providers/auth_state.dart';

final secureTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  return SecureTokenStorage(secureStorage: sl<SecureStorageWrapper>());
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(apiClient: sl<ApiClient>());
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    tokenStorage: ref.watch(secureTokenStorageProvider),
  );
});

final signUpOwnerUseCaseProvider = Provider<SignUpOwnerUseCase>((ref) {
  return SignUpOwnerUseCase(repository: ref.watch(authRepositoryProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(repository: ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(repository: ref.watch(authRepositoryProvider));
});

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(
    signUpOwnerUseCase: ref.watch(signUpOwnerUseCaseProvider),
    loginUseCase: ref.watch(loginUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    tokenStorage: ref.watch(secureTokenStorageProvider),
  );
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final SignUpOwnerUseCase signUpOwnerUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final SecureTokenStorage tokenStorage;

  AuthStateNotifier({
    required this.signUpOwnerUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.tokenStorage,
  }) : super(const AuthInitial());

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

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();

    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );

    await result.fold(
      (failure) async => state = AuthError(failure.message),
      (authResult) async {
        await tokenStorage.saveAccessToken(authResult.accessToken);
        await tokenStorage.saveRefreshToken(authResult.refreshToken);
        state = AuthAuthenticated(
          owner: authResult.owner,
          accessToken: authResult.accessToken,
          refreshToken: authResult.refreshToken,
        );
      },
    );
  }

  Future<void> logout() async {
    await logoutUseCase(NoParams());
    await tokenStorage.clearTokens();
    state = const AuthUnauthenticated();
  }

  Future<void> checkAuthStatus() async {
    final accessToken = await tokenStorage.getAccessToken();

    if (accessToken == null) {
      state = const AuthUnauthenticated();
      return;
    }

    final refreshToken = await tokenStorage.getRefreshToken();

    state = AuthAuthenticated(
      owner: Owner(
        id: '',
        nickname: '',
        email: '',
        businessNumber: '',
        phoneNumber: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      accessToken: accessToken,
      refreshToken: refreshToken ?? '',
    );
  }
}

import 'package:get_it/get_it.dart';
import 'package:jellomark_mobile_owner/config/env_config.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/core/network/auth_interceptor.dart';
import 'package:jellomark_mobile_owner/core/storage/secure_token_storage.dart';

final sl = GetIt.instance;

bool _initialized = false;

Future<void> initDependencies() async {
  if (_initialized) {
    return;
  }

  sl.registerLazySingleton<SecureStorageWrapper>(
    () => FlutterSecureStorageWrapper(),
  );

  sl.registerLazySingleton<TokenProvider>(
    () => SecureTokenStorage(secureStorage: sl<SecureStorageWrapper>()),
  );

  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(tokenProvider: sl<TokenProvider>()),
  );

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: EnvConfig.apiBaseUrl,
      authInterceptor: sl<AuthInterceptor>(),
    ),
  );

  _initialized = true;
}

void resetForTest() {
  sl.reset();
  _initialized = false;
}

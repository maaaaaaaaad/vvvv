import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/storage/secure_token_storage.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/auth_result.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/login_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/logout_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/sign_up_owner_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/providers/auth_providers.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/providers/auth_state.dart';
import 'package:mocktail/mocktail.dart';

class MockSignUpOwnerUseCase extends Mock implements SignUpOwnerUseCase {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockSecureTokenStorage extends Mock implements SecureTokenStorage {}

class FakeLoginParams extends Fake implements LoginParams {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late AuthStateNotifier notifier;
  late MockSignUpOwnerUseCase mockSignUpOwnerUseCase;
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockSecureTokenStorage mockTokenStorage;

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockSignUpOwnerUseCase = MockSignUpOwnerUseCase();
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockTokenStorage = MockSecureTokenStorage();
    notifier = AuthStateNotifier(
      signUpOwnerUseCase: mockSignUpOwnerUseCase,
      loginUseCase: mockLoginUseCase,
      logoutUseCase: mockLogoutUseCase,
      tokenStorage: mockTokenStorage,
    );
  });

  final tOwner = Owner(
    id: 'test-uuid',
    nickname: 'testshop',
    email: 'owner@example.com',
    businessNumber: '1234567890',
    phoneNumber: '010-1234-5678',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final tAuthResult = AuthResult(
    owner: tOwner,
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
  );

  group('login', () {
    const tEmail = 'owner@example.com';
    const tPassword = 'Password123!';

    test(
      'should emit AuthLoading then AuthAuthenticated when login succeeds',
      () async {
        when(
          () => mockLoginUseCase(any()),
        ).thenAnswer((_) async => Right(tAuthResult));
        when(
          () => mockTokenStorage.saveAccessToken(any()),
        ).thenAnswer((_) async {});
        when(
          () => mockTokenStorage.saveRefreshToken(any()),
        ).thenAnswer((_) async {});

        expect(notifier.state, const AuthInitial());

        await notifier.login(email: tEmail, password: tPassword);

        expect(
          notifier.state,
          AuthAuthenticated(
            owner: tOwner,
            accessToken: 'access-token',
            refreshToken: 'refresh-token',
          ),
        );

        verify(
          () => mockLoginUseCase(
            const LoginParams(email: tEmail, password: tPassword),
          ),
        ).called(1);
        verify(
          () => mockTokenStorage.saveAccessToken('access-token'),
        ).called(1);
        verify(
          () => mockTokenStorage.saveRefreshToken('refresh-token'),
        ).called(1);
      },
    );

    test('should emit AuthLoading then AuthError when login fails', () async {
      const tFailure = AuthFailure('Invalid credentials');
      when(
        () => mockLoginUseCase(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      expect(notifier.state, const AuthInitial());

      await notifier.login(email: tEmail, password: tPassword);

      expect(notifier.state, const AuthError('Invalid credentials'));
    });
  });

  group('logout', () {
    test(
      'should emit AuthUnauthenticated and clear tokens when logout succeeds',
      () async {
        when(
          () => mockLogoutUseCase(any()),
        ).thenAnswer((_) async => const Right(unit));
        when(() => mockTokenStorage.clearTokens()).thenAnswer((_) async {});

        await notifier.logout();

        expect(notifier.state, const AuthUnauthenticated());
        verify(() => mockTokenStorage.clearTokens()).called(1);
      },
    );

    test(
      'should emit AuthUnauthenticated even when logout API fails',
      () async {
        const tFailure = ServerFailure('Server error');
        when(
          () => mockLogoutUseCase(any()),
        ).thenAnswer((_) async => const Left(tFailure));
        when(() => mockTokenStorage.clearTokens()).thenAnswer((_) async {});

        await notifier.logout();

        expect(notifier.state, const AuthUnauthenticated());
        verify(() => mockTokenStorage.clearTokens()).called(1);
      },
    );
  });

  group('checkAuthStatus', () {
    test(
      'should emit AuthUnauthenticated when no access token is stored',
      () async {
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => null);

        await notifier.checkAuthStatus();

        expect(notifier.state, const AuthUnauthenticated());
      },
    );

    test(
      'should emit AuthAuthenticated with minimal owner when access token exists',
      () async {
        when(
          () => mockTokenStorage.getAccessToken(),
        ).thenAnswer((_) async => 'stored-access-token');
        when(
          () => mockTokenStorage.getRefreshToken(),
        ).thenAnswer((_) async => 'stored-refresh-token');

        await notifier.checkAuthStatus();

        expect(notifier.state, isA<AuthAuthenticated>());
        final authenticatedState = notifier.state as AuthAuthenticated;
        expect(authenticatedState.accessToken, 'stored-access-token');
        expect(authenticatedState.refreshToken, 'stored-refresh-token');
      },
    );
  });
}

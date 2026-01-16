import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/storage/secure_token_storage.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/login_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/logout_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/sign_up_owner_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/pages/splash_page.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/providers/auth_providers.dart';
import 'package:mocktail/mocktail.dart';

class MockSignUpOwnerUseCase extends Mock implements SignUpOwnerUseCase {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockSecureTokenStorage extends Mock implements SecureTokenStorage {}

class FakeLoginParams extends Fake implements LoginParams {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
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
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        authStateProvider.overrideWith((ref) {
          return AuthStateNotifier(
            signUpOwnerUseCase: mockSignUpOwnerUseCase,
            loginUseCase: mockLoginUseCase,
            logoutUseCase: mockLogoutUseCase,
            tokenStorage: mockTokenStorage,
          );
        }),
      ],
      child: MaterialApp(
        home: const SplashPage(),
        routes: {
          '/login': (context) => const Scaffold(body: Text('Login Page')),
          '/main': (context) => const Scaffold(body: Text('Main Page')),
        },
      ),
    );
  }

  group('SplashPage', () {
    testWidgets('should display app logo and name', (tester) async {
      when(() => mockTokenStorage.getAccessToken())
          .thenAnswer((_) async => null);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('젤로마크'), findsOneWidget);
      expect(find.text('사장님'), findsOneWidget);
    });

    testWidgets('should navigate to login page when no token is stored',
        (tester) async {
      when(() => mockTokenStorage.getAccessToken())
          .thenAnswer((_) async => null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
    });

    testWidgets('should navigate to main page when token exists',
        (tester) async {
      when(() => mockTokenStorage.getAccessToken())
          .thenAnswer((_) async => 'stored-access-token');
      when(() => mockTokenStorage.getRefreshToken())
          .thenAnswer((_) async => 'stored-refresh-token');

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Main Page'), findsOneWidget);
    });
  });
}

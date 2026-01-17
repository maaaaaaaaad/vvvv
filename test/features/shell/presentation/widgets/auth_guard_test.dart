import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/storage/secure_token_storage.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/login_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/logout_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/sign_up_owner_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/providers/auth_providers.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/providers/auth_state.dart';
import 'package:jellomark_mobile_owner/features/shell/presentation/widgets/auth_guard.dart';
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

  Widget createTestWidget({
    required AuthState initialState,
    String loginRoute = '/login',
    Widget child = const Text('Protected Content'),
  }) {
    return ProviderScope(
      overrides: [
        authStateProvider.overrideWith((ref) {
          final notifier = AuthStateNotifier(
            signUpOwnerUseCase: mockSignUpOwnerUseCase,
            loginUseCase: mockLoginUseCase,
            logoutUseCase: mockLogoutUseCase,
            tokenStorage: mockTokenStorage,
          );
          notifier.setStateForTesting(initialState);
          return notifier;
        }),
      ],
      child: MaterialApp(
        home: AuthGuard(
          loginRoute: loginRoute,
          child: Scaffold(body: child),
        ),
        routes: {
          '/login': (context) => const Scaffold(body: Text('Login Page')),
          '/custom-login': (context) =>
              const Scaffold(body: Text('Custom Login Page')),
        },
      ),
    );
  }

  final tOwner = Owner(
    id: 'test-uuid',
    nickname: 'testshop',
    email: 'owner@example.com',
    businessNumber: '1234567890',
    phoneNumber: '010-1234-5678',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  group('AuthGuard', () {
    group('when AuthInitial', () {
      testWidgets('should show loading indicator', (tester) async {
        await tester.pumpWidget(createTestWidget(
          initialState: const AuthInitial(),
        ));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Protected Content'), findsNothing);
      });
    });

    group('when AuthLoading', () {
      testWidgets('should show loading indicator', (tester) async {
        await tester.pumpWidget(createTestWidget(
          initialState: const AuthLoading(),
        ));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Protected Content'), findsNothing);
      });
    });

    group('when AuthAuthenticated', () {
      testWidgets('should show child widget', (tester) async {
        await tester.pumpWidget(createTestWidget(
          initialState: AuthAuthenticated(
            owner: tOwner,
            accessToken: 'access-token',
            refreshToken: 'refresh-token',
          ),
        ));

        expect(find.text('Protected Content'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });
    });

    group('when AuthUnauthenticated', () {
      testWidgets('should navigate to login page', (tester) async {
        await tester.pumpWidget(createTestWidget(
          initialState: const AuthUnauthenticated(),
        ));
        await tester.pumpAndSettle();

        expect(find.text('Login Page'), findsOneWidget);
        expect(find.text('Protected Content'), findsNothing);
      });

      testWidgets('should navigate to custom login route when specified',
          (tester) async {
        await tester.pumpWidget(createTestWidget(
          initialState: const AuthUnauthenticated(),
          loginRoute: '/custom-login',
        ));
        await tester.pumpAndSettle();

        expect(find.text('Custom Login Page'), findsOneWidget);
        expect(find.text('Protected Content'), findsNothing);
      });
    });

    group('when AuthError', () {
      testWidgets('should show error icon', (tester) async {
        await tester.pumpWidget(createTestWidget(
          initialState: const AuthError('Authentication failed'),
        ));

        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('should show error message', (tester) async {
        await tester.pumpWidget(createTestWidget(
          initialState: const AuthError('Authentication failed'),
        ));

        expect(find.text('Authentication failed'), findsOneWidget);
      });

      testWidgets('should show retry button', (tester) async {
        await tester.pumpWidget(createTestWidget(
          initialState: const AuthError('Authentication failed'),
        ));

        expect(find.text('다시 시도'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should not show child widget when error', (tester) async {
        await tester.pumpWidget(createTestWidget(
          initialState: const AuthError('Authentication failed'),
        ));

        expect(find.text('Protected Content'), findsNothing);
      });
    });

    group('retry functionality', () {
      testWidgets('should trigger auth check when retry button is pressed',
          (tester) async {
        when(() => mockTokenStorage.getAccessToken())
            .thenAnswer((_) async => 'stored-access-token');
        when(() => mockTokenStorage.getRefreshToken())
            .thenAnswer((_) async => 'stored-refresh-token');

        await tester.pumpWidget(createTestWidget(
          initialState: const AuthError('Authentication failed'),
        ));

        expect(find.text('다시 시도'), findsOneWidget);

        await tester.tap(find.text('다시 시도'));
        await tester.pumpAndSettle();

        verify(() => mockTokenStorage.getAccessToken()).called(1);
      });
    });
  });
}

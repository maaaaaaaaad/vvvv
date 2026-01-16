import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/storage/secure_token_storage.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/auth_result.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/login_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/logout_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/sign_up_owner_usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/presentation/pages/login_page.dart';
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
        home: const LoginPage(),
        routes: {
          '/sign-up': (context) => const Scaffold(body: Text('SignUp Page')),
        },
      ),
    );
  }

  group('LoginPage', () {
    testWidgets('should display login form with email and password fields',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('사장님 로그인'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('로그인'), findsOneWidget);
      expect(find.text('회원가입'), findsOneWidget);
    });

    testWidgets('should show validation error when email is empty',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('로그인'));
      await tester.pumpAndSettle();

      expect(find.text('이메일을 입력해주세요'), findsOneWidget);
    });

    testWidgets('should show validation error when email format is invalid',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.byType(TextFormField).first,
        'invalid-email',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'Password123!',
      );
      await tester.tap(find.text('로그인'));
      await tester.pumpAndSettle();

      expect(find.text('올바른 이메일 형식을 입력해주세요'), findsOneWidget);
    });

    testWidgets('should show validation error when password is empty',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.tap(find.text('로그인'));
      await tester.pumpAndSettle();

      expect(find.text('비밀번호를 입력해주세요'), findsAtLeast(1));
    });

    testWidgets('should call login when form is valid', (tester) async {
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => Right(tAuthResult));
      when(() => mockTokenStorage.saveAccessToken(any()))
          .thenAnswer((_) async {});
      when(() => mockTokenStorage.saveRefreshToken(any()))
          .thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'Password123!',
      );
      await tester.tap(find.text('로그인'));
      await tester.pump();

      verify(() => mockLoginUseCase(
            const LoginParams(
              email: 'test@example.com',
              password: 'Password123!',
            ),
          )).called(1);
    });

    testWidgets('should show loading indicator when login is in progress',
        (tester) async {
      final completer = Completer<Either<Failure, AuthResult>>();
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) => completer.future);
      when(() => mockTokenStorage.saveAccessToken(any()))
          .thenAnswer((_) async {});
      when(() => mockTokenStorage.saveRefreshToken(any()))
          .thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'Password123!',
      );
      await tester.tap(find.text('로그인'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(Right(tAuthResult));
      await tester.pumpAndSettle();
    });

    testWidgets('should show error snackbar when login fails', (tester) async {
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => const Left(AuthFailure('Invalid credentials')));

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'Password123!',
      );
      await tester.tap(find.text('로그인'));
      await tester.pumpAndSettle();

      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('should navigate to sign up page when link is tapped',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('회원가입'));
      await tester.pumpAndSettle();

      expect(find.text('SignUp Page'), findsOneWidget);
    });

    testWidgets('should dismiss keyboard when tapping outside', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byType(TextFormField).first);
      await tester.pump();

      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
    });
  });
}

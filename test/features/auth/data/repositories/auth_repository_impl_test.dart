import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/storage/secure_token_storage.dart';
import 'package:jellomark_mobile_owner/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/login_request.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/login_response.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/owner_model.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/sign_up_request.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/sign_up_response.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/token_pair_model.dart';
import 'package:jellomark_mobile_owner/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/auth_result.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/token_pair.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockSecureTokenStorage extends Mock implements SecureTokenStorage {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockDataSource;
  late MockSecureTokenStorage mockTokenStorage;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    mockTokenStorage = MockSecureTokenStorage();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockDataSource,
      tokenStorage: mockTokenStorage,
    );
  });

  setUpAll(() {
    registerFallbackValue(const SignUpRequest(
      businessNumber: '',
      phoneNumber: '',
      nickname: '',
      email: '',
      password: '',
    ));
    registerFallbackValue(const LoginRequest(
      email: '',
      password: '',
    ));
  });

  group('signUp', () {
    const tBusinessNumber = '123456789';
    const tPhoneNumber = '010-1234-5678';
    const tNickname = 'testshop';
    const tEmail = 'owner@example.com';
    const tPassword = 'Password123!';

    const tSignUpResponse = SignUpResponse(
      id: 'test-uuid',
      userType: 'OWNER',
      nickname: tNickname,
      email: tEmail,
      businessNumber: tBusinessNumber,
      phoneNumber: tPhoneNumber,
      createdAt: '2024-01-01T00:00:00Z',
      updatedAt: '2024-01-01T00:00:00Z',
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
    );

    test('should return AuthResult when the call to remote data source is successful',
        () async {
      when(() => mockDataSource.signUp(any())).thenAnswer((_) async => tSignUpResponse);

      final result = await repository.signUp(
        businessNumber: tBusinessNumber,
        phoneNumber: tPhoneNumber,
        nickname: tNickname,
        email: tEmail,
        password: tPassword,
      );

      expect(result, isA<Right<Failure, AuthResult>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (authResult) {
          expect(authResult.owner.id, 'test-uuid');
          expect(authResult.owner.nickname, tNickname);
          expect(authResult.accessToken, 'access-token');
        },
      );
      verify(() => mockDataSource.signUp(any())).called(1);
    });

    test('should return ServerFailure when DioException occurs', () async {
      when(() => mockDataSource.signUp(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/sign-up/owner'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/sign-up/owner'),
            statusCode: 400,
            data: {'message': 'Bad request'},
          ),
        ),
      );

      final result = await repository.signUp(
        businessNumber: tBusinessNumber,
        phoneNumber: tPhoneNumber,
        nickname: tNickname,
        email: tEmail,
        password: tPassword,
      );

      expect(result, isA<Left<Failure, AuthResult>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when unknown exception occurs', () async {
      when(() => mockDataSource.signUp(any())).thenThrow(Exception('Unknown error'));

      final result = await repository.signUp(
        businessNumber: tBusinessNumber,
        phoneNumber: tPhoneNumber,
        nickname: tNickname,
        email: tEmail,
        password: tPassword,
      );

      expect(result, isA<Left<Failure, AuthResult>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('login', () {
    const tEmail = 'owner@example.com';
    const tPassword = 'Password123!';

    final tOwnerModel = OwnerModel(
      id: 'owner-uuid',
      nickname: 'testshop',
      email: tEmail,
      businessNumber: '123456789',
      phoneNumber: '010-1234-5678',
      createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
      updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
    );

    final tLoginResponse = LoginResponse(
      accessToken: 'access-token-123',
      refreshToken: 'refresh-token-456',
      owner: tOwnerModel,
    );

    test('should return AuthResult when login is successful', () async {
      when(() => mockDataSource.login(any())).thenAnswer((_) async => tLoginResponse);

      final result = await repository.login(
        email: tEmail,
        password: tPassword,
      );

      expect(result, isA<Right<Failure, AuthResult>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (authResult) {
          expect(authResult.owner.id, 'owner-uuid');
          expect(authResult.owner.email, tEmail);
          expect(authResult.accessToken, 'access-token-123');
          expect(authResult.refreshToken, 'refresh-token-456');
        },
      );
      verify(() => mockDataSource.login(any())).called(1);
    });

    test('should return AuthFailure when DioException with 401 occurs', () async {
      when(() => mockDataSource.login(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/auth/authenticate'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/auth/authenticate'),
            statusCode: 401,
            data: {'message': 'Invalid credentials'},
          ),
        ),
      );

      final result = await repository.login(
        email: tEmail,
        password: tPassword,
      );

      expect(result, isA<Left<Failure, AuthResult>>());
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'Invalid credentials');
        },
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when DioException with other status occurs', () async {
      when(() => mockDataSource.login(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/auth/authenticate'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/auth/authenticate'),
            statusCode: 500,
            data: {'message': 'Internal server error'},
          ),
        ),
      );

      final result = await repository.login(
        email: tEmail,
        password: tPassword,
      );

      expect(result, isA<Left<Failure, AuthResult>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when unknown exception occurs', () async {
      when(() => mockDataSource.login(any())).thenThrow(Exception('Unknown error'));

      final result = await repository.login(
        email: tEmail,
        password: tPassword,
      );

      expect(result, isA<Left<Failure, AuthResult>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('logout', () {
    const tAccessToken = 'access-token-123';

    test('should return Right(unit) when logout is successful', () async {
      when(() => mockTokenStorage.getAccessToken())
          .thenAnswer((_) async => tAccessToken);
      when(() => mockDataSource.logout(tAccessToken)).thenAnswer((_) async => {});

      final result = await repository.logout();

      expect(result, isA<Right<Failure, Unit>>());
      verify(() => mockTokenStorage.getAccessToken()).called(1);
      verify(() => mockDataSource.logout(tAccessToken)).called(1);
    });

    test('should return NoTokenFailure when no access token is stored', () async {
      when(() => mockTokenStorage.getAccessToken()).thenAnswer((_) async => null);

      final result = await repository.logout();

      expect(result, isA<Left<Failure, Unit>>());
      result.fold(
        (failure) => expect(failure, isA<NoTokenFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
      verify(() => mockTokenStorage.getAccessToken()).called(1);
      verifyNever(() => mockDataSource.logout(any()));
    });

    test('should return AuthFailure when DioException with 401 occurs', () async {
      when(() => mockTokenStorage.getAccessToken())
          .thenAnswer((_) async => tAccessToken);
      when(() => mockDataSource.logout(tAccessToken)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/auth/logout'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/auth/logout'),
            statusCode: 401,
            data: {'message': 'Invalid token'},
          ),
        ),
      );

      final result = await repository.logout();

      expect(result, isA<Left<Failure, Unit>>());
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when unknown exception occurs', () async {
      when(() => mockTokenStorage.getAccessToken())
          .thenAnswer((_) async => tAccessToken);
      when(() => mockDataSource.logout(tAccessToken))
          .thenThrow(Exception('Unknown error'));

      final result = await repository.logout();

      expect(result, isA<Left<Failure, Unit>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('refreshToken', () {
    const tRefreshToken = 'refresh-token-456';
    const tTokenPairModel = TokenPairModel(
      accessToken: 'new-access-token',
      refreshToken: 'new-refresh-token',
    );

    test('should return TokenPair when refresh is successful', () async {
      when(() => mockDataSource.refreshToken(tRefreshToken))
          .thenAnswer((_) async => tTokenPairModel);

      final result = await repository.refreshToken(refreshToken: tRefreshToken);

      expect(result, isA<Right<Failure, TokenPair>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (tokenPair) {
          expect(tokenPair.accessToken, 'new-access-token');
          expect(tokenPair.refreshToken, 'new-refresh-token');
        },
      );
      verify(() => mockDataSource.refreshToken(tRefreshToken)).called(1);
    });

    test('should return AuthFailure when DioException with 401 occurs', () async {
      when(() => mockDataSource.refreshToken(tRefreshToken)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/auth/refresh'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/auth/refresh'),
            statusCode: 401,
            data: {'message': 'Invalid refresh token'},
          ),
        ),
      );

      final result = await repository.refreshToken(refreshToken: tRefreshToken);

      expect(result, isA<Left<Failure, TokenPair>>());
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when unknown exception occurs', () async {
      when(() => mockDataSource.refreshToken(tRefreshToken))
          .thenThrow(Exception('Unknown error'));

      final result = await repository.refreshToken(refreshToken: tRefreshToken);

      expect(result, isA<Left<Failure, TokenPair>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/sign_up_request.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/sign_up_response.dart';
import 'package:jellomark_mobile_owner/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/auth_result.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(remoteDataSource: mockDataSource);
  });

  setUpAll(() {
    registerFallbackValue(const SignUpRequest(
      businessNumber: '',
      phoneNumber: '',
      nickname: '',
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
}

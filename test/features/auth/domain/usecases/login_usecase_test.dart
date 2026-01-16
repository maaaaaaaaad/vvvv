import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/auth_result.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/repositories/auth_repository.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(repository: mockRepository);
  });

  const tParams = LoginParams(
    email: 'owner@example.com',
    password: 'Password123!',
  );

  final tOwner = Owner(
    id: 'test-uuid',
    nickname: 'testshop',
    email: 'owner@example.com',
    businessNumber: '123456789',
    phoneNumber: '010-1234-5678',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final tAuthResult = AuthResult(
    owner: tOwner,
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
  );

  group('LoginUseCase', () {
    test('should return AuthResult when login is successful', () async {
      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => Right(tAuthResult));

      final result = await useCase(tParams);

      expect(result, Right(tAuthResult));
      verify(() => mockRepository.login(
            email: tParams.email,
            password: tParams.password,
          )).called(1);
    });

    test('should return AuthFailure when login fails with invalid credentials',
        () async {
      const tFailure = AuthFailure('이메일 또는 비밀번호가 올바르지 않습니다');
      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(tParams);

      expect(result, const Left(tFailure));
    });

    test('should return ServerFailure when server error occurs', () async {
      const tFailure = ServerFailure('서버 오류가 발생했습니다');
      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(tParams);

      expect(result, const Left(tFailure));
    });
  });

  group('LoginParams', () {
    test('should be equal when properties are the same', () {
      const params1 = LoginParams(
        email: 'test@example.com',
        password: 'password123',
      );
      const params2 = LoginParams(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(params1, equals(params2));
    });

    test('props should contain email and password', () {
      const params = LoginParams(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(params.props, ['test@example.com', 'password123']);
    });
  });
}

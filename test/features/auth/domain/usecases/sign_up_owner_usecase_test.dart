import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/auth_result.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/repositories/auth_repository.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/sign_up_owner_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignUpOwnerUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignUpOwnerUseCase(repository: mockRepository);
  });

  final tParams = SignUpParams(
    businessNumber: '123456789',
    phoneNumber: '010-1234-5678',
    nickname: 'testshop',
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

  test('should return AuthResult when signup is successful', () async {
    when(() => mockRepository.signUp(
          businessNumber: any(named: 'businessNumber'),
          phoneNumber: any(named: 'phoneNumber'),
          nickname: any(named: 'nickname'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => Right(tAuthResult));

    final result = await useCase(tParams);

    expect(result, Right(tAuthResult));
    verify(() => mockRepository.signUp(
          businessNumber: tParams.businessNumber,
          phoneNumber: tParams.phoneNumber,
          nickname: tParams.nickname,
          email: tParams.email,
          password: tParams.password,
        )).called(1);
  });

  test('should return Failure when signup fails', () async {
    const tFailure = ServerFailure('회원가입에 실패했습니다');
    when(() => mockRepository.signUp(
          businessNumber: any(named: 'businessNumber'),
          phoneNumber: any(named: 'phoneNumber'),
          nickname: any(named: 'nickname'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => const Left(tFailure));

    final result = await useCase(tParams);

    expect(result, const Left(tFailure));
  });
}

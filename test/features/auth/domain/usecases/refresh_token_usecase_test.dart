import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/token_pair.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/repositories/auth_repository.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RefreshTokenUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RefreshTokenUseCase(repository: mockRepository);
  });

  const tParams = RefreshTokenParams(
    refreshToken: 'old-refresh-token',
  );

  const tTokenPair = TokenPair(
    accessToken: 'new-access-token',
    refreshToken: 'new-refresh-token',
  );

  group('RefreshTokenUseCase', () {
    test('should return TokenPair when refresh is successful', () async {
      when(() => mockRepository.refreshToken(
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async => const Right(tTokenPair));

      final result = await useCase(tParams);

      expect(result, const Right(tTokenPair));
      verify(() => mockRepository.refreshToken(
            refreshToken: tParams.refreshToken,
          )).called(1);
    });

    test('should return AuthFailure when refresh token is invalid', () async {
      const tFailure = AuthFailure('토큰이 만료되었습니다. 다시 로그인해주세요');
      when(() => mockRepository.refreshToken(
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(tParams);

      expect(result, const Left(tFailure));
    });

    test('should return ServerFailure when server error occurs', () async {
      const tFailure = ServerFailure('서버 오류가 발생했습니다');
      when(() => mockRepository.refreshToken(
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(tParams);

      expect(result, const Left(tFailure));
    });
  });

  group('RefreshTokenParams', () {
    test('should be equal when properties are the same', () {
      const params1 = RefreshTokenParams(refreshToken: 'token-123');
      const params2 = RefreshTokenParams(refreshToken: 'token-123');

      expect(params1, equals(params2));
    });

    test('props should contain refreshToken', () {
      const params = RefreshTokenParams(refreshToken: 'token-123');

      expect(params.props, ['token-123']);
    });
  });
}

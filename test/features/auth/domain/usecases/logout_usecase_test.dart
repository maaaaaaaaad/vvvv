import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/repositories/auth_repository.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LogoutUseCase(repository: mockRepository);
  });

  group('LogoutUseCase', () {
    test('should return Unit when logout is successful', () async {
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Right(unit));

      final result = await useCase(NoParams());

      expect(result, const Right(unit));
      verify(() => mockRepository.logout()).called(1);
    });

    test('should return ServerFailure when logout fails', () async {
      const tFailure = ServerFailure('로그아웃에 실패했습니다');
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(NoParams());

      expect(result, const Left(tFailure));
    });

    test('should return NetworkFailure when network error occurs', () async {
      const tFailure = NetworkFailure('네트워크 연결을 확인해주세요');
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(NoParams());

      expect(result, const Left(tFailure));
    });
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/features/owner/domain/repositories/owner_repository.dart';
import 'package:jellomark_mobile_owner/features/owner/domain/usecases/get_current_owner_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockOwnerRepository extends Mock implements OwnerRepository {}

void main() {
  late GetCurrentOwnerUseCase useCase;
  late MockOwnerRepository mockRepository;

  setUp(() {
    mockRepository = MockOwnerRepository();
    useCase = GetCurrentOwnerUseCase(repository: mockRepository);
  });

  final tOwner = Owner(
    id: 'test-uuid',
    nickname: 'testshop',
    email: 'owner@example.com',
    businessNumber: '123456789',
    phoneNumber: '010-1234-5678',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  group('GetCurrentOwnerUseCase', () {
    test('should return Owner when getting current owner is successful',
        () async {
      when(() => mockRepository.getCurrentOwner())
          .thenAnswer((_) async => Right(tOwner));

      final result = await useCase(NoParams());

      expect(result, Right(tOwner));
      verify(() => mockRepository.getCurrentOwner()).called(1);
    });

    test('should return NoTokenFailure when no token is stored', () async {
      const tFailure = NoTokenFailure();
      when(() => mockRepository.getCurrentOwner())
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(NoParams());

      expect(result, const Left(tFailure));
    });

    test('should return AuthFailure when token is invalid', () async {
      const tFailure = AuthFailure('인증이 만료되었습니다');
      when(() => mockRepository.getCurrentOwner())
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(NoParams());

      expect(result, const Left(tFailure));
    });

    test('should return ServerFailure when server error occurs', () async {
      const tFailure = ServerFailure('서버 오류가 발생했습니다');
      when(() => mockRepository.getCurrentOwner())
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(NoParams());

      expect(result, const Left(tFailure));
    });

    test('should return NetworkFailure when network error occurs', () async {
      const tFailure = NetworkFailure('네트워크 연결을 확인해주세요');
      when(() => mockRepository.getCurrentOwner())
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(NoParams());

      expect(result, const Left(tFailure));
    });
  });
}

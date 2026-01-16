import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/features/owner/domain/usecases/get_current_owner_usecase.dart';
import 'package:jellomark_mobile_owner/features/owner/presentation/providers/owner_providers.dart';
import 'package:jellomark_mobile_owner/features/owner/presentation/providers/owner_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCurrentOwnerUseCase extends Mock implements GetCurrentOwnerUseCase {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late OwnerStateNotifier notifier;
  late MockGetCurrentOwnerUseCase mockGetCurrentOwnerUseCase;

  setUpAll(() {
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockGetCurrentOwnerUseCase = MockGetCurrentOwnerUseCase();
    notifier = OwnerStateNotifier(
      getCurrentOwnerUseCase: mockGetCurrentOwnerUseCase,
    );
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

  group('OwnerStateNotifier', () {
    test('initial state should be OwnerInitial', () {
      expect(notifier.state, const OwnerInitial());
    });
  });

  group('loadCurrentOwner', () {
    test(
      'should emit OwnerLoading then OwnerLoaded when use case returns success',
      () async {
        when(
          () => mockGetCurrentOwnerUseCase(any()),
        ).thenAnswer((_) async => Right(tOwner));

        expect(notifier.state, const OwnerInitial());

        await notifier.loadCurrentOwner();

        expect(notifier.state, OwnerLoaded(owner: tOwner));
        verify(() => mockGetCurrentOwnerUseCase(any())).called(1);
      },
    );

    test(
      'should emit OwnerLoading then OwnerError when use case returns failure',
      () async {
        const tFailure = ServerFailure('Server error');
        when(
          () => mockGetCurrentOwnerUseCase(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        expect(notifier.state, const OwnerInitial());

        await notifier.loadCurrentOwner();

        expect(notifier.state, const OwnerError('Server error'));
      },
    );

    test(
      'should emit OwnerError with auth failure message when unauthorized',
      () async {
        const tFailure = AuthFailure('Unauthorized');
        when(
          () => mockGetCurrentOwnerUseCase(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        await notifier.loadCurrentOwner();

        expect(notifier.state, const OwnerError('Unauthorized'));
      },
    );
  });
}

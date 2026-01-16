import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/features/owner/domain/usecases/get_current_owner_usecase.dart';
import 'package:jellomark_mobile_owner/features/owner/presentation/pages/owner_profile_page.dart';
import 'package:jellomark_mobile_owner/features/owner/presentation/providers/owner_providers.dart';
import 'package:jellomark_mobile_owner/features/owner/presentation/widgets/owner_info_card.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCurrentOwnerUseCase extends Mock implements GetCurrentOwnerUseCase {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late MockGetCurrentOwnerUseCase mockGetCurrentOwnerUseCase;

  setUpAll(() {
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockGetCurrentOwnerUseCase = MockGetCurrentOwnerUseCase();
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

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        ownerStateProvider.overrideWith((ref) {
          return OwnerStateNotifier(
            getCurrentOwnerUseCase: mockGetCurrentOwnerUseCase,
          );
        }),
      ],
      child: const MaterialApp(
        home: OwnerProfilePage(),
      ),
    );
  }

  group('OwnerProfilePage', () {
    testWidgets('should display AppBar with title', (tester) async {
      when(() => mockGetCurrentOwnerUseCase(any()))
          .thenAnswer((_) async => Right(tOwner));

      await tester.pumpWidget(createTestWidget());

      expect(find.text('내 정보'), findsOneWidget);
    });

    testWidgets('should display loading indicator when loading', (tester) async {
      final completer = Completer<Either<Failure, Owner>>();
      when(() => mockGetCurrentOwnerUseCase(any()))
          .thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(Right(tOwner));
      await tester.pumpAndSettle();
    });

    testWidgets('should display OwnerInfoCard when loaded', (tester) async {
      when(() => mockGetCurrentOwnerUseCase(any()))
          .thenAnswer((_) async => Right(tOwner));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(OwnerInfoCard), findsOneWidget);
    });

    testWidgets('should display owner nickname when loaded', (tester) async {
      when(() => mockGetCurrentOwnerUseCase(any()))
          .thenAnswer((_) async => Right(tOwner));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('testshop'), findsOneWidget);
    });

    testWidgets('should display error message when error occurs', (tester) async {
      when(() => mockGetCurrentOwnerUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure('Server error')));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Server error'), findsAtLeast(1));
    });

    testWidgets('should display retry button when error occurs', (tester) async {
      when(() => mockGetCurrentOwnerUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure('Server error')));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('다시 시도'), findsOneWidget);
    });

    testWidgets('should call loadCurrentOwner when retry button is pressed',
        (tester) async {
      var callCount = 0;
      when(() => mockGetCurrentOwnerUseCase(any())).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          return const Left(ServerFailure('Server error'));
        }
        return Right(tOwner);
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('다시 시도'));
      await tester.pumpAndSettle();

      verify(() => mockGetCurrentOwnerUseCase(any())).called(2);
    });

    testWidgets('should call loadCurrentOwner on init', (tester) async {
      when(() => mockGetCurrentOwnerUseCase(any()))
          .thenAnswer((_) async => Right(tOwner));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      verify(() => mockGetCurrentOwnerUseCase(any())).called(1);
    });

    testWidgets('should show snackbar when error occurs via listener',
        (tester) async {
      when(() => mockGetCurrentOwnerUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure('Network error')));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Network error'), findsAtLeast(1));
    });
  });
}

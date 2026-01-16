import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/category_summary.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/usecases/create_shop_usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/usecases/delete_shop_usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/usecases/get_my_shop_usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/usecases/update_shop_usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/presentation/providers/shop_providers.dart';
import 'package:jellomark_mobile_owner/features/beautishop/presentation/providers/shop_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMyShopUseCase extends Mock implements GetMyShopUseCase {}

class MockCreateShopUseCase extends Mock implements CreateShopUseCase {}

class MockUpdateShopUseCase extends Mock implements UpdateShopUseCase {}

class MockDeleteShopUseCase extends Mock implements DeleteShopUseCase {}

class FakeNoParams extends Fake implements NoParams {}

class FakeCreateShopParams extends Fake implements CreateShopParams {}

class FakeUpdateShopParams extends Fake implements UpdateShopParams {}

class FakeDeleteShopParams extends Fake implements DeleteShopParams {}

void main() {
  late ShopStateNotifier notifier;
  late MockGetMyShopUseCase mockGetMyShopUseCase;
  late MockCreateShopUseCase mockCreateShopUseCase;
  late MockUpdateShopUseCase mockUpdateShopUseCase;
  late MockDeleteShopUseCase mockDeleteShopUseCase;

  setUpAll(() {
    registerFallbackValue(FakeNoParams());
    registerFallbackValue(FakeCreateShopParams());
    registerFallbackValue(FakeUpdateShopParams());
    registerFallbackValue(FakeDeleteShopParams());
  });

  setUp(() {
    mockGetMyShopUseCase = MockGetMyShopUseCase();
    mockCreateShopUseCase = MockCreateShopUseCase();
    mockUpdateShopUseCase = MockUpdateShopUseCase();
    mockDeleteShopUseCase = MockDeleteShopUseCase();
    notifier = ShopStateNotifier(
      getMyShopUseCase: mockGetMyShopUseCase,
      createShopUseCase: mockCreateShopUseCase,
      updateShopUseCase: mockUpdateShopUseCase,
      deleteShopUseCase: mockDeleteShopUseCase,
    );
  });

  final tBeautishop = Beautishop(
    id: 'shop-uuid',
    name: 'Test Beauty Shop',
    regNum: '1234567890',
    phoneNumber: '02-1234-5678',
    address: 'Seoul, Korea',
    latitude: 37.5665,
    longitude: 126.9780,
    operatingTime: const {'MON': '09:00-18:00', 'TUE': '09:00-18:00'},
    description: 'A beautiful shop',
    image: 'https://example.com/image.jpg',
    averageRating: 4.5,
    reviewCount: 100,
    categories: const [CategorySummary(id: 'cat-1', name: 'Hair')],
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  group('ShopStateNotifier', () {
    test('initial state should be ShopInitial', () {
      expect(notifier.state, const ShopInitial());
    });
  });

  group('loadMyShop', () {
    test(
      'should emit ShopLoading then ShopLoaded when use case returns shop',
      () async {
        when(() => mockGetMyShopUseCase(any()))
            .thenAnswer((_) async => Right(tBeautishop));

        expect(notifier.state, const ShopInitial());

        await notifier.loadMyShop();

        expect(notifier.state, ShopLoaded(shop: tBeautishop));
        verify(() => mockGetMyShopUseCase(any())).called(1);
      },
    );

    test(
      'should emit ShopLoading then ShopEmpty when use case returns null',
      () async {
        when(() => mockGetMyShopUseCase(any()))
            .thenAnswer((_) async => const Right(null));

        expect(notifier.state, const ShopInitial());

        await notifier.loadMyShop();

        expect(notifier.state, const ShopEmpty());
      },
    );

    test(
      'should emit ShopLoading then ShopError when use case returns failure',
      () async {
        const tFailure = ServerFailure('Server error');
        when(() => mockGetMyShopUseCase(any()))
            .thenAnswer((_) async => const Left(tFailure));

        expect(notifier.state, const ShopInitial());

        await notifier.loadMyShop();

        expect(notifier.state, const ShopError('Server error'));
      },
    );
  });

  group('createShop', () {
    final tParams = CreateShopParams(
      shopName: 'Test Shop',
      shopRegNum: '1234567890',
      shopPhoneNumber: '02-1234-5678',
      shopAddress: 'Seoul, Korea',
      latitude: 37.5665,
      longitude: 126.9780,
      operatingTime: const {'MON': '09:00-18:00'},
    );

    test(
      'should emit ShopCreating then ShopLoaded when use case returns success',
      () async {
        when(() => mockCreateShopUseCase(any()))
            .thenAnswer((_) async => Right(tBeautishop));

        await notifier.createShop(tParams);

        expect(notifier.state, ShopLoaded(shop: tBeautishop));
        verify(() => mockCreateShopUseCase(any())).called(1);
      },
    );

    test(
      'should emit ShopCreating then ShopError when use case returns failure',
      () async {
        const tFailure = ServerFailure('Creation failed');
        when(() => mockCreateShopUseCase(any()))
            .thenAnswer((_) async => const Left(tFailure));

        await notifier.createShop(tParams);

        expect(notifier.state, const ShopError('Creation failed'));
      },
    );
  });

  group('updateShop', () {
    final tParams = UpdateShopParams(
      shopId: 'shop-uuid',
      operatingTime: const {'MON': '10:00-19:00'},
      shopDescription: 'Updated description',
    );

    test(
      'should emit ShopUpdating then ShopLoaded when use case returns success',
      () async {
        when(() => mockUpdateShopUseCase(any()))
            .thenAnswer((_) async => Right(tBeautishop));

        await notifier.updateShop(tParams);

        expect(notifier.state, ShopLoaded(shop: tBeautishop));
        verify(() => mockUpdateShopUseCase(any())).called(1);
      },
    );

    test(
      'should emit ShopUpdating then ShopError when use case returns failure',
      () async {
        const tFailure = ServerFailure('Update failed');
        when(() => mockUpdateShopUseCase(any()))
            .thenAnswer((_) async => const Left(tFailure));

        await notifier.updateShop(tParams);

        expect(notifier.state, const ShopError('Update failed'));
      },
    );
  });

  group('deleteShop', () {
    test(
      'should emit ShopDeleting then ShopEmpty when use case returns success',
      () async {
        when(() => mockDeleteShopUseCase(any()))
            .thenAnswer((_) async => const Right(unit));

        await notifier.deleteShop('shop-uuid');

        expect(notifier.state, const ShopEmpty());
        verify(() => mockDeleteShopUseCase(any())).called(1);
      },
    );

    test(
      'should emit ShopDeleting then ShopError when use case returns failure',
      () async {
        const tFailure = ServerFailure('Delete failed');
        when(() => mockDeleteShopUseCase(any()))
            .thenAnswer((_) async => const Left(tFailure));

        await notifier.deleteShop('shop-uuid');

        expect(notifier.state, const ShopError('Delete failed'));
      },
    );
  });

  group('reset', () {
    test('should reset state to ShopInitial', () async {
      when(() => mockGetMyShopUseCase(any()))
          .thenAnswer((_) async => Right(tBeautishop));
      await notifier.loadMyShop();
      expect(notifier.state, isA<ShopLoaded>());

      notifier.reset();

      expect(notifier.state, const ShopInitial());
    });
  });
}

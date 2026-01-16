import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/storage/secure_token_storage.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/datasources/shop_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/beautishop_model.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/category_summary_model.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/create_shop_request.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/models/update_shop_request.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/repositories/shop_repository_impl.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:mocktail/mocktail.dart';

class MockShopRemoteDataSource extends Mock implements ShopRemoteDataSource {}

class MockSecureStorageWrapper extends Mock implements SecureStorageWrapper {}

void main() {
  late ShopRepositoryImpl repository;
  late MockShopRemoteDataSource mockDataSource;
  late MockSecureStorageWrapper mockStorage;

  setUp(() {
    mockDataSource = MockShopRemoteDataSource();
    mockStorage = MockSecureStorageWrapper();
    repository = ShopRepositoryImpl(
      remoteDataSource: mockDataSource,
      secureStorage: mockStorage,
    );
  });

  setUpAll(() {
    registerFallbackValue(const CreateShopRequest(
      shopName: '',
      shopRegNum: '',
      shopPhoneNumber: '',
      shopAddress: '',
      latitude: 0,
      longitude: 0,
      operatingTime: {},
    ));
    registerFallbackValue(const UpdateShopRequest());
  });

  final tCreatedAt = DateTime.parse('2024-01-01T00:00:00Z');
  final tUpdatedAt = DateTime.parse('2024-01-01T00:00:00Z');

  final tBeautishopModel = BeautishopModel(
    id: 'shop-uuid',
    name: 'Beautiful Nail',
    regNum: '1234567890',
    phoneNumber: '02-1234-5678',
    address: 'Seoul, Gangnam',
    latitude: 37.5665,
    longitude: 126.9780,
    operatingTime: const {'MON': '09:00-18:00'},
    description: 'Best nail shop',
    image: 'https://example.com/image.jpg',
    averageRating: 4.5,
    reviewCount: 10,
    categories: const [CategorySummaryModel(id: 'cat-uuid', name: 'nail')],
    distance: null,
    createdAt: tCreatedAt,
    updatedAt: tUpdatedAt,
  );

  group('createShop', () {
    const tShopName = 'Beautiful Nail';
    const tShopRegNum = '1234567890';
    const tShopPhoneNumber = '02-1234-5678';
    const tShopAddress = 'Seoul, Gangnam';
    const tLatitude = 37.5665;
    const tLongitude = 126.9780;
    const tOperatingTime = {'MON': '09:00-18:00'};
    const tShopDescription = 'Best nail shop';
    const tShopImage = 'https://example.com/image.jpg';

    test('should return Beautishop when data source call is successful', () async {
      when(() => mockDataSource.createShop(any())).thenAnswer((_) async => tBeautishopModel);

      final result = await repository.createShop(
        shopName: tShopName,
        shopRegNum: tShopRegNum,
        shopPhoneNumber: tShopPhoneNumber,
        shopAddress: tShopAddress,
        latitude: tLatitude,
        longitude: tLongitude,
        operatingTime: tOperatingTime,
        shopDescription: tShopDescription,
        shopImage: tShopImage,
      );

      expect(result, isA<Right<Failure, Beautishop>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (shop) {
          expect(shop.id, 'shop-uuid');
          expect(shop.name, 'Beautiful Nail');
        },
      );
      verify(() => mockDataSource.createShop(any())).called(1);
    });

    test('should return AuthFailure when DioException with 401 occurs', () async {
      when(() => mockDataSource.createShop(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      final result = await repository.createShop(
        shopName: tShopName,
        shopRegNum: tShopRegNum,
        shopPhoneNumber: tShopPhoneNumber,
        shopAddress: tShopAddress,
        latitude: tLatitude,
        longitude: tLongitude,
        operatingTime: tOperatingTime,
      );

      expect(result, isA<Left<Failure, Beautishop>>());
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when DioException with other status occurs', () async {
      when(() => mockDataSource.createShop(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops'),
            statusCode: 400,
            data: {'message': 'Bad request'},
          ),
        ),
      );

      final result = await repository.createShop(
        shopName: tShopName,
        shopRegNum: tShopRegNum,
        shopPhoneNumber: tShopPhoneNumber,
        shopAddress: tShopAddress,
        latitude: tLatitude,
        longitude: tLongitude,
        operatingTime: tOperatingTime,
      );

      expect(result, isA<Left<Failure, Beautishop>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when unknown exception occurs', () async {
      when(() => mockDataSource.createShop(any())).thenThrow(Exception('Unknown error'));

      final result = await repository.createShop(
        shopName: tShopName,
        shopRegNum: tShopRegNum,
        shopPhoneNumber: tShopPhoneNumber,
        shopAddress: tShopAddress,
        latitude: tLatitude,
        longitude: tLongitude,
        operatingTime: tOperatingTime,
      );

      expect(result, isA<Left<Failure, Beautishop>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('getShopById', () {
    const tShopId = 'shop-uuid';

    test('should return Beautishop when data source call is successful', () async {
      when(() => mockDataSource.getShopById(tShopId)).thenAnswer((_) async => tBeautishopModel);

      final result = await repository.getShopById(tShopId);

      expect(result, isA<Right<Failure, Beautishop>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (shop) {
          expect(shop.id, 'shop-uuid');
          expect(shop.name, 'Beautiful Nail');
        },
      );
      verify(() => mockDataSource.getShopById(tShopId)).called(1);
    });

    test('should return NotFoundFailure when DioException with 404 occurs', () async {
      when(() => mockDataSource.getShopById(tShopId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
            statusCode: 404,
            data: {'message': 'Shop not found'},
          ),
        ),
      );

      final result = await repository.getShopById(tShopId);

      expect(result, isA<Left<Failure, Beautishop>>());
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return AuthFailure when DioException with 401 occurs', () async {
      when(() => mockDataSource.getShopById(tShopId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      final result = await repository.getShopById(tShopId);

      expect(result, isA<Left<Failure, Beautishop>>());
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('updateShop', () {
    const tShopId = 'shop-uuid';
    const tOperatingTime = {'MON': '10:00-19:00'};
    const tDescription = 'Updated description';

    test('should return Beautishop when data source call is successful', () async {
      when(() => mockDataSource.updateShop(tShopId, any())).thenAnswer((_) async => tBeautishopModel);

      final result = await repository.updateShop(
        shopId: tShopId,
        operatingTime: tOperatingTime,
        shopDescription: tDescription,
      );

      expect(result, isA<Right<Failure, Beautishop>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (shop) => expect(shop.id, 'shop-uuid'),
      );
      verify(() => mockDataSource.updateShop(tShopId, any())).called(1);
    });

    test('should return NotFoundFailure when DioException with 404 occurs', () async {
      when(() => mockDataSource.updateShop(tShopId, any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
            statusCode: 404,
            data: {'message': 'Shop not found'},
          ),
        ),
      );

      final result = await repository.updateShop(
        shopId: tShopId,
        shopDescription: tDescription,
      );

      expect(result, isA<Left<Failure, Beautishop>>());
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return AuthFailure when DioException with 401 occurs', () async {
      when(() => mockDataSource.updateShop(tShopId, any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      final result = await repository.updateShop(
        shopId: tShopId,
        shopDescription: tDescription,
      );

      expect(result, isA<Left<Failure, Beautishop>>());
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('deleteShop', () {
    const tShopId = 'shop-uuid';

    test('should return Unit when data source call is successful', () async {
      when(() => mockDataSource.deleteShop(tShopId)).thenAnswer((_) async => {});

      final result = await repository.deleteShop(tShopId);

      expect(result, isA<Right<Failure, Unit>>());
      verify(() => mockDataSource.deleteShop(tShopId)).called(1);
    });

    test('should return NotFoundFailure when DioException with 404 occurs', () async {
      when(() => mockDataSource.deleteShop(tShopId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
            statusCode: 404,
            data: {'message': 'Shop not found'},
          ),
        ),
      );

      final result = await repository.deleteShop(tShopId);

      expect(result, isA<Left<Failure, Unit>>());
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return AuthFailure when DioException with 401 occurs', () async {
      when(() => mockDataSource.deleteShop(tShopId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/beautishops/$tShopId'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      final result = await repository.deleteShop(tShopId);

      expect(result, isA<Left<Failure, Unit>>());
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('getMyShopId', () {
    test('should return shopId when stored', () async {
      when(() => mockStorage.read(key: 'my_shop_id')).thenAnswer((_) async => 'shop-uuid');

      final result = await repository.getMyShopId();

      expect(result, isA<Right<Failure, String?>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (shopId) => expect(shopId, 'shop-uuid'),
      );
      verify(() => mockStorage.read(key: 'my_shop_id')).called(1);
    });

    test('should return null when not stored', () async {
      when(() => mockStorage.read(key: 'my_shop_id')).thenAnswer((_) async => null);

      final result = await repository.getMyShopId();

      expect(result, isA<Right<Failure, String?>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (shopId) => expect(shopId, isNull),
      );
    });

    test('should return CacheFailure when exception occurs', () async {
      when(() => mockStorage.read(key: 'my_shop_id')).thenThrow(Exception('Storage error'));

      final result = await repository.getMyShopId();

      expect(result, isA<Left<Failure, String?>>());
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('saveMyShopId', () {
    const tShopId = 'shop-uuid';

    test('should return Unit when save is successful', () async {
      when(() => mockStorage.write(key: 'my_shop_id', value: tShopId)).thenAnswer((_) async => {});

      final result = await repository.saveMyShopId(tShopId);

      expect(result, isA<Right<Failure, Unit>>());
      verify(() => mockStorage.write(key: 'my_shop_id', value: tShopId)).called(1);
    });

    test('should return CacheFailure when exception occurs', () async {
      when(() => mockStorage.write(key: 'my_shop_id', value: tShopId)).thenThrow(Exception('Storage error'));

      final result = await repository.saveMyShopId(tShopId);

      expect(result, isA<Left<Failure, Unit>>());
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('clearMyShopId', () {
    test('should return Unit when clear is successful', () async {
      when(() => mockStorage.delete(key: 'my_shop_id')).thenAnswer((_) async => {});

      final result = await repository.clearMyShopId();

      expect(result, isA<Right<Failure, Unit>>());
      verify(() => mockStorage.delete(key: 'my_shop_id')).called(1);
    });

    test('should return CacheFailure when exception occurs', () async {
      when(() => mockStorage.delete(key: 'my_shop_id')).thenThrow(Exception('Storage error'));

      final result = await repository.clearMyShopId();

      expect(result, isA<Left<Failure, Unit>>());
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });
}

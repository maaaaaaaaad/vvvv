import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/category/data/datasources/category_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/category/data/models/category_model.dart';
import 'package:jellomark_mobile_owner/features/category/data/models/set_categories_request.dart';
import 'package:jellomark_mobile_owner/features/category/data/repositories/category_repository_impl.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRemoteDataSource extends Mock
    implements CategoryRemoteDataSource {}

void main() {
  late CategoryRepositoryImpl repository;
  late MockCategoryRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockCategoryRemoteDataSource();
    repository = CategoryRepositoryImpl(remoteDataSource: mockDataSource);
  });

  setUpAll(() {
    registerFallbackValue(const SetCategoriesRequest(categoryIds: []));
  });

  final tCreatedAt = DateTime.parse('2024-01-01T00:00:00Z');
  final tUpdatedAt = DateTime.parse('2024-01-01T00:00:00Z');

  final tCategoryModel1 = CategoryModel(
    id: 'cat-uuid-1',
    name: 'nail',
    createdAt: tCreatedAt,
    updatedAt: tUpdatedAt,
  );

  final tCategoryModel2 = CategoryModel(
    id: 'cat-uuid-2',
    name: 'hair',
    createdAt: tCreatedAt,
    updatedAt: tUpdatedAt,
  );

  group('getCategories', () {
    test('should return List<Category> when data source call is successful',
        () async {
      when(() => mockDataSource.getCategories())
          .thenAnswer((_) async => [tCategoryModel1, tCategoryModel2]);

      final result = await repository.getCategories();

      expect(result, isA<Right<Failure, List<Category>>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (categories) {
          expect(categories.length, 2);
          expect(categories[0].id, 'cat-uuid-1');
          expect(categories[1].id, 'cat-uuid-2');
        },
      );
      verify(() => mockDataSource.getCategories()).called(1);
    });

    test('should return empty list when no categories exist', () async {
      when(() => mockDataSource.getCategories()).thenAnswer((_) async => []);

      final result = await repository.getCategories();

      expect(result, isA<Right<Failure, List<Category>>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (categories) => expect(categories, isEmpty),
      );
    });

    test('should return ServerFailure when DioException occurs', () async {
      when(() => mockDataSource.getCategories()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/categories'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/categories'),
            statusCode: 500,
            data: {'message': 'Internal server error'},
          ),
        ),
      );

      final result = await repository.getCategories();

      expect(result, isA<Left<Failure, List<Category>>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when unknown exception occurs', () async {
      when(() => mockDataSource.getCategories())
          .thenThrow(Exception('Unknown error'));

      final result = await repository.getCategories();

      expect(result, isA<Left<Failure, List<Category>>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('setShopCategories', () {
    const tShopId = 'shop-uuid';
    const tCategoryIds = ['cat-uuid-1'];

    test('should return List<Category> when data source call is successful',
        () async {
      when(() => mockDataSource.setShopCategories(tShopId, any()))
          .thenAnswer((_) async => [tCategoryModel1]);

      final result = await repository.setShopCategories(
        shopId: tShopId,
        categoryIds: tCategoryIds,
      );

      expect(result, isA<Right<Failure, List<Category>>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (categories) {
          expect(categories.length, 1);
          expect(categories[0].id, 'cat-uuid-1');
        },
      );
      verify(() => mockDataSource.setShopCategories(tShopId, any())).called(1);
    });

    test('should return AuthFailure when DioException with 401 occurs',
        () async {
      when(() => mockDataSource.setShopCategories(tShopId, any())).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/api/beautishops/$tShopId/categories'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/api/beautishops/$tShopId/categories'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      final result = await repository.setShopCategories(
        shopId: tShopId,
        categoryIds: tCategoryIds,
      );

      expect(result, isA<Left<Failure, List<Category>>>());
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ForbiddenFailure when DioException with 403 occurs',
        () async {
      when(() => mockDataSource.setShopCategories(tShopId, any())).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/api/beautishops/$tShopId/categories'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/api/beautishops/$tShopId/categories'),
            statusCode: 403,
            data: {'message': 'Forbidden'},
          ),
        ),
      );

      final result = await repository.setShopCategories(
        shopId: tShopId,
        categoryIds: tCategoryIds,
      );

      expect(result, isA<Left<Failure, List<Category>>>());
      result.fold(
        (failure) => expect(failure, isA<ForbiddenFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return NotFoundFailure when DioException with 404 occurs',
        () async {
      when(() => mockDataSource.setShopCategories(tShopId, any())).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/api/beautishops/$tShopId/categories'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/api/beautishops/$tShopId/categories'),
            statusCode: 404,
            data: {'message': 'Shop not found'},
          ),
        ),
      );

      final result = await repository.setShopCategories(
        shopId: tShopId,
        categoryIds: tCategoryIds,
      );

      expect(result, isA<Left<Failure, List<Category>>>());
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test(
        'should return ServerFailure when DioException with other status occurs',
        () async {
      when(() => mockDataSource.setShopCategories(tShopId, any())).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/api/beautishops/$tShopId/categories'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/api/beautishops/$tShopId/categories'),
            statusCode: 500,
            data: {'message': 'Internal server error'},
          ),
        ),
      );

      final result = await repository.setShopCategories(
        shopId: tShopId,
        categoryIds: tCategoryIds,
      );

      expect(result, isA<Left<Failure, List<Category>>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when unknown exception occurs', () async {
      when(() => mockDataSource.setShopCategories(tShopId, any()))
          .thenThrow(Exception('Unknown error'));

      final result = await repository.setShopCategories(
        shopId: tShopId,
        categoryIds: tCategoryIds,
      );

      expect(result, isA<Left<Failure, List<Category>>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });
}

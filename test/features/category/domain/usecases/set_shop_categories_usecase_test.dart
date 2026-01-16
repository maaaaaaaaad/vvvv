import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';
import 'package:jellomark_mobile_owner/features/category/domain/repositories/category_repository.dart';
import 'package:jellomark_mobile_owner/features/category/domain/usecases/set_shop_categories_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late SetShopCategoriesUseCase useCase;
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
    useCase = SetShopCategoriesUseCase(repository: mockRepository);
  });

  const tShopId = 'shop-1';
  const tCategoryIds = ['cat-1', 'cat-2'];

  final tCategories = [
    Category(
      id: 'cat-1',
      name: 'Hair',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 2),
    ),
    Category(
      id: 'cat-2',
      name: 'Nail',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 2),
    ),
  ];

  group('SetShopCategoriesUseCase', () {
    test('should return list of categories when successful', () async {
      when(() => mockRepository.setShopCategories(
            shopId: any(named: 'shopId'),
            categoryIds: any(named: 'categoryIds'),
          )).thenAnswer((_) async => Right(tCategories));

      final result = await useCase(const SetShopCategoriesParams(
        shopId: tShopId,
        categoryIds: tCategoryIds,
      ));

      expect(result, Right(tCategories));
      verify(() => mockRepository.setShopCategories(
            shopId: tShopId,
            categoryIds: tCategoryIds,
          )).called(1);
    });

    test('should return empty list when no categories are set', () async {
      when(() => mockRepository.setShopCategories(
            shopId: any(named: 'shopId'),
            categoryIds: any(named: 'categoryIds'),
          )).thenAnswer((_) async => const Right([]));

      final result = await useCase(const SetShopCategoriesParams(
        shopId: tShopId,
        categoryIds: [],
      ));

      expect(result, const Right(<Category>[]));
      verify(() => mockRepository.setShopCategories(
            shopId: tShopId,
            categoryIds: [],
          )).called(1);
    });

    test('should return ServerFailure when server error occurs', () async {
      const tFailure = ServerFailure('Server error');
      when(() => mockRepository.setShopCategories(
            shopId: any(named: 'shopId'),
            categoryIds: any(named: 'categoryIds'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(const SetShopCategoriesParams(
        shopId: tShopId,
        categoryIds: tCategoryIds,
      ));

      expect(result, const Left(tFailure));
    });

    test('should return NotFoundFailure when shop is not found', () async {
      const tFailure = NotFoundFailure('Shop not found');
      when(() => mockRepository.setShopCategories(
            shopId: any(named: 'shopId'),
            categoryIds: any(named: 'categoryIds'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(const SetShopCategoriesParams(
        shopId: 'non-existent-shop',
        categoryIds: tCategoryIds,
      ));

      expect(result, const Left(tFailure));
    });

    test('should return NetworkFailure when network error occurs', () async {
      const tFailure = NetworkFailure('Network error');
      when(() => mockRepository.setShopCategories(
            shopId: any(named: 'shopId'),
            categoryIds: any(named: 'categoryIds'),
          )).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(const SetShopCategoriesParams(
        shopId: tShopId,
        categoryIds: tCategoryIds,
      ));

      expect(result, const Left(tFailure));
    });
  });

  group('SetShopCategoriesParams', () {
    test('should be equal when properties are the same', () {
      const params1 = SetShopCategoriesParams(
        shopId: 'shop-1',
        categoryIds: ['cat-1', 'cat-2'],
      );
      const params2 = SetShopCategoriesParams(
        shopId: 'shop-1',
        categoryIds: ['cat-1', 'cat-2'],
      );

      expect(params1, equals(params2));
    });

    test('should not be equal when shopId differs', () {
      const params1 = SetShopCategoriesParams(
        shopId: 'shop-1',
        categoryIds: ['cat-1'],
      );
      const params2 = SetShopCategoriesParams(
        shopId: 'shop-2',
        categoryIds: ['cat-1'],
      );

      expect(params1, isNot(equals(params2)));
    });

    test('should not be equal when categoryIds differ', () {
      const params1 = SetShopCategoriesParams(
        shopId: 'shop-1',
        categoryIds: ['cat-1'],
      );
      const params2 = SetShopCategoriesParams(
        shopId: 'shop-1',
        categoryIds: ['cat-1', 'cat-2'],
      );

      expect(params1, isNot(equals(params2)));
    });

    test('props should contain all properties', () {
      const params = SetShopCategoriesParams(
        shopId: 'shop-1',
        categoryIds: ['cat-1', 'cat-2'],
      );

      expect(params.props, ['shop-1', const ['cat-1', 'cat-2']]);
    });
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';
import 'package:jellomark_mobile_owner/features/category/domain/repositories/category_repository.dart';
import 'package:jellomark_mobile_owner/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late GetCategoriesUseCase useCase;
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
    useCase = GetCategoriesUseCase(repository: mockRepository);
  });

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
    Category(
      id: 'cat-3',
      name: 'Makeup',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 2),
    ),
  ];

  group('GetCategoriesUseCase', () {
    test('should return list of categories when successful', () async {
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => Right(tCategories));

      final result = await useCase(NoParams());

      expect(result, Right(tCategories));
      verify(() => mockRepository.getCategories()).called(1);
    });

    test('should return empty list when no categories exist', () async {
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => const Right([]));

      final result = await useCase(NoParams());

      expect(result, const Right(<Category>[]));
      verify(() => mockRepository.getCategories()).called(1);
    });

    test('should return ServerFailure when server error occurs', () async {
      const tFailure = ServerFailure('Server error');
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(NoParams());

      expect(result, const Left(tFailure));
      verify(() => mockRepository.getCategories()).called(1);
    });

    test('should return NetworkFailure when network error occurs', () async {
      const tFailure = NetworkFailure('Network error');
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(NoParams());

      expect(result, const Left(tFailure));
    });
  });
}

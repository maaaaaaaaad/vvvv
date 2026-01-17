import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/home/domain/entities/dashboard_stats.dart';
import 'package:jellomark_mobile_owner/features/home/domain/repositories/dashboard_repository.dart';
import 'package:jellomark_mobile_owner/features/home/domain/usecases/get_dashboard_usecase.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardRepository extends Mock implements DashboardRepository {}

void main() {
  late GetDashboardUseCase useCase;
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
    useCase = GetDashboardUseCase(repository: mockRepository);
  });

  const tShopId = 'shop-1';

  final tReviews = [
    Review(
      id: 'review-1',
      content: 'Great service!',
      rating: 5,
      memberNickname: 'John',
      createdAt: DateTime(2024, 1, 1),
    ),
    Review(
      id: 'review-2',
      content: 'Good experience',
      rating: 4,
      memberNickname: 'Jane',
      createdAt: DateTime(2024, 1, 2),
    ),
  ];

  final tDashboardStats = DashboardStats(
    reviewCount: 10,
    averageRating: 4.5,
    treatmentCount: 5,
    recentReviews: tReviews,
  );

  group('GetDashboardUseCase', () {
    test('should return DashboardStats when successful', () async {
      when(() => mockRepository.getDashboardStats(any()))
          .thenAnswer((_) async => Right(tDashboardStats));

      final result = await useCase(
        const GetDashboardParams(shopId: tShopId),
      );

      expect(result, Right(tDashboardStats));
      verify(() => mockRepository.getDashboardStats(tShopId)).called(1);
    });

    test('should return ServerFailure when repository fails', () async {
      const tFailure = ServerFailure('Failed to get dashboard stats');
      when(() => mockRepository.getDashboardStats(any()))
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(
        const GetDashboardParams(shopId: tShopId),
      );

      expect(result, const Left(tFailure));
    });

    test('should return NotFoundFailure when shop does not exist', () async {
      const tFailure = NotFoundFailure('Shop not found');
      when(() => mockRepository.getDashboardStats(any()))
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(
        const GetDashboardParams(shopId: 'non-existent-shop'),
      );

      expect(result, const Left(tFailure));
    });

    test('should return NetworkFailure when network error occurs', () async {
      const tFailure = NetworkFailure('No internet connection');
      when(() => mockRepository.getDashboardStats(any()))
          .thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(
        const GetDashboardParams(shopId: tShopId),
      );

      expect(result, const Left(tFailure));
    });

    test('should return empty stats when shop has no data', () async {
      const emptyStats = DashboardStats(
        reviewCount: 0,
        averageRating: 0.0,
        treatmentCount: 0,
        recentReviews: [],
      );

      when(() => mockRepository.getDashboardStats(any()))
          .thenAnswer((_) async => const Right(emptyStats));

      final result = await useCase(
        const GetDashboardParams(shopId: tShopId),
      );

      expect(result, const Right(emptyStats));
    });
  });

  group('GetDashboardParams', () {
    test('should be equal when shopId is the same', () {
      const params1 = GetDashboardParams(shopId: 'shop-1');
      const params2 = GetDashboardParams(shopId: 'shop-1');

      expect(params1, equals(params2));
    });

    test('should not be equal when shopId is different', () {
      const params1 = GetDashboardParams(shopId: 'shop-1');
      const params2 = GetDashboardParams(shopId: 'shop-2');

      expect(params1, isNot(equals(params2)));
    });

    test('props should contain shopId', () {
      const params = GetDashboardParams(shopId: 'shop-1');

      expect(params.props, ['shop-1']);
    });
  });
}

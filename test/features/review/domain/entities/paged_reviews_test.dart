import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/paged_reviews.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';

void main() {
  group('PagedReviews', () {
    final tCreatedAt = DateTime(2024, 1, 1);

    final tReviews = [
      Review(
        id: 'review-1',
        content: 'Great service!',
        rating: 5,
        memberNickname: 'John',
        createdAt: tCreatedAt,
      ),
      Review(
        id: 'review-2',
        content: 'Good experience',
        rating: 4,
        memberNickname: 'Jane',
        createdAt: tCreatedAt,
      ),
    ];

    test('should be equal when all properties are the same', () {
      final pagedReviews1 = PagedReviews(
        reviews: tReviews,
        totalCount: 10,
        hasNext: true,
      );

      final pagedReviews2 = PagedReviews(
        reviews: tReviews,
        totalCount: 10,
        hasNext: true,
      );

      expect(pagedReviews1, equals(pagedReviews2));
    });

    test('should not be equal when reviews list is different', () {
      final pagedReviews1 = PagedReviews(
        reviews: tReviews,
        totalCount: 10,
        hasNext: true,
      );

      final pagedReviews2 = PagedReviews(
        reviews: [tReviews.first],
        totalCount: 10,
        hasNext: true,
      );

      expect(pagedReviews1, isNot(equals(pagedReviews2)));
    });

    test('should not be equal when totalCount is different', () {
      final pagedReviews1 = PagedReviews(
        reviews: tReviews,
        totalCount: 10,
        hasNext: true,
      );

      final pagedReviews2 = PagedReviews(
        reviews: tReviews,
        totalCount: 20,
        hasNext: true,
      );

      expect(pagedReviews1, isNot(equals(pagedReviews2)));
    });

    test('should not be equal when hasNext is different', () {
      final pagedReviews1 = PagedReviews(
        reviews: tReviews,
        totalCount: 10,
        hasNext: true,
      );

      final pagedReviews2 = PagedReviews(
        reviews: tReviews,
        totalCount: 10,
        hasNext: false,
      );

      expect(pagedReviews1, isNot(equals(pagedReviews2)));
    });

    test('props should contain all properties', () {
      final pagedReviews = PagedReviews(
        reviews: tReviews,
        totalCount: 10,
        hasNext: true,
      );

      expect(pagedReviews.props, [
        tReviews,
        10,
        true,
      ]);
    });

    test('should allow empty reviews list', () {
      final pagedReviews = PagedReviews(
        reviews: const [],
        totalCount: 0,
        hasNext: false,
      );

      expect(pagedReviews.reviews, isEmpty);
      expect(pagedReviews.totalCount, 0);
      expect(pagedReviews.hasNext, false);
    });
  });
}

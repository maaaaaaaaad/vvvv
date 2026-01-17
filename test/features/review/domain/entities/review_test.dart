import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';

void main() {
  group('Review', () {
    final tCreatedAt = DateTime(2024, 1, 1);

    test('should be equal when all properties are the same', () {
      final review1 = Review(
        id: 'review-1',
        content: 'Great service!',
        rating: 5,
        memberNickname: 'John',
        createdAt: tCreatedAt,
      );

      final review2 = Review(
        id: 'review-1',
        content: 'Great service!',
        rating: 5,
        memberNickname: 'John',
        createdAt: tCreatedAt,
      );

      expect(review1, equals(review2));
    });

    test('should not be equal when id is different', () {
      final review1 = Review(
        id: 'review-1',
        content: 'Great service!',
        rating: 5,
        memberNickname: 'John',
        createdAt: tCreatedAt,
      );

      final review2 = Review(
        id: 'review-2',
        content: 'Great service!',
        rating: 5,
        memberNickname: 'John',
        createdAt: tCreatedAt,
      );

      expect(review1, isNot(equals(review2)));
    });

    test('should not be equal when rating is different', () {
      final review1 = Review(
        id: 'review-1',
        content: 'Great service!',
        rating: 5,
        memberNickname: 'John',
        createdAt: tCreatedAt,
      );

      final review2 = Review(
        id: 'review-1',
        content: 'Great service!',
        rating: 4,
        memberNickname: 'John',
        createdAt: tCreatedAt,
      );

      expect(review1, isNot(equals(review2)));
    });

    test('should not be equal when content is different', () {
      final review1 = Review(
        id: 'review-1',
        content: 'Great service!',
        rating: 5,
        memberNickname: 'John',
        createdAt: tCreatedAt,
      );

      final review2 = Review(
        id: 'review-1',
        content: 'Good service!',
        rating: 5,
        memberNickname: 'John',
        createdAt: tCreatedAt,
      );

      expect(review1, isNot(equals(review2)));
    });

    test('should not be equal when memberNickname is different', () {
      final review1 = Review(
        id: 'review-1',
        content: 'Great service!',
        rating: 5,
        memberNickname: 'John',
        createdAt: tCreatedAt,
      );

      final review2 = Review(
        id: 'review-1',
        content: 'Great service!',
        rating: 5,
        memberNickname: 'Jane',
        createdAt: tCreatedAt,
      );

      expect(review1, isNot(equals(review2)));
    });

    test('props should contain all properties', () {
      final review = Review(
        id: 'review-1',
        content: 'Great service!',
        rating: 5,
        memberNickname: 'John',
        createdAt: tCreatedAt,
      );

      expect(review.props, [
        'review-1',
        'Great service!',
        5,
        'John',
        tCreatedAt,
      ]);
    });

    test('rating should be between 1 and 5', () {
      final review = Review(
        id: 'review-1',
        content: 'Great service!',
        rating: 5,
        memberNickname: 'John',
        createdAt: tCreatedAt,
      );

      expect(review.rating, greaterThanOrEqualTo(1));
      expect(review.rating, lessThanOrEqualTo(5));
    });
  });
}

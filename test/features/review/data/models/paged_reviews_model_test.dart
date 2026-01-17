import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/review/data/models/paged_reviews_model.dart';
import 'package:jellomark_mobile_owner/features/review/data/models/review_model.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/paged_reviews.dart';

void main() {
  group('PagedReviewsModel', () {
    final tCreatedAt = DateTime.parse('2024-01-15T10:30:00Z');

    final tReviewModel = ReviewModel(
      id: 'review-1',
      content: '좋은 서비스였습니다',
      rating: 5,
      memberNickname: '홍길동',
      createdAt: tCreatedAt,
    );

    final tPagedReviewsModel = PagedReviewsModel(
      reviews: [tReviewModel],
      totalCount: 100,
      hasNext: true,
    );

    final tJson = {
      'reviews': [
        {
          'id': 'review-1',
          'content': '좋은 서비스였습니다',
          'rating': 5,
          'memberNickname': '홍길동',
          'createdAt': '2024-01-15T10:30:00.000Z',
        }
      ],
      'totalCount': 100,
      'hasNext': true,
    };

    test('should be a subclass of PagedReviews entity', () {
      expect(tPagedReviewsModel, isA<PagedReviews>());
    });

    test('should create PagedReviewsModel from JSON', () {
      final result = PagedReviewsModel.fromJson(tJson);

      expect(result.reviews.length, 1);
      expect(result.reviews[0], isA<ReviewModel>());
      expect(result.reviews[0].id, 'review-1');
      expect(result.reviews[0].content, '좋은 서비스였습니다');
      expect(result.totalCount, 100);
      expect(result.hasNext, true);
    });

    test('should create PagedReviewsModel from JSON with empty reviews', () {
      final jsonWithEmptyReviews = {
        'reviews': <Map<String, dynamic>>[],
        'totalCount': 0,
        'hasNext': false,
      };

      final result = PagedReviewsModel.fromJson(jsonWithEmptyReviews);

      expect(result.reviews, isEmpty);
      expect(result.totalCount, 0);
      expect(result.hasNext, false);
    });

    test('should return PagedReviews entity from toEntity()', () {
      final result = tPagedReviewsModel.toEntity();

      expect(result, isA<PagedReviews>());
      expect(result.reviews.length, 1);
      expect(result.reviews[0].id, 'review-1');
      expect(result.totalCount, 100);
      expect(result.hasNext, true);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/review/data/models/review_model.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';

void main() {
  group('ReviewModel', () {
    final tCreatedAt = DateTime.parse('2024-01-15T10:30:00Z');

    final tReviewModel = ReviewModel(
      id: 'review-1',
      content: '좋은 서비스였습니다',
      rating: 5,
      memberNickname: '홍길동',
      createdAt: tCreatedAt,
    );

    final tJson = {
      'id': 'review-1',
      'content': '좋은 서비스였습니다',
      'rating': 5,
      'memberNickname': '홍길동',
      'createdAt': '2024-01-15T10:30:00.000Z',
    };

    test('should be a subclass of Review entity', () {
      expect(tReviewModel, isA<Review>());
    });

    test('should create ReviewModel from JSON', () {
      final result = ReviewModel.fromJson(tJson);

      expect(result.id, 'review-1');
      expect(result.content, '좋은 서비스였습니다');
      expect(result.rating, 5);
      expect(result.memberNickname, '홍길동');
      expect(result.createdAt, tCreatedAt);
    });

    test('should return correct JSON map', () {
      final result = tReviewModel.toJson();

      expect(result['id'], 'review-1');
      expect(result['content'], '좋은 서비스였습니다');
      expect(result['rating'], 5);
      expect(result['memberNickname'], '홍길동');
      expect(result['createdAt'], '2024-01-15T10:30:00.000Z');
    });

    test('should return Review entity from toEntity()', () {
      final result = tReviewModel.toEntity();

      expect(result, isA<Review>());
      expect(result.id, 'review-1');
      expect(result.content, '좋은 서비스였습니다');
      expect(result.rating, 5);
      expect(result.memberNickname, '홍길동');
      expect(result.createdAt, tCreatedAt);
    });
  });
}

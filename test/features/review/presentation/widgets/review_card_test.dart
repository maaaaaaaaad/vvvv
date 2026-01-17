import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/widgets/review_card.dart';

void main() {
  final testReview = Review(
    id: 'review-1',
    content: '시술이 정말 좋았습니다. 친절하게 상담해주시고 결과도 만족스러워요!',
    rating: 5,
    memberNickname: '김미영',
    createdAt: DateTime(2024, 1, 15),
  );

  final testReviewLowRating = Review(
    id: 'review-2',
    content: '그저 그랬어요.',
    rating: 2,
    memberNickname: '이수진',
    createdAt: DateTime(2024, 3, 20),
  );

  Widget buildTestWidget({required Review review}) {
    return MaterialApp(
      home: Scaffold(
        body: ReviewCard(review: review),
      ),
    );
  }

  group('ReviewCard', () {
    testWidgets('should display member nickname', (tester) async {
      await tester.pumpWidget(buildTestWidget(review: testReview));

      expect(find.text('김미영'), findsOneWidget);
    });

    testWidgets('should display review content', (tester) async {
      await tester.pumpWidget(buildTestWidget(review: testReview));

      expect(
        find.text('시술이 정말 좋았습니다. 친절하게 상담해주시고 결과도 만족스러워요!'),
        findsOneWidget,
      );
    });

    testWidgets('should display formatted date as yyyy.MM.dd', (tester) async {
      await tester.pumpWidget(buildTestWidget(review: testReview));

      expect(find.text('2024.01.15'), findsOneWidget);
    });

    testWidgets('should display correct number of filled stars for rating 5',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(review: testReview));

      final filledStars = find.byIcon(Icons.star);
      final emptyStars = find.byIcon(Icons.star_border);

      expect(filledStars, findsNWidgets(5));
      expect(emptyStars, findsNothing);
    });

    testWidgets('should display correct number of filled stars for rating 2',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(review: testReviewLowRating));

      final filledStars = find.byIcon(Icons.star);
      final emptyStars = find.byIcon(Icons.star_border);

      expect(filledStars, findsNWidgets(2));
      expect(emptyStars, findsNWidgets(3));
    });

    testWidgets('should display stars in yellow color', (tester) async {
      await tester.pumpWidget(buildTestWidget(review: testReview));

      final starIcon = tester.widget<Icon>(find.byIcon(Icons.star).first);
      expect(starIcon.color, Colors.amber);
    });

    testWidgets('should use Card widget for container', (tester) async {
      await tester.pumpWidget(buildTestWidget(review: testReview));

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display different date format correctly',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(review: testReviewLowRating));

      expect(find.text('2024.03.20'), findsOneWidget);
    });

    testWidgets('should have Row widget containing stars', (tester) async {
      await tester.pumpWidget(buildTestWidget(review: testReview));

      final starRows = find.ancestor(
        of: find.byIcon(Icons.star),
        matching: find.byType(Row),
      );

      expect(starRows, findsAtLeastNWidgets(1));
    });
  });
}

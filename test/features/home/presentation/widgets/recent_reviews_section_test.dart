import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/widgets/recent_reviews_section.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/widgets/review_card.dart';

void main() {
  final testReviews = [
    Review(
      id: 'review-1',
      content: '시술이 정말 좋았습니다.',
      rating: 5,
      memberNickname: '김미영',
      createdAt: DateTime(2024, 1, 15),
    ),
    Review(
      id: 'review-2',
      content: '친절하고 좋았어요.',
      rating: 4,
      memberNickname: '이수진',
      createdAt: DateTime(2024, 1, 14),
    ),
    Review(
      id: 'review-3',
      content: '괜찮았습니다.',
      rating: 3,
      memberNickname: '박지은',
      createdAt: DateTime(2024, 1, 13),
    ),
  ];

  Widget buildTestWidget({required List<Review> reviews}) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: RecentReviewsSection(reviews: reviews),
        ),
      ),
    );
  }

  group('RecentReviewsSection', () {
    testWidgets('should display header with "최근 리뷰"', (tester) async {
      await tester.pumpWidget(buildTestWidget(reviews: testReviews));

      expect(find.text('최근 리뷰'), findsOneWidget);
    });

    testWidgets('should display ReviewCard for each review', (tester) async {
      await tester.pumpWidget(buildTestWidget(reviews: testReviews));

      expect(find.byType(ReviewCard), findsNWidgets(3));
    });

    testWidgets('should display review content from each review', (tester) async {
      await tester.pumpWidget(buildTestWidget(reviews: testReviews));

      expect(find.text('시술이 정말 좋았습니다.'), findsOneWidget);
      expect(find.text('친절하고 좋았어요.'), findsOneWidget);
      expect(find.text('괜찮았습니다.'), findsOneWidget);
    });

    testWidgets('should display "아직 리뷰가 없습니다" when reviews is empty',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(reviews: []));

      expect(find.text('아직 리뷰가 없습니다'), findsOneWidget);
    });

    testWidgets('should not display ReviewCard when reviews is empty',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(reviews: []));

      expect(find.byType(ReviewCard), findsNothing);
    });

    testWidgets('should still display header when reviews is empty',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(reviews: []));

      expect(find.text('최근 리뷰'), findsOneWidget);
    });

    testWidgets('should display member nicknames', (tester) async {
      await tester.pumpWidget(buildTestWidget(reviews: testReviews));

      expect(find.text('김미영'), findsOneWidget);
      expect(find.text('이수진'), findsOneWidget);
      expect(find.text('박지은'), findsOneWidget);
    });

    testWidgets('should handle single review', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        reviews: [testReviews.first],
      ));

      expect(find.byType(ReviewCard), findsOneWidget);
      expect(find.text('시술이 정말 좋았습니다.'), findsOneWidget);
    });
  });
}

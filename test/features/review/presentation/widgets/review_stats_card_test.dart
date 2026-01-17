import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/widgets/review_stats_card.dart';

void main() {
  Widget buildTestWidget({
    required double averageRating,
    required int totalCount,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ReviewStatsCard(
          averageRating: averageRating,
          totalCount: totalCount,
        ),
      ),
    );
  }

  group('ReviewStatsCard', () {
    testWidgets('should display average rating', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        averageRating: 4.5,
        totalCount: 10,
      ));

      expect(find.text('4.5'), findsOneWidget);
    });

    testWidgets('should display total review count', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        averageRating: 4.5,
        totalCount: 10,
      ));

      expect(find.textContaining('10'), findsAtLeastNWidgets(1));
    });

    testWidgets('should format average rating to 1 decimal place',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        averageRating: 4.33333,
        totalCount: 5,
      ));

      expect(find.text('4.3'), findsOneWidget);
    });

    testWidgets('should display 0.0 for zero average rating', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        averageRating: 0.0,
        totalCount: 0,
      ));

      expect(find.text('0.0'), findsOneWidget);
    });

    testWidgets('should use Card widget for container', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        averageRating: 4.5,
        totalCount: 10,
      ));

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display large text for average rating', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        averageRating: 4.5,
        totalCount: 10,
      ));

      final ratingText = find.text('4.5');
      expect(ratingText, findsOneWidget);

      final textWidget = tester.widget<Text>(ratingText);
      expect(textWidget.style?.fontSize, greaterThanOrEqualTo(32));
    });

    testWidgets('should display star icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        averageRating: 4.5,
        totalCount: 10,
      ));

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('should display star icon in amber color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        averageRating: 4.5,
        totalCount: 10,
      ));

      final starIcon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(starIcon.color, Colors.amber);
    });

    testWidgets('should display total count with label', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        averageRating: 4.5,
        totalCount: 25,
      ));

      expect(find.textContaining('25'), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle large total count', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        averageRating: 4.2,
        totalCount: 1500,
      ));

      expect(find.textContaining('1500'), findsAtLeastNWidgets(1));
    });
  });
}

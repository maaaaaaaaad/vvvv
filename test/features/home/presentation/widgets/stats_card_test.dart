import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/widgets/stats_card.dart';

void main() {
  Widget buildTestWidget({
    required int reviewCount,
    required double averageRating,
    required int treatmentCount,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: StatsCard(
          reviewCount: reviewCount,
          averageRating: averageRating,
          treatmentCount: treatmentCount,
        ),
      ),
    );
  }

  group('StatsCard', () {
    testWidgets('should display review count', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
      ));

      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('should display average rating with one decimal', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
      ));

      expect(find.text('4.5'), findsOneWidget);
    });

    testWidgets('should display treatment count', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
      ));

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should display review icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
      ));

      expect(find.byIcon(Icons.reviews), findsOneWidget);
    });

    testWidgets('should display star icon for average rating', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
      ));

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('should display content_cut icon for treatment', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
      ));

      expect(find.byIcon(Icons.content_cut), findsOneWidget);
    });

    testWidgets('should use Card widget for container', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
      ));

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display star icon in amber color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
      ));

      final starIcon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(starIcon.color, Colors.amber);
    });

    testWidgets('should handle zero values correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        reviewCount: 0,
        averageRating: 0.0,
        treatmentCount: 0,
      ));

      expect(find.text('0'), findsNWidgets(2));
      expect(find.text('0.0'), findsOneWidget);
    });

    testWidgets('should display labels for each stat', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
      ));

      expect(find.text('리뷰 수'), findsOneWidget);
      expect(find.text('평균 별점'), findsOneWidget);
      expect(find.text('시술 수'), findsOneWidget);
    });

    testWidgets('should use grid layout with 3 items', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
      ));

      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('should use pastel pink color for icons except star', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        reviewCount: 10,
        averageRating: 4.5,
        treatmentCount: 5,
      ));

      final reviewsIcon = tester.widget<Icon>(find.byIcon(Icons.reviews));
      final treatmentIcon = tester.widget<Icon>(find.byIcon(Icons.content_cut));

      expect(reviewsIcon.color, const Color(0xFFFFB5BA));
      expect(treatmentIcon.color, const Color(0xFFFFB5BA));
    });
  });
}

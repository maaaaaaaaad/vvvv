import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/widgets/quick_actions_section.dart';

void main() {
  Widget buildTestWidget({
    VoidCallback? onTreatmentTap,
    VoidCallback? onReviewTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: QuickActionsSection(
          onTreatmentTap: onTreatmentTap ?? () {},
          onReviewTap: onReviewTap ?? () {},
        ),
      ),
    );
  }

  group('QuickActionsSection', () {
    testWidgets('should display header with "빠른 메뉴"', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('빠른 메뉴'), findsOneWidget);
    });

    testWidgets('should display treatment management button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('시술 관리'), findsOneWidget);
    });

    testWidgets('should display review management button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('리뷰 보기'), findsOneWidget);
    });

    testWidgets('should display content_cut icon for treatment', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byIcon(Icons.content_cut), findsOneWidget);
    });

    testWidgets('should display reviews icon for review', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byIcon(Icons.reviews), findsOneWidget);
    });

    testWidgets('should call onTreatmentTap when treatment button is tapped',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildTestWidget(
        onTreatmentTap: () => tapped = true,
      ));

      await tester.tap(find.text('시술 관리'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should call onReviewTap when review button is tapped',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildTestWidget(
        onReviewTap: () => tapped = true,
      ));

      await tester.tap(find.text('리뷰 보기'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should use Card widget for container', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should have buttons in Row layout', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final treatmentButton = find.text('시술 관리');
      final reviewButton = find.text('리뷰 보기');

      expect(treatmentButton, findsOneWidget);
      expect(reviewButton, findsOneWidget);
    });

    testWidgets('should use pastel pink color for icons', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final treatmentIcon = tester.widget<Icon>(find.byIcon(Icons.content_cut));
      final reviewIcon = tester.widget<Icon>(find.byIcon(Icons.reviews));

      expect(treatmentIcon.color, const Color(0xFFFFB5BA));
      expect(reviewIcon.color, const Color(0xFFFFB5BA));
    });
  });
}

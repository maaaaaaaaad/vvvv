import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/more/presentation/pages/about_page.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';

void main() {
  Widget buildTestWidget() {
    return const MaterialApp(
      home: AboutPage(),
    );
  }

  group('AboutPage', () {
    testWidgets('should display AppBar with title "앱 정보"', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('앱 정보'), findsOneWidget);
    });

    testWidgets('should display app name "젤로마크 사장님"', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('젤로마크 사장님'), findsOneWidget);
    });

    testWidgets('should display version info "v1.0.0"', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('v1.0.0'), findsOneWidget);
    });

    testWidgets('should display copyright info', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('© 2025 JelloMark. All rights reserved.'), findsOneWidget);
    });

    testWidgets('should display app icon or placeholder', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byIcon(Icons.storefront), findsOneWidget);
    });

    testWidgets('should use pastel pink color for app icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final icon = tester.widget<Icon>(find.byIcon(Icons.storefront));
      expect(icon.color, AppColors.pastelPink);
    });

    testWidgets('should have centered layout', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('should display back button in AppBar', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(BackButton), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/more/presentation/pages/settings_page.dart';

void main() {
  Widget buildTestWidget() {
    return const MaterialApp(
      home: SettingsPage(),
    );
  }

  group('SettingsPage', () {
    testWidgets('should display AppBar with title', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('설정'), findsOneWidget);
    });

    testWidgets('should display notification settings section', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('알림 설정'), findsOneWidget);
    });

    testWidgets('should display push notification switch', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('푸시 알림'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('should display dark mode item as disabled', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('다크 모드'), findsOneWidget);
      expect(find.text('추후 지원 예정'), findsOneWidget);
    });

    testWidgets('should toggle push notification switch', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      final switchWidget = tester.widget<Switch>(switchFinder);
      final initialValue = switchWidget.value;

      await tester.tap(switchFinder);
      await tester.pump();

      final updatedSwitchWidget = tester.widget<Switch>(switchFinder);
      expect(updatedSwitchWidget.value, !initialValue);
    });

    testWidgets('should display back button in AppBar', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('should display theme section', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('테마'), findsOneWidget);
    });

    testWidgets('should use ListTile for settings items', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(ListTile), findsAtLeast(2));
    });
  });
}

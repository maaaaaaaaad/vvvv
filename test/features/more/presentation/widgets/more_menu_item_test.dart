import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/more/presentation/widgets/more_menu_item.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';

void main() {
  Widget buildTestWidget({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: MoreMenuItem(
          icon: icon,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }

  group('MoreMenuItem', () {
    testWidgets('should display icon correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        icon: Icons.settings,
        title: '설정',
      ));

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('should display title correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        icon: Icons.settings,
        title: '설정',
      ));

      expect(find.text('설정'), findsOneWidget);
    });

    testWidgets('should display subtitle when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        icon: Icons.person,
        title: '프로필',
        subtitle: '계정 정보 관리',
      ));

      expect(find.text('프로필'), findsOneWidget);
      expect(find.text('계정 정보 관리'), findsOneWidget);
    });

    testWidgets('should not display subtitle when not provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        icon: Icons.settings,
        title: '설정',
      ));

      expect(find.text('설정'), findsOneWidget);
      final subtitleFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data != '설정',
      );
      expect(subtitleFinder, findsNothing);
    });

    testWidgets('should display trailing widget when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        icon: Icons.notifications,
        title: '알림',
        trailing: const Icon(Icons.chevron_right),
      ));

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('should not display trailing widget when not provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        icon: Icons.settings,
        title: '설정',
      ));

      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('should call onTap callback when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildTestWidget(
        icon: Icons.settings,
        title: '설정',
        onTap: () => tapped = true,
      ));

      await tester.tap(find.byType(MoreMenuItem));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should use Card widget for container', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        icon: Icons.settings,
        title: '설정',
      ));

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should use pastel pink color for icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        icon: Icons.settings,
        title: '설정',
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.settings));
      expect(icon.color, AppColors.pastelPink);
    });

    testWidgets('should display title with correct text style', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        icon: Icons.settings,
        title: '설정',
      ));

      final titleText = tester.widget<Text>(find.text('설정'));
      expect(titleText.style?.fontWeight, FontWeight.w500);
      expect(titleText.style?.fontSize, 16);
    });

    testWidgets('should display subtitle with correct text style when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        icon: Icons.person,
        title: '프로필',
        subtitle: '계정 정보 관리',
      ));

      final subtitleText = tester.widget<Text>(find.text('계정 정보 관리'));
      expect(subtitleText.style?.fontSize, 12);
      expect(subtitleText.style?.color, Colors.grey[600]);
    });

    testWidgets('should be tappable with InkWell', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        icon: Icons.settings,
        title: '설정',
        onTap: () {},
      ));

      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should display all elements correctly together', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        icon: Icons.person,
        title: '내 정보',
        subtitle: '프로필 수정',
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ));

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.text('내 정보'), findsOneWidget);
      expect(find.text('프로필 수정'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });
  });
}

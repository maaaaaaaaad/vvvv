import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/more/presentation/pages/more_tab.dart';
import 'package:jellomark_mobile_owner/features/more/presentation/widgets/more_menu_item.dart';

void main() {
  Widget buildTestWidget({
    VoidCallback? onProfileTap,
    VoidCallback? onSettingsTap,
    VoidCallback? onAboutTap,
    VoidCallback? onLogout,
  }) {
    return ProviderScope(
      child: MaterialApp(
        home: MoreTab(
          onProfileTap: onProfileTap ?? () {},
          onSettingsTap: onSettingsTap ?? () {},
          onAboutTap: onAboutTap ?? () {},
          onLogout: onLogout ?? () {},
        ),
      ),
    );
  }

  group('MoreTab', () {
    group('Section Headers', () {
      testWidgets('should display "내 정보" section header', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text('내 정보'), findsOneWidget);
      });

      testWidgets('should display "설정" section header', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        final sectionHeaders = find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data == '설정' &&
              widget.style?.fontWeight == FontWeight.w600,
        );
        expect(sectionHeaders, findsOneWidget);
      });

      testWidgets('should display "계정" section header', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text('계정'), findsOneWidget);
      });
    });

    group('Menu Items', () {
      testWidgets('should display profile menu item "내 정보 조회"',
          (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text('내 정보 조회'), findsOneWidget);
      });

      testWidgets('should display settings menu item', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        final settingsMenuItem = find.descendant(
          of: find.byType(MoreMenuItem),
          matching: find.text('설정'),
        );
        expect(settingsMenuItem, findsOneWidget);
      });

      testWidgets('should display about menu item "앱 정보"', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text('앱 정보'), findsOneWidget);
      });

      testWidgets('should display logout menu item "로그아웃"', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text('로그아웃'), findsOneWidget);
      });

      testWidgets('should use MoreMenuItem widgets for menu items',
          (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byType(MoreMenuItem), findsNWidgets(4));
      });
    });

    group('Menu Item Callbacks', () {
      testWidgets('should call onProfileTap when profile menu is tapped',
          (tester) async {
        var tapped = false;
        await tester.pumpWidget(buildTestWidget(
          onProfileTap: () => tapped = true,
        ));

        await tester.tap(find.text('내 정보 조회'));
        await tester.pump();

        expect(tapped, isTrue);
      });

      testWidgets('should call onSettingsTap when settings menu is tapped',
          (tester) async {
        var tapped = false;
        await tester.pumpWidget(buildTestWidget(
          onSettingsTap: () => tapped = true,
        ));

        final settingsMenuItem = find.ancestor(
          of: find.descendant(
            of: find.byType(MoreMenuItem),
            matching: find.text('설정'),
          ),
          matching: find.byType(MoreMenuItem),
        );
        await tester.tap(settingsMenuItem.first);
        await tester.pump();

        expect(tapped, isTrue);
      });

      testWidgets('should call onAboutTap when about menu is tapped',
          (tester) async {
        var tapped = false;
        await tester.pumpWidget(buildTestWidget(
          onAboutTap: () => tapped = true,
        ));

        await tester.tap(find.text('앱 정보'));
        await tester.pump();

        expect(tapped, isTrue);
      });
    });

    group('Logout Dialog', () {
      testWidgets('should show confirmation dialog when logout is tapped',
          (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('로그아웃'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
      });

      testWidgets('should display correct dialog title', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('로그아웃'));
        await tester.pumpAndSettle();

        expect(find.text('로그아웃 확인'), findsOneWidget);
      });

      testWidgets('should display correct dialog message', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('로그아웃'));
        await tester.pumpAndSettle();

        expect(find.text('정말 로그아웃 하시겠습니까?'), findsOneWidget);
      });

      testWidgets('should display cancel button in dialog', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('로그아웃'));
        await tester.pumpAndSettle();

        expect(find.text('취소'), findsOneWidget);
      });

      testWidgets('should display confirm button in dialog', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('로그아웃'));
        await tester.pumpAndSettle();

        expect(find.text('확인'), findsOneWidget);
      });

      testWidgets('should close dialog when cancel is tapped', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('로그아웃'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('취소'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets('should call onLogout when confirm is tapped',
          (tester) async {
        var loggedOut = false;
        await tester.pumpWidget(buildTestWidget(
          onLogout: () => loggedOut = true,
        ));

        await tester.tap(find.text('로그아웃'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('확인'));
        await tester.pumpAndSettle();

        expect(loggedOut, isTrue);
      });

      testWidgets('should close dialog after confirm is tapped',
          (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('로그아웃'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('확인'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
      });
    });

    group('Layout', () {
      testWidgets('should use Scaffold', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should use SingleChildScrollView for scrolling',
          (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('should display person icon for profile menu', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byIcon(Icons.person_outline), findsOneWidget);
      });

      testWidgets('should display settings icon for settings menu',
          (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      });

      testWidgets('should display info icon for about menu', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byIcon(Icons.info_outline), findsOneWidget);
      });

      testWidgets('should display logout icon for logout menu', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byIcon(Icons.logout), findsOneWidget);
      });
    });
  });
}

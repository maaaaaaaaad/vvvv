import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/shell/presentation/widgets/owner_bottom_nav_bar.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';

void main() {
  Widget buildTestWidget({
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: OwnerBottomNavBar(
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      ),
    );
  }

  group('OwnerBottomNavBar', () {
    testWidgets('should render 4 navigation items', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.items.length, 4);
    });

    testWidgets('should show home icon for first tab', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('should show store icon for second tab', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      expect(find.byIcon(Icons.store), findsOneWidget);
    });

    testWidgets('should show content_cut icon for third tab', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      expect(find.byIcon(Icons.content_cut), findsOneWidget);
    });

    testWidgets('should show more_horiz icon for fourth tab', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    });

    testWidgets('should show correct label for home tab', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      expect(find.text('홈'), findsOneWidget);
    });

    testWidgets('should show correct label for my shop tab', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      expect(find.text('내 샵'), findsOneWidget);
    });

    testWidgets('should show correct label for treatments tab', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      expect(find.text('시술'), findsOneWidget);
    });

    testWidgets('should show correct label for more tab', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      expect(find.text('더보기'), findsOneWidget);
    });

    testWidgets('should highlight selected tab with pastelPink color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.selectedItemColor, AppColors.pastelPink);
    });

    testWidgets('should show unselected items in grey', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.unselectedItemColor, Colors.grey);
    });

    testWidgets('should have white background color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.backgroundColor, Colors.white);
    });

    testWidgets('should use fixed type for navigation bar', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.type, BottomNavigationBarType.fixed);
    });

    testWidgets('should show selected labels', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.showSelectedLabels, true);
    });

    testWidgets('should show unselected labels', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.showUnselectedLabels, true);
    });

    testWidgets('should call onTap with index 0 when home tab is tapped', (tester) async {
      int? tappedIndex;
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 1,
        onTap: (index) => tappedIndex = index,
      ));

      await tester.tap(find.text('홈'));
      await tester.pump();

      expect(tappedIndex, 0);
    });

    testWidgets('should call onTap with index 1 when my shop tab is tapped', (tester) async {
      int? tappedIndex;
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (index) => tappedIndex = index,
      ));

      await tester.tap(find.text('내 샵'));
      await tester.pump();

      expect(tappedIndex, 1);
    });

    testWidgets('should call onTap with index 2 when treatments tab is tapped', (tester) async {
      int? tappedIndex;
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (index) => tappedIndex = index,
      ));

      await tester.tap(find.text('시술'));
      await tester.pump();

      expect(tappedIndex, 2);
    });

    testWidgets('should call onTap with index 3 when more tab is tapped', (tester) async {
      int? tappedIndex;
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (index) => tappedIndex = index,
      ));

      await tester.tap(find.text('더보기'));
      await tester.pump();

      expect(tappedIndex, 3);
    });

    testWidgets('should reflect currentIndex correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 2,
        onTap: (_) {},
      ));

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 2);
    });

    testWidgets('should render all 4 icons together', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.store), findsOneWidget);
      expect(find.byIcon(Icons.content_cut), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    });

    testWidgets('should render all 4 labels together', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        currentIndex: 0,
        onTap: (_) {},
      ));

      expect(find.text('홈'), findsOneWidget);
      expect(find.text('내 샵'), findsOneWidget);
      expect(find.text('시술'), findsOneWidget);
      expect(find.text('더보기'), findsOneWidget);
    });
  });
}

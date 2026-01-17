import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/shell/presentation/pages/main_shell.dart';

void main() {
  Widget buildTestWidget({
    String? shopId,
    String? shopName,
  }) {
    return ProviderScope(
      child: MaterialApp(
        home: MainShell(
          shopId: shopId,
          shopName: shopName,
        ),
      ),
    );
  }

  group('MainShell', () {
    testWidgets('renders Scaffold with BottomNavigationBar', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        shopId: 'shop-1',
        shopName: 'Test Shop',
      ));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('renders 4 navigation items with correct labels', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        shopId: 'shop-1',
        shopName: 'Test Shop',
      ));
      await tester.pumpAndSettle();

      expect(find.text('홈'), findsOneWidget);
      expect(find.text('내 샵'), findsOneWidget);
      expect(find.text('시술'), findsOneWidget);
      expect(find.text('더보기'), findsOneWidget);
    });

    testWidgets('shows HomeTab by default (index 0)', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        shopId: 'shop-1',
        shopName: 'Test Shop',
      ));
      await tester.pumpAndSettle();

      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNav.currentIndex, equals(0));
    });

    testWidgets('uses IndexedStack to preserve tab state', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        shopId: 'shop-1',
        shopName: 'Test Shop',
      ));
      await tester.pumpAndSettle();

      expect(find.byType(IndexedStack), findsOneWidget);
    });

    testWidgets('IndexedStack has 4 children for each tab', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        shopId: 'shop-1',
        shopName: 'Test Shop',
      ));
      await tester.pumpAndSettle();

      final indexedStack = tester.widget<IndexedStack>(
        find.byType(IndexedStack),
      );
      expect(indexedStack.children.length, equals(4));
    });

    testWidgets('switching to tab 1 (내 샵) updates currentIndex', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        shopId: 'shop-1',
        shopName: 'Test Shop',
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('내 샵'));
      await tester.pumpAndSettle();

      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNav.currentIndex, equals(1));
    });

    testWidgets('switching to tab 2 (시술) updates currentIndex', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        shopId: 'shop-1',
        shopName: 'Test Shop',
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('시술'));
      await tester.pumpAndSettle();

      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNav.currentIndex, equals(2));
    });

    testWidgets('switching to tab 3 (더보기) updates currentIndex', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        shopId: 'shop-1',
        shopName: 'Test Shop',
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('더보기'));
      await tester.pumpAndSettle();

      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNav.currentIndex, equals(3));
    });

    testWidgets('IndexedStack index matches selected tab', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        shopId: 'shop-1',
        shopName: 'Test Shop',
      ));
      await tester.pumpAndSettle();

      var indexedStack = tester.widget<IndexedStack>(
        find.byType(IndexedStack),
      );
      expect(indexedStack.index, equals(0));

      await tester.tap(find.text('내 샵'));
      await tester.pumpAndSettle();

      indexedStack = tester.widget<IndexedStack>(
        find.byType(IndexedStack),
      );
      expect(indexedStack.index, equals(1));
    });

    testWidgets('preserves tab state when switching between tabs', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        shopId: 'shop-1',
        shopName: 'Test Shop',
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('시술'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('홈'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('시술'));
      await tester.pumpAndSettle();

      final indexedStack = tester.widget<IndexedStack>(
        find.byType(IndexedStack),
      );
      expect(indexedStack.index, equals(2));
    });

    testWidgets('BottomNavigationBar has correct icons', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        shopId: 'shop-1',
        shopName: 'Test Shop',
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.store_outlined), findsOneWidget);
      expect(find.byIcon(Icons.spa_outlined), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz), findsWidgets);
    });

    testWidgets('works with null shopId (shows empty shop state)', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        shopId: null,
        shopName: null,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('displays placeholder for HomeTab when no shop', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        shopId: null,
        shopName: null,
      ));
      await tester.pumpAndSettle();

      expect(find.text('샵을 먼저 등록해주세요'), findsOneWidget);
    });

    testWidgets('HomeTab placeholder has button to navigate to shop tab', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        shopId: null,
        shopName: null,
      ));
      await tester.pumpAndSettle();

      expect(find.text('샵 등록하러 가기'), findsOneWidget);

      await tester.tap(find.text('샵 등록하러 가기'));
      await tester.pumpAndSettle();

      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNav.currentIndex, equals(1));
    });
  });
}

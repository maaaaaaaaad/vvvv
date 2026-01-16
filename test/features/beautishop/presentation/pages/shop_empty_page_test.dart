import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/beautishop/presentation/pages/shop_empty_page.dart';

void main() {
  Widget createTestWidget({VoidCallback? onRegisterShop}) {
    return MaterialApp(
      home: ShopEmptyPage(onRegisterShop: onRegisterShop ?? () {}),
    );
  }

  group('ShopEmptyPage', () {
    testWidgets('should display empty message', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('아직 등록된 샵이 없습니다'), findsOneWidget);
    });

    testWidgets('should display register button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('샵 등록하기'), findsOneWidget);
    });

    testWidgets('should display store icon', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.store_outlined), findsOneWidget);
    });

    testWidgets('should call onRegisterShop when register button is pressed',
        (tester) async {
      var registerCalled = false;

      await tester.pumpWidget(createTestWidget(
        onRegisterShop: () => registerCalled = true,
      ));

      await tester.tap(find.text('샵 등록하기'));
      await tester.pumpAndSettle();

      expect(registerCalled, isTrue);
    });

    testWidgets('should display sub message', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('샵을 등록하고 관리를 시작하세요'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/usecases/create_shop_usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/presentation/widgets/shop_create_bottom_sheet.dart';

void main() {
  Widget createTestWidget({
    void Function(CreateShopParams params)? onCreate,
    bool isCreating = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ShopCreateBottomSheet(
          onCreate: onCreate ?? (_) {},
          isCreating: isCreating,
        ),
      ),
    );
  }

  group('ShopCreateBottomSheet', () {
    testWidgets('should display title', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('샵 등록'), findsOneWidget);
    });

    testWidgets('should display shop name field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('샵 이름'), findsOneWidget);
    });

    testWidgets('should display shop registration number field',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('사업자등록번호'), findsOneWidget);
    });

    testWidgets('should display phone number field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('전화번호'), findsOneWidget);
    });

    testWidgets('should display address field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('주소'), findsOneWidget);
    });

    testWidgets('should display operating time field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('영업시간'), findsOneWidget);
    });

    testWidgets('should display create button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.scrollUntilVisible(
        find.text('등록하기'),
        500,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('등록하기'), findsOneWidget);
    });

    testWidgets('should show validation error when shop name is empty',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.scrollUntilVisible(
        find.text('등록하기'),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('등록하기'));
      await tester.pumpAndSettle();

      expect(find.text('샵 이름을 입력해주세요'), findsOneWidget);
    });

    testWidgets('should show loading indicator when isCreating is true',
        (tester) async {
      await tester.pumpWidget(createTestWidget(isCreating: true));

      await tester.scrollUntilVisible(
        find.byType(CircularProgressIndicator),
        500,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have autofocus false on all TextFields',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(
        tester.testTextInput.isVisible,
        isFalse,
      );
    });

    testWidgets('should call onCreate with params when form is valid',
        (tester) async {
      CreateShopParams? savedParams;

      await tester.pumpWidget(createTestWidget(
        onCreate: (params) => savedParams = params,
      ));

      await tester.enterText(
        find.widgetWithText(TextFormField, '샵 이름'),
        'My Shop',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, '사업자등록번호'),
        '1234567890',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, '전화번호'),
        '02-1234-5678',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, '주소'),
        'Seoul, Korea',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, '영업시간'),
        '09:00-18:00',
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('등록하기'),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('등록하기'));
      await tester.pumpAndSettle();

      expect(savedParams, isNotNull);
      expect(savedParams!.shopName, 'My Shop');
    });
  });
}

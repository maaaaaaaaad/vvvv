import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/category_summary.dart';
import 'package:jellomark_mobile_owner/features/beautishop/presentation/pages/shop_edit_page.dart';

void main() {
  final tBeautishop = Beautishop(
    id: 'shop-uuid',
    name: 'Test Beauty Shop',
    regNum: '1234567890',
    phoneNumber: '02-1234-5678',
    address: 'Seoul, Korea',
    latitude: 37.5665,
    longitude: 126.9780,
    operatingTime: const {'MON': '09:00-18:00', 'TUE': '09:00-18:00'},
    description: 'A beautiful shop',
    image: 'https://example.com/image.jpg',
    averageRating: 4.5,
    reviewCount: 100,
    categories: const [CategorySummary(id: 'cat-1', name: 'Hair')],
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  Widget createTestWidget({
    required Beautishop shop,
    void Function(Map<String, String>? operatingTime, String? description, String? image)?
        onSave,
    bool isUpdating = false,
  }) {
    return MaterialApp(
      home: ShopEditPage(
        shop: shop,
        onSave: onSave ?? (a, b, c) {},
        isUpdating: isUpdating,
      ),
    );
  }

  group('ShopEditPage', () {
    testWidgets('should display AppBar with title', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('샵 정보 수정'), findsOneWidget);
    });

    testWidgets('should display shop name as read-only info', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('Test Beauty Shop'), findsOneWidget);
    });

    testWidgets('should display description field', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('샵 소개'), findsOneWidget);
    });

    testWidgets('should display image URL field', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('이미지 URL'), findsOneWidget);
    });

    testWidgets('should display save button', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('저장'), findsOneWidget);
    });

    testWidgets('should pre-fill description with current value',
        (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('A beautiful shop'), findsOneWidget);
    });

    testWidgets('should show loading when isUpdating is true', (tester) async {
      await tester.pumpWidget(createTestWidget(
        shop: tBeautishop,
        isUpdating: true,
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should disable save button when isUpdating is true',
        (tester) async {
      var saveCalled = false;

      await tester.pumpWidget(createTestWidget(
        shop: tBeautishop,
        onSave: (a, b, c) => saveCalled = true,
        isUpdating: true,
      ));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(saveCalled, isFalse);
    });

    testWidgets('should call onSave with updated values when save is pressed',
        (tester) async {
      String? savedDescription;

      await tester.pumpWidget(createTestWidget(
        shop: tBeautishop,
        onSave: (a, description, c) => savedDescription = description,
      ));

      final descriptionField = find.byType(TextFormField).first;
      await tester.enterText(descriptionField, 'Updated description');
      await tester.pumpAndSettle();

      await tester.tap(find.text('저장'));
      await tester.pumpAndSettle();

      expect(savedDescription, 'Updated description');
    });

    testWidgets('should dismiss keyboard when tapping outside',
        (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      await tester.tap(find.byType(TextFormField).first);
      await tester.pump();

      expect(
        tester.testTextInput.isVisible,
        isTrue,
      );

      await tester.tapAt(const Offset(0, 0));
      await tester.pump();
    });

    testWidgets('should not auto focus on any TextField on page load',
        (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));
      await tester.pump();

      expect(
        tester.testTextInput.isVisible,
        isFalse,
      );
    });
  });
}

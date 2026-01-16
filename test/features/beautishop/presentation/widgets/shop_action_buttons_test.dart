import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/beautishop/presentation/widgets/shop_action_buttons.dart';

void main() {
  Widget createTestWidget({
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    bool isDeleting = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ShopActionButtons(
          onEdit: onEdit,
          onDelete: onDelete,
          isDeleting: isDeleting,
        ),
      ),
    );
  }

  group('ShopActionButtons', () {
    testWidgets('should display edit button', (tester) async {
      await tester.pumpWidget(createTestWidget(
        onEdit: () {},
        onDelete: () {},
      ));

      expect(find.text('수정'), findsOneWidget);
    });

    testWidgets('should display delete button', (tester) async {
      await tester.pumpWidget(createTestWidget(
        onEdit: () {},
        onDelete: () {},
      ));

      expect(find.text('삭제'), findsOneWidget);
    });

    testWidgets('should display edit icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        onEdit: () {},
        onDelete: () {},
      ));

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('should display delete icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        onEdit: () {},
        onDelete: () {},
      ));

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('should call onEdit when edit button is pressed',
        (tester) async {
      var editCalled = false;

      await tester.pumpWidget(createTestWidget(
        onEdit: () => editCalled = true,
        onDelete: () {},
      ));

      await tester.tap(find.text('수정'));
      await tester.pumpAndSettle();

      expect(editCalled, isTrue);
    });

    testWidgets('should show confirmation dialog when delete button is pressed',
        (tester) async {
      await tester.pumpWidget(createTestWidget(
        onEdit: () {},
        onDelete: () {},
      ));

      await tester.tap(find.text('삭제'));
      await tester.pumpAndSettle();

      expect(find.text('샵 삭제'), findsOneWidget);
      expect(find.text('정말로 샵을 삭제하시겠습니까?'), findsOneWidget);
    });

    testWidgets('should call onDelete when confirmed in dialog',
        (tester) async {
      var deleteCalled = false;

      await tester.pumpWidget(createTestWidget(
        onEdit: () {},
        onDelete: () => deleteCalled = true,
      ));

      await tester.tap(find.text('삭제'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('삭제하기'));
      await tester.pumpAndSettle();

      expect(deleteCalled, isTrue);
    });

    testWidgets('should not call onDelete when cancelled in dialog',
        (tester) async {
      var deleteCalled = false;

      await tester.pumpWidget(createTestWidget(
        onEdit: () {},
        onDelete: () => deleteCalled = true,
      ));

      await tester.tap(find.text('삭제'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();

      expect(deleteCalled, isFalse);
    });

    testWidgets('should show loading indicator when deleting', (tester) async {
      await tester.pumpWidget(createTestWidget(
        onEdit: () {},
        onDelete: () {},
        isDeleting: true,
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should disable buttons when deleting', (tester) async {
      var editCalled = false;

      await tester.pumpWidget(createTestWidget(
        onEdit: () => editCalled = true,
        onDelete: () {},
        isDeleting: true,
      ));

      await tester.tap(find.text('수정'));
      await tester.pump();

      expect(editCalled, isFalse);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/category_summary.dart';
import 'package:jellomark_mobile_owner/features/beautishop/presentation/pages/shop_detail_page.dart';
import 'package:jellomark_mobile_owner/features/beautishop/presentation/widgets/shop_action_buttons.dart';
import 'package:jellomark_mobile_owner/features/beautishop/presentation/widgets/shop_info_card.dart';

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
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    Future<void> Function()? onRefresh,
    bool isDeleting = false,
  }) {
    return MaterialApp(
      home: ShopDetailPage(
        shop: shop,
        onEdit: onEdit ?? () {},
        onDelete: onDelete ?? () {},
        onRefresh: onRefresh ?? () async {},
        isDeleting: isDeleting,
      ),
    );
  }

  group('ShopDetailPage', () {
    testWidgets('should display AppBar with title', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('내 샵'), findsOneWidget);
    });

    testWidgets('should display ShopInfoCard', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.byType(ShopInfoCard), findsOneWidget);
    });

    testWidgets('should display shop name from ShopInfoCard', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('Test Beauty Shop'), findsOneWidget);
    });

    testWidgets('should display ShopActionButtons', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.byType(ShopActionButtons), findsOneWidget);
    });

    testWidgets('should display edit and delete buttons', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('수정'), findsOneWidget);
      expect(find.text('삭제'), findsOneWidget);
    });

    testWidgets('should call onEdit when edit button is pressed',
        (tester) async {
      var editCalled = false;

      await tester.pumpWidget(createTestWidget(
        shop: tBeautishop,
        onEdit: () => editCalled = true,
      ));

      await tester.tap(find.text('수정'));
      await tester.pumpAndSettle();

      expect(editCalled, isTrue);
    });

    testWidgets('should support pull to refresh', (tester) async {
      var refreshCalled = false;

      await tester.pumpWidget(createTestWidget(
        shop: tBeautishop,
        onRefresh: () async {
          refreshCalled = true;
        },
      ));

      await tester.fling(
        find.byType(RefreshIndicator),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      expect(refreshCalled, isTrue);
    });

    testWidgets('should pass isDeleting to ShopActionButtons', (tester) async {
      await tester.pumpWidget(createTestWidget(
        shop: tBeautishop,
        isDeleting: true,
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}

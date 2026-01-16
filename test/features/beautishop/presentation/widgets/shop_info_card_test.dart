import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/category_summary.dart';
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
    categories: const [
      CategorySummary(id: 'cat-1', name: 'Hair'),
      CategorySummary(id: 'cat-2', name: 'Nail'),
    ],
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final tBeautishopWithoutImage = Beautishop(
    id: 'shop-uuid',
    name: 'Test Shop No Image',
    regNum: '1234567890',
    phoneNumber: '02-1234-5678',
    address: 'Seoul, Korea',
    latitude: 37.5665,
    longitude: 126.9780,
    operatingTime: const {'MON': '09:00-18:00'},
    averageRating: 0.0,
    reviewCount: 0,
    categories: const [],
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  Widget createTestWidget({required Beautishop shop}) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: ShopInfoCard(shop: shop),
        ),
      ),
    );
  }

  group('ShopInfoCard', () {
    testWidgets('should display shop name', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('Test Beauty Shop'), findsOneWidget);
    });

    testWidgets('should display shop address', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('Seoul, Korea'), findsOneWidget);
    });

    testWidgets('should display shop phone number', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('02-1234-5678'), findsOneWidget);
    });

    testWidgets('should display average rating', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('4.5'), findsOneWidget);
    });

    testWidgets('should display review count', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('(100)'), findsOneWidget);
    });

    testWidgets('should display category chips', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('Hair'), findsOneWidget);
      expect(find.text('Nail'), findsOneWidget);
    });

    testWidgets('should display star icon for rating', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('should display location icon', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('should display phone icon', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.byIcon(Icons.phone), findsOneWidget);
    });

    testWidgets('should display placeholder when no image', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishopWithoutImage));

      expect(find.byIcon(Icons.store), findsOneWidget);
    });

    testWidgets('should display description when available', (tester) async {
      await tester.pumpWidget(createTestWidget(shop: tBeautishop));

      expect(find.text('A beautiful shop'), findsOneWidget);
    });
  });
}

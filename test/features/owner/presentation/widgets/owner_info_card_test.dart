import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/features/owner/presentation/widgets/owner_info_card.dart';

void main() {
  final tOwner = Owner(
    id: 'test-uuid',
    nickname: 'testshop',
    email: 'owner@example.com',
    businessNumber: '1234567890',
    phoneNumber: '010-1234-5678',
    createdAt: DateTime(2024, 1, 15),
    updatedAt: DateTime(2024, 1, 15),
  );

  Widget createTestWidget({required Owner owner}) {
    return MaterialApp(
      home: Scaffold(
        body: OwnerInfoCard(owner: owner),
      ),
    );
  }

  group('OwnerInfoCard', () {
    testWidgets('should display owner nickname', (tester) async {
      await tester.pumpWidget(createTestWidget(owner: tOwner));

      expect(find.text('testshop'), findsOneWidget);
    });

    testWidgets('should display owner email', (tester) async {
      await tester.pumpWidget(createTestWidget(owner: tOwner));

      expect(find.text('owner@example.com'), findsOneWidget);
    });

    testWidgets('should display owner business number', (tester) async {
      await tester.pumpWidget(createTestWidget(owner: tOwner));

      expect(find.text('1234567890'), findsOneWidget);
    });

    testWidgets('should display owner phone number', (tester) async {
      await tester.pumpWidget(createTestWidget(owner: tOwner));

      expect(find.text('010-1234-5678'), findsOneWidget);
    });

    testWidgets('should display formatted created date', (tester) async {
      await tester.pumpWidget(createTestWidget(owner: tOwner));

      expect(find.text('2024.01.15'), findsOneWidget);
    });

    testWidgets('should display person icon', (tester) async {
      await tester.pumpWidget(createTestWidget(owner: tOwner));

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should display email label', (tester) async {
      await tester.pumpWidget(createTestWidget(owner: tOwner));

      expect(find.text('이메일'), findsOneWidget);
    });

    testWidgets('should display business number label', (tester) async {
      await tester.pumpWidget(createTestWidget(owner: tOwner));

      expect(find.text('사업자등록번호'), findsOneWidget);
    });

    testWidgets('should display phone number label', (tester) async {
      await tester.pumpWidget(createTestWidget(owner: tOwner));

      expect(find.text('휴대폰 번호'), findsOneWidget);
    });

    testWidgets('should display created at label', (tester) async {
      await tester.pumpWidget(createTestWidget(owner: tOwner));

      expect(find.text('가입일'), findsOneWidget);
    });
  });
}

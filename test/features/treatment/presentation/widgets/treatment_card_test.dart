import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/widgets/treatment_card.dart';

void main() {
  final tTreatment = Treatment(
    id: 'treatment-uuid',
    name: 'Test Treatment',
    description: 'A test treatment description',
    price: 50000,
    duration: 60,
    imageUrl: 'https://example.com/image.jpg',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final tTreatmentWithoutDescription = Treatment(
    id: 'treatment-uuid-2',
    name: 'Simple Treatment',
    price: 30000,
    duration: 30,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  Widget createTestWidget({
    required Treatment treatment,
    VoidCallback? onTap,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: TreatmentCard(
          treatment: treatment,
          onTap: onTap,
          onEdit: onEdit,
          onDelete: onDelete,
        ),
      ),
    );
  }

  group('TreatmentCard', () {
    testWidgets('should display treatment name', (tester) async {
      await tester.pumpWidget(createTestWidget(treatment: tTreatment));

      expect(find.text('Test Treatment'), findsOneWidget);
    });

    testWidgets('should display treatment description when available',
        (tester) async {
      await tester.pumpWidget(createTestWidget(treatment: tTreatment));

      expect(find.text('A test treatment description'), findsOneWidget);
    });

    testWidgets('should not display description when not available',
        (tester) async {
      await tester
          .pumpWidget(createTestWidget(treatment: tTreatmentWithoutDescription));

      expect(find.text('A test treatment description'), findsNothing);
    });

    testWidgets('should display formatted price', (tester) async {
      await tester.pumpWidget(createTestWidget(treatment: tTreatment));

      expect(find.textContaining('50,000'), findsOneWidget);
    });

    testWidgets('should display duration in minutes', (tester) async {
      await tester.pumpWidget(createTestWidget(treatment: tTreatment));

      expect(find.textContaining('60'), findsOneWidget);
    });

    testWidgets('should call onTap when card is tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(createTestWidget(
        treatment: tTreatment,
        onTap: () => tapped = true,
      ));

      await tester.tap(find.byType(TreatmentCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('should call onEdit when edit button is pressed',
        (tester) async {
      var editCalled = false;

      await tester.pumpWidget(createTestWidget(
        treatment: tTreatment,
        onEdit: () => editCalled = true,
      ));

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(editCalled, isTrue);
    });

    testWidgets('should call onDelete when delete button is pressed',
        (tester) async {
      var deleteCalled = false;

      await tester.pumpWidget(createTestWidget(
        treatment: tTreatment,
        onDelete: () => deleteCalled = true,
      ));

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(deleteCalled, isTrue);
    });

    testWidgets('should display timer icon for duration', (tester) async {
      await tester.pumpWidget(createTestWidget(treatment: tTreatment));

      expect(find.byIcon(Icons.timer), findsOneWidget);
    });

    testWidgets('should not show edit button when onEdit is null',
        (tester) async {
      await tester.pumpWidget(createTestWidget(treatment: tTreatment));

      expect(find.byIcon(Icons.edit), findsNothing);
    });

    testWidgets('should not show delete button when onDelete is null',
        (tester) async {
      await tester.pumpWidget(createTestWidget(treatment: tTreatment));

      expect(find.byIcon(Icons.delete), findsNothing);
    });
  });
}

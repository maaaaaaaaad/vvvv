import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/widgets/treatment_form.dart';

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

  Widget createTestWidget({
    Treatment? initialTreatment,
    void Function(
      String name,
      String? description,
      int price,
      int duration,
      String? imageUrl,
    )?
    onSubmit,
    bool isSubmitting = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: TreatmentForm(
          initialTreatment: initialTreatment,
          onSubmit: onSubmit ?? (_, __, ___, ____, _____) {},
          isSubmitting: isSubmitting,
        ),
      ),
    );
  }

  group('TreatmentForm', () {
    testWidgets('should display name field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.widgetWithText(TextFormField, '시술명'), findsOneWidget);
    });

    testWidgets('should display description field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.widgetWithText(TextFormField, '설명'), findsOneWidget);
    });

    testWidgets('should display price field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.widgetWithText(TextFormField, '가격'), findsOneWidget);
    });

    testWidgets('should display duration field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.widgetWithText(TextFormField, '소요시간 (분)'), findsOneWidget);
    });

    testWidgets('should display image URL field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.widgetWithText(TextFormField, '이미지 URL'), findsOneWidget);
    });

    testWidgets('should prefill fields when initialTreatment is provided', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(initialTreatment: tTreatment));

      expect(find.text('Test Treatment'), findsOneWidget);
      expect(find.text('A test treatment description'), findsOneWidget);
      expect(find.text('50000'), findsOneWidget);
      expect(find.text('60'), findsOneWidget);
    });

    testWidgets('should show error when name is empty', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('저장'));
      await tester.pumpAndSettle();

      expect(find.text('시술명을 입력해주세요'), findsWidgets);
    });

    testWidgets('should show error when price is empty', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.widgetWithText(TextFormField, '시술명'), 'Test');
      await tester.enterText(
        find.widgetWithText(TextFormField, '소요시간 (분)'),
        '30',
      );

      await tester.tap(find.text('저장'));
      await tester.pumpAndSettle();

      expect(find.text('값을 입력해주세요'), findsWidgets);
    });

    testWidgets('should show error when duration is zero', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.widgetWithText(TextFormField, '시술명'), 'Test');
      await tester.enterText(find.widgetWithText(TextFormField, '가격'), '10000');
      await tester.enterText(
        find.widgetWithText(TextFormField, '소요시간 (분)'),
        '0',
      );

      await tester.tap(find.text('저장'));
      await tester.pumpAndSettle();

      expect(find.text('0보다 큰 값을 입력해주세요'), findsOneWidget);
    });

    testWidgets('should call onSubmit with correct values when form is valid', (
      tester,
    ) async {
      String? submittedName;
      String? submittedDescription;
      int? submittedPrice;
      int? submittedDuration;

      await tester.pumpWidget(
        createTestWidget(
          onSubmit: (name, description, price, duration, imageUrl) {
            submittedName = name;
            submittedDescription = description;
            submittedPrice = price;
            submittedDuration = duration;
          },
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, '시술명'),
        'New Treatment',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, '설명'),
        'Description',
      );
      await tester.enterText(find.widgetWithText(TextFormField, '가격'), '25000');
      await tester.enterText(
        find.widgetWithText(TextFormField, '소요시간 (분)'),
        '45',
      );

      await tester.tap(find.text('저장'));
      await tester.pumpAndSettle();

      expect(submittedName, 'New Treatment');
      expect(submittedDescription, 'Description');
      expect(submittedPrice, 25000);
      expect(submittedDuration, 45);
    });

    testWidgets('should disable submit button when isSubmitting is true', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(isSubmitting: true));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('should show loading indicator when isSubmitting is true', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(isSubmitting: true));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should not have autofocus on any field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsWidgets);
    });
  });
}

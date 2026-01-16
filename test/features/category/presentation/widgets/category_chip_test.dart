import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';
import 'package:jellomark_mobile_owner/features/category/presentation/widgets/category_chip.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';

void main() {
  final testCategory = Category(
    id: 'cat-1',
    name: '네일',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  Widget buildTestWidget({
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: CategoryChip(
          category: testCategory,
          isSelected: isSelected,
          onTap: onTap,
        ),
      ),
    );
  }

  group('CategoryChip', () {
    testWidgets('should display category name', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        isSelected: false,
        onTap: () {},
      ));

      expect(find.text('네일'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildTestWidget(
        isSelected: false,
        onTap: () => tapped = true,
      ));

      await tester.tap(find.byType(CategoryChip));
      expect(tapped, isTrue);
    });

    testWidgets('should have white background when not selected',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        isSelected: false,
        onTap: () {},
      ));

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.white);
    });

    testWidgets('should have pastel pink background when selected',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        isSelected: true,
        onTap: () {},
      ));

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.pastelPink);
    });

    testWidgets('should have border with accent pink when selected',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        isSelected: true,
        onTap: () {},
      ));

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
      final border = decoration.border as Border;
      expect(border.top.color, AppColors.accentPink);
      expect(border.top.width, 2);
    });

    testWidgets('should have white text color when selected', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        isSelected: true,
        onTap: () {},
      ));

      final textWidget = tester.widget<Text>(find.text('네일'));
      expect(textWidget.style?.color, Colors.white);
    });

    testWidgets('should have textPrimary color when not selected',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        isSelected: false,
        onTap: () {},
      ));

      final textWidget = tester.widget<Text>(find.text('네일'));
      expect(textWidget.style?.color, AppColors.textPrimary);
    });

    testWidgets('should have boxShadow when selected', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        isSelected: true,
        onTap: () {},
      ));

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, 1);
    });

    testWidgets('should not have boxShadow when not selected', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        isSelected: false,
        onTap: () {},
      ));

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNull);
    });
  });
}

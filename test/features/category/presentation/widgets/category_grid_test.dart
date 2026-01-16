import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';
import 'package:jellomark_mobile_owner/features/category/presentation/widgets/category_chip.dart';
import 'package:jellomark_mobile_owner/features/category/presentation/widgets/category_grid.dart';

void main() {
  final testCategories = [
    Category(
      id: 'cat-1',
      name: '네일',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    Category(
      id: 'cat-2',
      name: '헤어',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    Category(
      id: 'cat-3',
      name: '피부관리',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
  ];

  Widget buildTestWidget({
    required List<Category> categories,
    required Set<String> selectedCategoryIds,
    required void Function(String) onCategoryTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: CategoryGrid(
          categories: categories,
          selectedCategoryIds: selectedCategoryIds,
          onCategoryTap: onCategoryTap,
        ),
      ),
    );
  }

  group('CategoryGrid', () {
    testWidgets('should display all categories', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        categories: testCategories,
        selectedCategoryIds: {},
        onCategoryTap: (_) {},
      ));

      expect(find.text('네일'), findsOneWidget);
      expect(find.text('헤어'), findsOneWidget);
      expect(find.text('피부관리'), findsOneWidget);
    });

    testWidgets('should render CategoryChip for each category', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        categories: testCategories,
        selectedCategoryIds: {},
        onCategoryTap: (_) {},
      ));

      expect(find.byType(CategoryChip), findsNWidgets(3));
    });

    testWidgets('should use Wrap widget for layout', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        categories: testCategories,
        selectedCategoryIds: {},
        onCategoryTap: (_) {},
      ));

      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('should call onCategoryTap with correct id when chip is tapped',
        (tester) async {
      String? tappedId;
      await tester.pumpWidget(buildTestWidget(
        categories: testCategories,
        selectedCategoryIds: {},
        onCategoryTap: (id) => tappedId = id,
      ));

      await tester.tap(find.text('헤어'));
      expect(tappedId, 'cat-2');
    });

    testWidgets('should mark selected categories as selected', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        categories: testCategories,
        selectedCategoryIds: {'cat-1', 'cat-3'},
        onCategoryTap: (_) {},
      ));

      final chips = tester.widgetList<CategoryChip>(find.byType(CategoryChip));
      final chipList = chips.toList();

      expect(chipList[0].isSelected, isTrue);
      expect(chipList[1].isSelected, isFalse);
      expect(chipList[2].isSelected, isTrue);
    });

    testWidgets('should handle empty categories list', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        categories: [],
        selectedCategoryIds: {},
        onCategoryTap: (_) {},
      ));

      expect(find.byType(CategoryChip), findsNothing);
      expect(find.byType(Wrap), findsOneWidget);
    });
  });
}

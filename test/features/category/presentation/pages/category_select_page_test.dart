import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/category/domain/entities/category.dart';
import 'package:jellomark_mobile_owner/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:jellomark_mobile_owner/features/category/domain/usecases/set_shop_categories_usecase.dart';
import 'package:jellomark_mobile_owner/features/category/presentation/pages/category_select_page.dart';
import 'package:jellomark_mobile_owner/features/category/presentation/providers/category_providers.dart';
import 'package:jellomark_mobile_owner/features/category/presentation/widgets/category_grid.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

class MockSetShopCategoriesUseCase extends Mock
    implements SetShopCategoriesUseCase {}

void main() {
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockSetShopCategoriesUseCase mockSetShopCategoriesUseCase;

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
      name: '메이크업',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
  ];

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const SetShopCategoriesParams(shopId: 'shop-1', categoryIds: []),
    );
  });

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockSetShopCategoriesUseCase = MockSetShopCategoriesUseCase();
  });

  Widget createTestWidget({
    String shopId = 'shop-1',
    Set<String> initialSelectedIds = const {},
    void Function(List<String> categoryIds)? onSaved,
  }) {
    return ProviderScope(
      overrides: [
        categoryStateProvider.overrideWith((ref) {
          return CategoryStateNotifier(
            getCategoriesUseCase: mockGetCategoriesUseCase,
            setShopCategoriesUseCase: mockSetShopCategoriesUseCase,
          );
        }),
      ],
      child: MaterialApp(
        home: CategorySelectPage(
          shopId: shopId,
          initialSelectedIds: initialSelectedIds,
          onSaved: onSaved,
        ),
      ),
    );
  }

  group('CategorySelectPage', () {
    testWidgets('should display AppBar with title', (tester) async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(testCategories));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('카테고리 설정'), findsOneWidget);
    });

    testWidgets('should display loading indicator during initial loading',
        (tester) async {
      final completer = Completer<Either<Failure, List<Category>>>();
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(Right(testCategories));
      await tester.pumpAndSettle();
    });

    testWidgets('should display category list when loaded', (tester) async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(testCategories));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(CategoryGrid), findsOneWidget);
      expect(find.text('네일'), findsOneWidget);
      expect(find.text('헤어'), findsOneWidget);
      expect(find.text('메이크업'), findsOneWidget);
    });

    testWidgets('should display initial selected categories', (tester) async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(testCategories));

      await tester.pumpWidget(createTestWidget(
        initialSelectedIds: {'cat-1', 'cat-2'},
      ));
      await tester.pumpAndSettle();

      expect(find.text('2개 선택됨'), findsOneWidget);
    });

    testWidgets('should toggle category selection when tapped', (tester) async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(testCategories));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('0개 선택됨'), findsOneWidget);

      await tester.tap(find.text('네일'));
      await tester.pumpAndSettle();

      expect(find.text('1개 선택됨'), findsOneWidget);

      await tester.tap(find.text('네일'));
      await tester.pumpAndSettle();

      expect(find.text('0개 선택됨'), findsOneWidget);
    });

    testWidgets('should display save button in AppBar when loaded',
        (tester) async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(testCategories));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('저장'), findsOneWidget);
    });

    testWidgets('should display error message and retry button on error',
        (tester) async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure('서버 오류가 발생했습니다')));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('서버 오류가 발생했습니다'), findsOneWidget);
      expect(find.text('다시 시도'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should reload categories when retry button is pressed',
        (tester) async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure('서버 오류')));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('다시 시도'), findsOneWidget);

      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(testCategories));

      await tester.tap(find.text('다시 시도'));
      await tester.pumpAndSettle();

      expect(find.text('네일'), findsOneWidget);
      expect(find.text('헤어'), findsOneWidget);
    });

    testWidgets('should display instruction text', (tester) async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(testCategories));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('샵에 해당하는 카테고리를 선택해주세요'), findsOneWidget);
    });

    testWidgets('should display selection count text', (tester) async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(testCategories));

      await tester.pumpWidget(createTestWidget(
        initialSelectedIds: {'cat-1'},
      ));
      await tester.pumpAndSettle();

      expect(find.text('1개 선택됨'), findsOneWidget);
    });

    testWidgets('should call usecase to save categories when save is pressed',
        (tester) async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(testCategories));
      when(() => mockSetShopCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(testCategories));

      await tester.pumpWidget(createTestWidget(
        shopId: 'test-shop-id',
        initialSelectedIds: {'cat-1'},
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('저장'));
      await tester.pump();

      verify(() => mockSetShopCategoriesUseCase(
            const SetShopCategoriesParams(
              shopId: 'test-shop-id',
              categoryIds: ['cat-1'],
            ),
          )).called(1);
    });

    testWidgets('should display multiple selected categories correctly',
        (tester) async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(testCategories));

      await tester.pumpWidget(createTestWidget(
        initialSelectedIds: {'cat-1', 'cat-2', 'cat-3'},
      ));
      await tester.pumpAndSettle();

      expect(find.text('3개 선택됨'), findsOneWidget);
    });

    testWidgets('should toggle multiple categories independently',
        (tester) async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(testCategories));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('네일'));
      await tester.pumpAndSettle();
      expect(find.text('1개 선택됨'), findsOneWidget);

      await tester.tap(find.text('헤어'));
      await tester.pumpAndSettle();
      expect(find.text('2개 선택됨'), findsOneWidget);

      await tester.tap(find.text('네일'));
      await tester.pumpAndSettle();
      expect(find.text('1개 선택됨'), findsOneWidget);
    });

    testWidgets('should pop with true result when save is successful',
        (tester) async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(testCategories));
      when(() => mockSetShopCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(testCategories));

      bool? popResult;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoryStateProvider.overrideWith((ref) {
              return CategoryStateNotifier(
                getCategoriesUseCase: mockGetCategoriesUseCase,
                setShopCategoriesUseCase: mockSetShopCategoriesUseCase,
              );
            }),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  popResult = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => const CategorySelectPage(
                        shopId: 'test-shop-id',
                        initialSelectedIds: {'cat-1'},
                      ),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('저장'));
      await tester.pumpAndSettle();

      expect(popResult, isTrue);
    });
  });
}

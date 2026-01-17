import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/create_treatment_usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/delete_treatment_usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/get_shop_treatments_usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/update_treatment_usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/pages/treatment_list_page.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/providers/treatment_providers.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/providers/treatment_state.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/widgets/treatment_card.dart';

class FakeTreatmentStateNotifier extends TreatmentStateNotifier {
  final TreatmentState initialState;

  FakeTreatmentStateNotifier(this.initialState)
      : super(
          getShopTreatmentsUseCase: _FakeGetShopTreatmentsUseCase(),
          createTreatmentUseCase: _FakeCreateTreatmentUseCase(),
          updateTreatmentUseCase: _FakeUpdateTreatmentUseCase(),
          deleteTreatmentUseCase: _FakeDeleteTreatmentUseCase(),
        );

  @override
  TreatmentState get state => initialState;

  @override
  Future<void> loadTreatments(String shopId) async {}
}

class _FakeGetShopTreatmentsUseCase
    implements
        GetShopTreatmentsUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeCreateTreatmentUseCase
    implements
        CreateTreatmentUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeUpdateTreatmentUseCase
    implements
        UpdateTreatmentUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeDeleteTreatmentUseCase
    implements
        DeleteTreatmentUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final tTreatmentList = [
    Treatment(
      id: 'treatment-uuid-1',
      name: 'Treatment 1',
      description: 'Description 1',
      price: 50000,
      duration: 60,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    Treatment(
      id: 'treatment-uuid-2',
      name: 'Treatment 2',
      price: 30000,
      duration: 30,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
  ];

  Widget createTestWidget({
    required TreatmentState state,
    VoidCallback? onAddPressed,
    void Function(Treatment)? onTreatmentTap,
    void Function(Treatment)? onTreatmentEdit,
    void Function(Treatment)? onTreatmentDelete,
    Future<void> Function()? onRefresh,
  }) {
    return ProviderScope(
      overrides: [
        treatmentStateProvider.overrideWith(
          (ref) => FakeTreatmentStateNotifier(state),
        ),
      ],
      child: MaterialApp(
        home: TreatmentListPage(
          shopId: 'shop-uuid',
          onAddPressed: onAddPressed ?? () {},
          onTreatmentTap: onTreatmentTap ?? (_) {},
          onTreatmentEdit: onTreatmentEdit,
          onTreatmentDelete: onTreatmentDelete,
          onRefresh: onRefresh ?? () async {},
        ),
      ),
    );
  }

  group('TreatmentListPage', () {
    testWidgets('should display AppBar with title', (tester) async {
      await tester.pumpWidget(createTestWidget(
        state: const TreatmentEmpty(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('시술 관리'), findsOneWidget);
    });

    testWidgets('should display loading indicator when TreatmentLoading',
        (tester) async {
      await tester.pumpWidget(createTestWidget(
        state: const TreatmentLoading(),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display treatment cards when TreatmentListLoaded',
        (tester) async {
      await tester.pumpWidget(createTestWidget(
        state: TreatmentListLoaded(treatments: tTreatmentList),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(TreatmentCard), findsNWidgets(2));
      expect(find.text('Treatment 1'), findsOneWidget);
      expect(find.text('Treatment 2'), findsOneWidget);
    });

    testWidgets('should display empty state when TreatmentEmpty',
        (tester) async {
      await tester.pumpWidget(createTestWidget(
        state: const TreatmentEmpty(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('등록된 시술이 없습니다'), findsOneWidget);
    });

    testWidgets('should display error message when TreatmentError',
        (tester) async {
      await tester.pumpWidget(createTestWidget(
        state: const TreatmentError('Failed to load'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Failed to load'), findsOneWidget);
    });

    testWidgets('should display FAB for adding treatment', (tester) async {
      await tester.pumpWidget(createTestWidget(
        state: const TreatmentEmpty(),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should call onAddPressed when FAB is tapped', (tester) async {
      var addPressed = false;

      await tester.pumpWidget(createTestWidget(
        state: const TreatmentEmpty(),
        onAddPressed: () => addPressed = true,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(addPressed, isTrue);
    });

    testWidgets('should call onTreatmentTap when card is tapped',
        (tester) async {
      Treatment? tappedTreatment;

      await tester.pumpWidget(createTestWidget(
        state: TreatmentListLoaded(treatments: tTreatmentList),
        onTreatmentTap: (treatment) => tappedTreatment = treatment,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Treatment 1'));
      await tester.pumpAndSettle();

      expect(tappedTreatment?.id, 'treatment-uuid-1');
    });

    testWidgets('should support pull to refresh', (tester) async {
      var refreshCalled = false;

      await tester.pumpWidget(createTestWidget(
        state: TreatmentListLoaded(treatments: tTreatmentList),
        onRefresh: () async {
          refreshCalled = true;
        },
      ));
      await tester.pumpAndSettle();

      await tester.fling(
        find.byType(RefreshIndicator),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      expect(refreshCalled, isTrue);
    });

    testWidgets('should display add icon on FAB', (tester) async {
      await tester.pumpWidget(createTestWidget(
        state: const TreatmentEmpty(),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}

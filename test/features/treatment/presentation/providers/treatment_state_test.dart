import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/providers/treatment_state.dart';

void main() {
  final tTreatment = Treatment(
    id: 'treatment-uuid',
    name: 'Test Treatment',
    description: 'A test treatment',
    price: 50000,
    duration: 60,
    imageUrl: 'https://example.com/image.jpg',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final tTreatmentList = [
    tTreatment,
    Treatment(
      id: 'treatment-uuid-2',
      name: 'Another Treatment',
      description: 'Another test treatment',
      price: 30000,
      duration: 30,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
  ];

  group('TreatmentInitial', () {
    test('should have empty props', () {
      const state = TreatmentInitial();
      expect(state.props, isEmpty);
    });

    test('should be equal to another TreatmentInitial', () {
      const state1 = TreatmentInitial();
      const state2 = TreatmentInitial();
      expect(state1, equals(state2));
    });
  });

  group('TreatmentLoading', () {
    test('should have empty props', () {
      const state = TreatmentLoading();
      expect(state.props, isEmpty);
    });

    test('should be equal to another TreatmentLoading', () {
      const state1 = TreatmentLoading();
      const state2 = TreatmentLoading();
      expect(state1, equals(state2));
    });
  });

  group('TreatmentListLoaded', () {
    test('should have treatments in props', () {
      final state = TreatmentListLoaded(treatments: tTreatmentList);
      expect(state.props, [tTreatmentList]);
    });

    test('should be equal when treatments are the same', () {
      final state1 = TreatmentListLoaded(treatments: tTreatmentList);
      final state2 = TreatmentListLoaded(treatments: tTreatmentList);
      expect(state1, equals(state2));
    });

    test('should not be equal when treatments are different', () {
      final state1 = TreatmentListLoaded(treatments: tTreatmentList);
      final state2 = TreatmentListLoaded(treatments: [tTreatment]);
      expect(state1, isNot(equals(state2)));
    });
  });

  group('TreatmentEmpty', () {
    test('should have empty props', () {
      const state = TreatmentEmpty();
      expect(state.props, isEmpty);
    });

    test('should be equal to another TreatmentEmpty', () {
      const state1 = TreatmentEmpty();
      const state2 = TreatmentEmpty();
      expect(state1, equals(state2));
    });
  });

  group('TreatmentError', () {
    test('should have message in props', () {
      const state = TreatmentError('Error message');
      expect(state.props, ['Error message']);
    });

    test('should be equal when message is the same', () {
      const state1 = TreatmentError('Same error');
      const state2 = TreatmentError('Same error');
      expect(state1, equals(state2));
    });

    test('should not be equal when message is different', () {
      const state1 = TreatmentError('Error 1');
      const state2 = TreatmentError('Error 2');
      expect(state1, isNot(equals(state2)));
    });
  });

  group('TreatmentCreating', () {
    test('should have empty props', () {
      const state = TreatmentCreating();
      expect(state.props, isEmpty);
    });

    test('should be equal to another TreatmentCreating', () {
      const state1 = TreatmentCreating();
      const state2 = TreatmentCreating();
      expect(state1, equals(state2));
    });
  });

  group('TreatmentCreated', () {
    test('should have treatment in props', () {
      final state = TreatmentCreated(treatment: tTreatment);
      expect(state.props, [tTreatment]);
    });

    test('should be equal when treatment is the same', () {
      final state1 = TreatmentCreated(treatment: tTreatment);
      final state2 = TreatmentCreated(treatment: tTreatment);
      expect(state1, equals(state2));
    });

    test('should not be equal when treatment is different', () {
      final state1 = TreatmentCreated(treatment: tTreatment);
      final state2 = TreatmentCreated(
        treatment: Treatment(
          id: 'different-uuid',
          name: 'Different',
          price: 10000,
          duration: 15,
          createdAt: DateTime(2024, 2, 2),
          updatedAt: DateTime(2024, 2, 2),
        ),
      );
      expect(state1, isNot(equals(state2)));
    });
  });

  group('TreatmentUpdating', () {
    test('should have empty props', () {
      const state = TreatmentUpdating();
      expect(state.props, isEmpty);
    });

    test('should be equal to another TreatmentUpdating', () {
      const state1 = TreatmentUpdating();
      const state2 = TreatmentUpdating();
      expect(state1, equals(state2));
    });
  });

  group('TreatmentUpdated', () {
    test('should have treatment in props', () {
      final state = TreatmentUpdated(treatment: tTreatment);
      expect(state.props, [tTreatment]);
    });

    test('should be equal when treatment is the same', () {
      final state1 = TreatmentUpdated(treatment: tTreatment);
      final state2 = TreatmentUpdated(treatment: tTreatment);
      expect(state1, equals(state2));
    });
  });

  group('TreatmentDeleting', () {
    test('should have empty props', () {
      const state = TreatmentDeleting();
      expect(state.props, isEmpty);
    });

    test('should be equal to another TreatmentDeleting', () {
      const state1 = TreatmentDeleting();
      const state2 = TreatmentDeleting();
      expect(state1, equals(state2));
    });
  });

  group('TreatmentDeleted', () {
    test('should have empty props', () {
      const state = TreatmentDeleted();
      expect(state.props, isEmpty);
    });

    test('should be equal to another TreatmentDeleted', () {
      const state1 = TreatmentDeleted();
      const state2 = TreatmentDeleted();
      expect(state1, equals(state2));
    });
  });

  group('TreatmentState sealed class', () {
    test('TreatmentInitial should be a subtype of TreatmentState', () {
      const state = TreatmentInitial();
      expect(state, isA<TreatmentState>());
    });

    test('TreatmentLoading should be a subtype of TreatmentState', () {
      const state = TreatmentLoading();
      expect(state, isA<TreatmentState>());
    });

    test('TreatmentListLoaded should be a subtype of TreatmentState', () {
      final state = TreatmentListLoaded(treatments: tTreatmentList);
      expect(state, isA<TreatmentState>());
    });

    test('TreatmentEmpty should be a subtype of TreatmentState', () {
      const state = TreatmentEmpty();
      expect(state, isA<TreatmentState>());
    });

    test('TreatmentError should be a subtype of TreatmentState', () {
      const state = TreatmentError('error');
      expect(state, isA<TreatmentState>());
    });

    test('TreatmentCreating should be a subtype of TreatmentState', () {
      const state = TreatmentCreating();
      expect(state, isA<TreatmentState>());
    });

    test('TreatmentCreated should be a subtype of TreatmentState', () {
      final state = TreatmentCreated(treatment: tTreatment);
      expect(state, isA<TreatmentState>());
    });

    test('TreatmentUpdating should be a subtype of TreatmentState', () {
      const state = TreatmentUpdating();
      expect(state, isA<TreatmentState>());
    });

    test('TreatmentUpdated should be a subtype of TreatmentState', () {
      final state = TreatmentUpdated(treatment: tTreatment);
      expect(state, isA<TreatmentState>());
    });

    test('TreatmentDeleting should be a subtype of TreatmentState', () {
      const state = TreatmentDeleting();
      expect(state, isA<TreatmentState>());
    });

    test('TreatmentDeleted should be a subtype of TreatmentState', () {
      const state = TreatmentDeleted();
      expect(state, isA<TreatmentState>());
    });
  });
}

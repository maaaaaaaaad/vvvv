import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/features/owner/presentation/providers/owner_state.dart';

void main() {
  final tOwner = Owner(
    id: 'test-uuid',
    nickname: 'testshop',
    email: 'owner@example.com',
    businessNumber: '1234567890',
    phoneNumber: '010-1234-5678',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  group('OwnerInitial', () {
    test('should have empty props', () {
      const state = OwnerInitial();
      expect(state.props, isEmpty);
    });

    test('should be equal to another OwnerInitial', () {
      const state1 = OwnerInitial();
      const state2 = OwnerInitial();
      expect(state1, equals(state2));
    });
  });

  group('OwnerLoading', () {
    test('should have empty props', () {
      const state = OwnerLoading();
      expect(state.props, isEmpty);
    });

    test('should be equal to another OwnerLoading', () {
      const state1 = OwnerLoading();
      const state2 = OwnerLoading();
      expect(state1, equals(state2));
    });
  });

  group('OwnerLoaded', () {
    test('should have owner in props', () {
      final state = OwnerLoaded(owner: tOwner);
      expect(state.props, [tOwner]);
    });

    test('should be equal when owner is the same', () {
      final state1 = OwnerLoaded(owner: tOwner);
      final state2 = OwnerLoaded(owner: tOwner);
      expect(state1, equals(state2));
    });

    test('should not be equal when owner is different', () {
      final state1 = OwnerLoaded(owner: tOwner);
      final state2 = OwnerLoaded(
        owner: Owner(
          id: 'different-uuid',
          nickname: 'different',
          email: 'different@example.com',
          businessNumber: '9999999999',
          phoneNumber: '010-9999-9999',
          createdAt: DateTime(2024, 2, 2),
          updatedAt: DateTime(2024, 2, 2),
        ),
      );
      expect(state1, isNot(equals(state2)));
    });
  });

  group('OwnerError', () {
    test('should have message in props', () {
      const state = OwnerError('Error message');
      expect(state.props, ['Error message']);
    });

    test('should be equal when message is the same', () {
      const state1 = OwnerError('Same error');
      const state2 = OwnerError('Same error');
      expect(state1, equals(state2));
    });

    test('should not be equal when message is different', () {
      const state1 = OwnerError('Error 1');
      const state2 = OwnerError('Error 2');
      expect(state1, isNot(equals(state2)));
    });
  });

  group('OwnerState sealed class', () {
    test('OwnerInitial should be a subtype of OwnerState', () {
      const state = OwnerInitial();
      expect(state, isA<OwnerState>());
    });

    test('OwnerLoading should be a subtype of OwnerState', () {
      const state = OwnerLoading();
      expect(state, isA<OwnerState>());
    });

    test('OwnerLoaded should be a subtype of OwnerState', () {
      final state = OwnerLoaded(owner: tOwner);
      expect(state, isA<OwnerState>());
    });

    test('OwnerError should be a subtype of OwnerState', () {
      const state = OwnerError('error');
      expect(state, isA<OwnerState>());
    });
  });
}

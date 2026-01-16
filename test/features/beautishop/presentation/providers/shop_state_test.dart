import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/category_summary.dart';
import 'package:jellomark_mobile_owner/features/beautishop/presentation/providers/shop_state.dart';

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
    categories: const [CategorySummary(id: 'cat-1', name: 'Hair')],
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  group('ShopInitial', () {
    test('should have empty props', () {
      const state = ShopInitial();
      expect(state.props, isEmpty);
    });

    test('should be equal to another ShopInitial', () {
      const state1 = ShopInitial();
      const state2 = ShopInitial();
      expect(state1, equals(state2));
    });
  });

  group('ShopLoading', () {
    test('should have empty props', () {
      const state = ShopLoading();
      expect(state.props, isEmpty);
    });

    test('should be equal to another ShopLoading', () {
      const state1 = ShopLoading();
      const state2 = ShopLoading();
      expect(state1, equals(state2));
    });
  });

  group('ShopLoaded', () {
    test('should have shop in props', () {
      final state = ShopLoaded(shop: tBeautishop);
      expect(state.props, [tBeautishop]);
    });

    test('should be equal when shop is the same', () {
      final state1 = ShopLoaded(shop: tBeautishop);
      final state2 = ShopLoaded(shop: tBeautishop);
      expect(state1, equals(state2));
    });

    test('should not be equal when shop is different', () {
      final state1 = ShopLoaded(shop: tBeautishop);
      final state2 = ShopLoaded(
        shop: Beautishop(
          id: 'different-uuid',
          name: 'Different Shop',
          regNum: '9999999999',
          phoneNumber: '02-9999-9999',
          address: 'Different Address',
          latitude: 37.0,
          longitude: 127.0,
          operatingTime: const {'MON': '10:00-19:00'},
          averageRating: 3.0,
          reviewCount: 50,
          categories: const [],
          createdAt: DateTime(2024, 2, 2),
          updatedAt: DateTime(2024, 2, 2),
        ),
      );
      expect(state1, isNot(equals(state2)));
    });
  });

  group('ShopEmpty', () {
    test('should have empty props', () {
      const state = ShopEmpty();
      expect(state.props, isEmpty);
    });

    test('should be equal to another ShopEmpty', () {
      const state1 = ShopEmpty();
      const state2 = ShopEmpty();
      expect(state1, equals(state2));
    });
  });

  group('ShopError', () {
    test('should have message in props', () {
      const state = ShopError('Error message');
      expect(state.props, ['Error message']);
    });

    test('should be equal when message is the same', () {
      const state1 = ShopError('Same error');
      const state2 = ShopError('Same error');
      expect(state1, equals(state2));
    });

    test('should not be equal when message is different', () {
      const state1 = ShopError('Error 1');
      const state2 = ShopError('Error 2');
      expect(state1, isNot(equals(state2)));
    });
  });

  group('ShopCreating', () {
    test('should have empty props', () {
      const state = ShopCreating();
      expect(state.props, isEmpty);
    });

    test('should be equal to another ShopCreating', () {
      const state1 = ShopCreating();
      const state2 = ShopCreating();
      expect(state1, equals(state2));
    });
  });

  group('ShopUpdating', () {
    test('should have empty props', () {
      const state = ShopUpdating();
      expect(state.props, isEmpty);
    });

    test('should be equal to another ShopUpdating', () {
      const state1 = ShopUpdating();
      const state2 = ShopUpdating();
      expect(state1, equals(state2));
    });
  });

  group('ShopDeleting', () {
    test('should have empty props', () {
      const state = ShopDeleting();
      expect(state.props, isEmpty);
    });

    test('should be equal to another ShopDeleting', () {
      const state1 = ShopDeleting();
      const state2 = ShopDeleting();
      expect(state1, equals(state2));
    });
  });

  group('ShopState sealed class', () {
    test('ShopInitial should be a subtype of ShopState', () {
      const state = ShopInitial();
      expect(state, isA<ShopState>());
    });

    test('ShopLoading should be a subtype of ShopState', () {
      const state = ShopLoading();
      expect(state, isA<ShopState>());
    });

    test('ShopLoaded should be a subtype of ShopState', () {
      final state = ShopLoaded(shop: tBeautishop);
      expect(state, isA<ShopState>());
    });

    test('ShopEmpty should be a subtype of ShopState', () {
      const state = ShopEmpty();
      expect(state, isA<ShopState>());
    });

    test('ShopError should be a subtype of ShopState', () {
      const state = ShopError('error');
      expect(state, isA<ShopState>());
    });

    test('ShopCreating should be a subtype of ShopState', () {
      const state = ShopCreating();
      expect(state, isA<ShopState>());
    });

    test('ShopUpdating should be a subtype of ShopState', () {
      const state = ShopUpdating();
      expect(state, isA<ShopState>());
    });

    test('ShopDeleting should be a subtype of ShopState', () {
      const state = ShopDeleting();
      expect(state, isA<ShopState>());
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/token_pair.dart';

void main() {
  group('TokenPair', () {
    test('should create TokenPair with accessToken and refreshToken', () {
      const tokenPair = TokenPair(
        accessToken: 'access-token-123',
        refreshToken: 'refresh-token-456',
      );

      expect(tokenPair.accessToken, 'access-token-123');
      expect(tokenPair.refreshToken, 'refresh-token-456');
    });

    test('should be equal when properties are the same', () {
      const tokenPair1 = TokenPair(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
      );
      const tokenPair2 = TokenPair(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
      );

      expect(tokenPair1, equals(tokenPair2));
    });

    test('should not be equal when properties are different', () {
      const tokenPair1 = TokenPair(
        accessToken: 'access-token-1',
        refreshToken: 'refresh-token-1',
      );
      const tokenPair2 = TokenPair(
        accessToken: 'access-token-2',
        refreshToken: 'refresh-token-2',
      );

      expect(tokenPair1, isNot(equals(tokenPair2)));
    });

    test('props should contain accessToken and refreshToken', () {
      const tokenPair = TokenPair(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
      );

      expect(tokenPair.props, ['access-token', 'refresh-token']);
    });
  });
}

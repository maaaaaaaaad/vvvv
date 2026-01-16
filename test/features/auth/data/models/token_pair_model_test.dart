import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/token_pair_model.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/token_pair.dart';

void main() {
  group('TokenPairModel', () {
    const tAccessToken = 'access-token-123';
    const tRefreshToken = 'refresh-token-456';

    final tJson = {
      'accessToken': tAccessToken,
      'refreshToken': tRefreshToken,
    };

    test('should create TokenPairModel with accessToken and refreshToken', () {
      const model = TokenPairModel(
        accessToken: tAccessToken,
        refreshToken: tRefreshToken,
      );

      expect(model.accessToken, tAccessToken);
      expect(model.refreshToken, tRefreshToken);
    });

    test('should create TokenPairModel from JSON', () {
      final model = TokenPairModel.fromJson(tJson);

      expect(model.accessToken, tAccessToken);
      expect(model.refreshToken, tRefreshToken);
    });

    test('should convert to TokenPair entity', () {
      const model = TokenPairModel(
        accessToken: tAccessToken,
        refreshToken: tRefreshToken,
      );

      final entity = model.toEntity();

      expect(entity, isA<TokenPair>());
      expect(entity.accessToken, tAccessToken);
      expect(entity.refreshToken, tRefreshToken);
    });
  });
}

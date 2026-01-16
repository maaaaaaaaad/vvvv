import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/login_response.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/owner_model.dart';

void main() {
  group('LoginResponse', () {
    final tOwnerJson = {
      'id': 'owner-uuid',
      'nickname': 'testshop',
      'email': 'owner@example.com',
      'businessNumber': '123456789',
      'phoneNumber': '010-1234-5678',
      'createdAt': '2024-01-01T00:00:00Z',
      'updatedAt': '2024-01-01T00:00:00Z',
    };

    final tResponseJson = {
      'accessToken': 'access-token-123',
      'refreshToken': 'refresh-token-456',
      'owner': tOwnerJson,
    };

    final tOwnerModel = OwnerModel(
      id: 'owner-uuid',
      nickname: 'testshop',
      email: 'owner@example.com',
      businessNumber: '123456789',
      phoneNumber: '010-1234-5678',
      createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
      updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
    );

    test('should create LoginResponse from JSON', () {
      final response = LoginResponse.fromJson(tResponseJson);

      expect(response.accessToken, 'access-token-123');
      expect(response.refreshToken, 'refresh-token-456');
      expect(response.owner.id, tOwnerModel.id);
      expect(response.owner.nickname, tOwnerModel.nickname);
      expect(response.owner.email, tOwnerModel.email);
    });

    test('should convert to AuthResult correctly', () {
      final response = LoginResponse.fromJson(tResponseJson);

      final authResult = response.toAuthResult();

      expect(authResult.accessToken, 'access-token-123');
      expect(authResult.refreshToken, 'refresh-token-456');
      expect(authResult.owner.id, tOwnerModel.id);
      expect(authResult.owner.nickname, tOwnerModel.nickname);
    });
  });
}

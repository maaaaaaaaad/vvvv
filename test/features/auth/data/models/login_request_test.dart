import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/login_request.dart';

void main() {
  group('LoginRequest', () {
    const tEmail = 'owner@example.com';
    const tPassword = 'Password123!';

    test('should create LoginRequest with email and password', () {
      const request = LoginRequest(
        email: tEmail,
        password: tPassword,
      );

      expect(request.email, tEmail);
      expect(request.password, tPassword);
    });

    test('should convert to JSON correctly', () {
      const request = LoginRequest(
        email: tEmail,
        password: tPassword,
      );

      final json = request.toJson();

      expect(json['email'], tEmail);
      expect(json['password'], tPassword);
      expect(json.length, 2);
    });
  });
}

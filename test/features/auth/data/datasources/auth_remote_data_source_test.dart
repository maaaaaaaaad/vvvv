import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/login_request.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/sign_up_request.dart';

void main() {
  late AuthRemoteDataSource dataSource;
  late ApiClient apiClient;
  late DioAdapter dioAdapter;

  setUp(() {
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
    dioAdapter = DioAdapter(dio: dio);
    apiClient = ApiClient(baseUrl: 'http://localhost:8080');
    apiClient.dio.httpClientAdapter = dioAdapter;
    dataSource = AuthRemoteDataSourceImpl(apiClient: apiClient);
  });

  group('signUp', () {
    const tRequest = SignUpRequest(
      businessNumber: '123456789',
      phoneNumber: '010-1234-5678',
      nickname: 'testshop',
      email: 'owner@example.com',
      password: 'Password123!',
    );

    final tResponseJson = {
      'id': 'test-uuid',
      'userType': 'OWNER',
      'nickname': 'testshop',
      'email': 'owner@example.com',
      'businessNumber': '123456789',
      'phoneNumber': '010-1234-5678',
      'createdAt': '2024-01-01T00:00:00Z',
      'updatedAt': '2024-01-01T00:00:00Z',
      'accessToken': 'access-token',
      'refreshToken': 'refresh-token',
    };

    test('should return SignUpResponse when the call is successful', () async {
      dioAdapter.onPost(
        '/api/sign-up/owner',
        (server) => server.reply(201, tResponseJson),
        data: tRequest.toJson(),
      );

      final result = await dataSource.signUp(tRequest);

      expect(result.id, 'test-uuid');
      expect(result.nickname, 'testshop');
      expect(result.accessToken, 'access-token');
    });

    test('should throw exception when the call fails', () async {
      dioAdapter.onPost(
        '/api/sign-up/owner',
        (server) => server.reply(400, {'message': 'Bad request'}),
        data: tRequest.toJson(),
      );

      expect(
        () => dataSource.signUp(tRequest),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('login', () {
    const tRequest = LoginRequest(
      email: 'owner@example.com',
      password: 'Password123!',
    );

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

    test('should return LoginResponse when the call is successful', () async {
      dioAdapter.onPost(
        '/api/auth/authenticate',
        (server) => server.reply(200, tResponseJson),
        data: tRequest.toJson(),
      );

      final result = await dataSource.login(tRequest);

      expect(result.accessToken, 'access-token-123');
      expect(result.refreshToken, 'refresh-token-456');
      expect(result.owner.id, 'owner-uuid');
      expect(result.owner.nickname, 'testshop');
    });

    test('should throw DioException when credentials are invalid', () async {
      dioAdapter.onPost(
        '/api/auth/authenticate',
        (server) => server.reply(401, {'message': 'Invalid credentials'}),
        data: tRequest.toJson(),
      );

      expect(
        () => dataSource.login(tRequest),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('logout', () {
    const tAccessToken = 'access-token-123';

    test('should complete successfully when logout is successful', () async {
      dioAdapter.onPost(
        '/api/auth/logout',
        (server) => server.reply(200, null),
        headers: {'Authorization': 'Bearer $tAccessToken'},
      );

      await expectLater(
        dataSource.logout(tAccessToken),
        completes,
      );
    });

    test('should throw DioException when logout fails', () async {
      dioAdapter.onPost(
        '/api/auth/logout',
        (server) => server.reply(401, {'message': 'Invalid token'}),
        headers: {'Authorization': 'Bearer $tAccessToken'},
      );

      expect(
        () => dataSource.logout(tAccessToken),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('refreshToken', () {
    const tRefreshToken = 'refresh-token-456';

    final tResponseJson = {
      'accessToken': 'new-access-token',
      'refreshToken': 'new-refresh-token',
    };

    test('should return TokenPairModel when refresh is successful', () async {
      dioAdapter.onPost(
        '/api/auth/refresh',
        (server) => server.reply(200, tResponseJson),
        data: {'refreshToken': tRefreshToken},
      );

      final result = await dataSource.refreshToken(tRefreshToken);

      expect(result.accessToken, 'new-access-token');
      expect(result.refreshToken, 'new-refresh-token');
    });

    test('should throw DioException when refresh token is invalid', () async {
      dioAdapter.onPost(
        '/api/auth/refresh',
        (server) => server.reply(401, {'message': 'Invalid refresh token'}),
        data: {'refreshToken': tRefreshToken},
      );

      expect(
        () => dataSource.refreshToken(tRefreshToken),
        throwsA(isA<DioException>()),
      );
    });
  });
}

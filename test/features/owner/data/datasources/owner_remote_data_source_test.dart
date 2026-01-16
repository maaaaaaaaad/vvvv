import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/owner/data/datasources/owner_remote_data_source.dart';

void main() {
  late OwnerRemoteDataSource dataSource;
  late ApiClient apiClient;
  late DioAdapter dioAdapter;

  setUp(() {
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
    dioAdapter = DioAdapter(dio: dio);
    apiClient = ApiClient(baseUrl: 'http://localhost:8080');
    apiClient.dio.httpClientAdapter = dioAdapter;
    dataSource = OwnerRemoteDataSourceImpl(apiClient: apiClient);
  });

  group('getCurrentOwner', () {
    final tOwnerJson = {
      'id': 'owner-uuid-123',
      'nickname': 'testshop',
      'email': 'owner@example.com',
      'businessNumber': '123456789',
      'phoneNumber': '010-1234-5678',
      'createdAt': '2024-01-01T00:00:00Z',
      'updatedAt': '2024-01-01T00:00:00Z',
    };

    test('should return OwnerModel when the call is successful', () async {
      dioAdapter.onGet(
        '/api/owners/me',
        (server) => server.reply(200, tOwnerJson),
      );

      final result = await dataSource.getCurrentOwner();

      expect(result.id, 'owner-uuid-123');
      expect(result.nickname, 'testshop');
      expect(result.email, 'owner@example.com');
      expect(result.businessNumber, '123456789');
      expect(result.phoneNumber, '010-1234-5678');
    });

    test('should throw DioException when the call fails with 401', () async {
      dioAdapter.onGet(
        '/api/owners/me',
        (server) => server.reply(401, {'message': 'Unauthorized'}),
      );

      expect(
        () => dataSource.getCurrentOwner(),
        throwsA(isA<DioException>()),
      );
    });

    test('should throw DioException when the call fails with 500', () async {
      dioAdapter.onGet(
        '/api/owners/me',
        (server) => server.reply(500, {'message': 'Internal server error'}),
      );

      expect(
        () => dataSource.getCurrentOwner(),
        throwsA(isA<DioException>()),
      );
    });
  });
}

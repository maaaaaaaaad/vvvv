import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jellomark_mobile_owner/core/error/failure.dart';
import 'package:jellomark_mobile_owner/features/auth/data/models/owner_model.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/features/owner/data/datasources/owner_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/owner/data/repositories/owner_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockOwnerRemoteDataSource extends Mock implements OwnerRemoteDataSource {}

void main() {
  late OwnerRepositoryImpl repository;
  late MockOwnerRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockOwnerRemoteDataSource();
    repository = OwnerRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('getCurrentOwner', () {
    final tOwnerModel = OwnerModel(
      id: 'owner-uuid-123',
      nickname: 'testshop',
      email: 'owner@example.com',
      businessNumber: '123456789',
      phoneNumber: '010-1234-5678',
      createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
      updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
    );

    test('should return Owner when the call to remote data source is successful',
        () async {
      when(() => mockDataSource.getCurrentOwner())
          .thenAnswer((_) async => tOwnerModel);

      final result = await repository.getCurrentOwner();

      expect(result, isA<Right<Failure, Owner>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (owner) {
          expect(owner.id, 'owner-uuid-123');
          expect(owner.nickname, 'testshop');
          expect(owner.email, 'owner@example.com');
          expect(owner.businessNumber, '123456789');
          expect(owner.phoneNumber, '010-1234-5678');
        },
      );
      verify(() => mockDataSource.getCurrentOwner()).called(1);
    });

    test('should return AuthFailure when DioException with 401 occurs',
        () async {
      when(() => mockDataSource.getCurrentOwner()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/owners/me'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/owners/me'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      final result = await repository.getCurrentOwner();

      expect(result, isA<Left<Failure, Owner>>());
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'Unauthorized');
        },
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when DioException with other status occurs',
        () async {
      when(() => mockDataSource.getCurrentOwner()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/owners/me'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/owners/me'),
            statusCode: 500,
            data: {'message': 'Internal server error'},
          ),
        ),
      );

      final result = await repository.getCurrentOwner();

      expect(result, isA<Left<Failure, Owner>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Internal server error');
        },
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure when unknown exception occurs',
        () async {
      when(() => mockDataSource.getCurrentOwner())
          .thenThrow(Exception('Unknown error'));

      final result = await repository.getCurrentOwner();

      expect(result, isA<Left<Failure, Owner>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('알 수 없는 오류'));
        },
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return ServerFailure with default message when response data is null',
        () async {
      when(() => mockDataSource.getCurrentOwner()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/owners/me'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/owners/me'),
            statusCode: 500,
            data: null,
          ),
        ),
      );

      final result = await repository.getCurrentOwner();

      expect(result, isA<Left<Failure, Owner>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, '서버 오류가 발생했습니다');
        },
        (_) => fail('Expected Left but got Right'),
      );
    });
  });
}

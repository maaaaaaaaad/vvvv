import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/create_treatment_request.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/treatment_model.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/models/update_treatment_request.dart';

abstract class TreatmentRemoteDataSource {
  Future<List<TreatmentModel>> getShopTreatments(String shopId);

  Future<TreatmentModel> getTreatmentById(String treatmentId);

  Future<TreatmentModel> createTreatment(
    String shopId,
    CreateTreatmentRequest request,
  );

  Future<TreatmentModel> updateTreatment(
    String treatmentId,
    UpdateTreatmentRequest request,
  );

  Future<void> deleteTreatment(String treatmentId);
}

class TreatmentRemoteDataSourceImpl implements TreatmentRemoteDataSource {
  final ApiClient apiClient;

  TreatmentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TreatmentModel>> getShopTreatments(String shopId) async {
    final response = await apiClient.dio.get('/api/beautishops/$shopId/treatments');
    final treatmentsJson = response.data as List<dynamic>;
    return treatmentsJson
        .map((json) => TreatmentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TreatmentModel> getTreatmentById(String treatmentId) async {
    final response = await apiClient.dio.get('/api/treatments/$treatmentId');
    return TreatmentModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TreatmentModel> createTreatment(
    String shopId,
    CreateTreatmentRequest request,
  ) async {
    final response = await apiClient.dio.post(
      '/api/beautishops/$shopId/treatments',
      data: request.toJson(),
    );
    return TreatmentModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TreatmentModel> updateTreatment(
    String treatmentId,
    UpdateTreatmentRequest request,
  ) async {
    final response = await apiClient.dio.put(
      '/api/treatments/$treatmentId',
      data: request.toJson(),
    );
    return TreatmentModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteTreatment(String treatmentId) async {
    await apiClient.dio.delete('/api/treatments/$treatmentId');
  }
}

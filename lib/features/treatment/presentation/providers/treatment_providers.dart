import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/core/di/injection_container.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/datasources/treatment_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/repositories/treatment_repository_impl.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/repositories/treatment_repository.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/create_treatment_usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/delete_treatment_usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/get_shop_treatments_usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/update_treatment_usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/providers/treatment_state.dart';

final treatmentRemoteDataSourceProvider =
    Provider<TreatmentRemoteDataSource>((ref) {
  return TreatmentRemoteDataSourceImpl(apiClient: sl<ApiClient>());
});

final treatmentRepositoryProvider = Provider<TreatmentRepository>((ref) {
  return TreatmentRepositoryImpl(
    remoteDataSource: ref.watch(treatmentRemoteDataSourceProvider),
  );
});

final getShopTreatmentsUseCaseProvider =
    Provider<GetShopTreatmentsUseCase>((ref) {
  return GetShopTreatmentsUseCase(
    repository: ref.watch(treatmentRepositoryProvider),
  );
});

final createTreatmentUseCaseProvider = Provider<CreateTreatmentUseCase>((ref) {
  return CreateTreatmentUseCase(
    repository: ref.watch(treatmentRepositoryProvider),
  );
});

final updateTreatmentUseCaseProvider = Provider<UpdateTreatmentUseCase>((ref) {
  return UpdateTreatmentUseCase(
    repository: ref.watch(treatmentRepositoryProvider),
  );
});

final deleteTreatmentUseCaseProvider = Provider<DeleteTreatmentUseCase>((ref) {
  return DeleteTreatmentUseCase(
    repository: ref.watch(treatmentRepositoryProvider),
  );
});

final treatmentStateProvider =
    StateNotifierProvider<TreatmentStateNotifier, TreatmentState>((ref) {
  return TreatmentStateNotifier(
    getShopTreatmentsUseCase: ref.watch(getShopTreatmentsUseCaseProvider),
    createTreatmentUseCase: ref.watch(createTreatmentUseCaseProvider),
    updateTreatmentUseCase: ref.watch(updateTreatmentUseCaseProvider),
    deleteTreatmentUseCase: ref.watch(deleteTreatmentUseCaseProvider),
  );
});

class TreatmentStateNotifier extends StateNotifier<TreatmentState> {
  final GetShopTreatmentsUseCase getShopTreatmentsUseCase;
  final CreateTreatmentUseCase createTreatmentUseCase;
  final UpdateTreatmentUseCase updateTreatmentUseCase;
  final DeleteTreatmentUseCase deleteTreatmentUseCase;

  TreatmentStateNotifier({
    required this.getShopTreatmentsUseCase,
    required this.createTreatmentUseCase,
    required this.updateTreatmentUseCase,
    required this.deleteTreatmentUseCase,
  }) : super(const TreatmentInitial());

  Future<void> loadTreatments(String shopId) async {
    state = const TreatmentLoading();
    final result = await getShopTreatmentsUseCase(
      GetShopTreatmentsParams(shopId: shopId),
    );
    result.fold(
      (failure) => state = TreatmentError(failure.message),
      (treatments) {
        if (treatments.isEmpty) {
          state = const TreatmentEmpty();
        } else {
          state = TreatmentListLoaded(treatments: treatments);
        }
      },
    );
  }

  Future<void> createTreatment(CreateTreatmentParams params) async {
    state = const TreatmentCreating();
    final result = await createTreatmentUseCase(params);
    result.fold(
      (failure) => state = TreatmentError(failure.message),
      (treatment) => state = TreatmentCreated(treatment: treatment),
    );
  }

  Future<void> updateTreatment(UpdateTreatmentParams params) async {
    state = const TreatmentUpdating();
    final result = await updateTreatmentUseCase(params);
    result.fold(
      (failure) => state = TreatmentError(failure.message),
      (treatment) => state = TreatmentUpdated(treatment: treatment),
    );
  }

  Future<void> deleteTreatment(String treatmentId) async {
    state = const TreatmentDeleting();
    final result = await deleteTreatmentUseCase(
      DeleteTreatmentParams(treatmentId: treatmentId),
    );
    result.fold(
      (failure) => state = TreatmentError(failure.message),
      (_) => state = const TreatmentDeleted(),
    );
  }

  void reset() {
    state = const TreatmentInitial();
  }
}

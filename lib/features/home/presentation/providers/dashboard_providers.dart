import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/core/di/injection_container.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/home/data/repositories/dashboard_repository_impl.dart';
import 'package:jellomark_mobile_owner/features/home/domain/repositories/dashboard_repository.dart';
import 'package:jellomark_mobile_owner/features/home/domain/usecases/get_dashboard_usecase.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/providers/dashboard_state.dart';
import 'package:jellomark_mobile_owner/features/review/data/datasources/review_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/treatment/data/datasources/treatment_remote_data_source.dart';

final treatmentRemoteDataSourceForDashboardProvider =
    Provider<TreatmentRemoteDataSource>((ref) {
  return TreatmentRemoteDataSourceImpl(apiClient: sl<ApiClient>());
});

final reviewRemoteDataSourceForDashboardProvider =
    Provider<ReviewRemoteDataSource>((ref) {
  return ReviewRemoteDataSourceImpl(apiClient: sl<ApiClient>());
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    treatmentRemoteDataSource:
        ref.watch(treatmentRemoteDataSourceForDashboardProvider),
    reviewRemoteDataSource:
        ref.watch(reviewRemoteDataSourceForDashboardProvider),
  );
});

final getDashboardUseCaseProvider = Provider<GetDashboardUseCase>((ref) {
  return GetDashboardUseCase(
    repository: ref.watch(dashboardRepositoryProvider),
  );
});

final dashboardStateNotifierProvider =
    StateNotifierProvider<DashboardStateNotifier, DashboardState>((ref) {
  return DashboardStateNotifier(
    getDashboardUseCase: ref.watch(getDashboardUseCaseProvider),
  );
});

class DashboardStateNotifier extends StateNotifier<DashboardState> {
  final GetDashboardUseCase getDashboardUseCase;

  DashboardStateNotifier({
    required this.getDashboardUseCase,
  }) : super(const DashboardInitial());

  Future<void> loadDashboard(String shopId) async {
    state = const DashboardLoading();

    final result = await getDashboardUseCase(
      GetDashboardParams(shopId: shopId),
    );

    result.fold(
      (failure) => state = DashboardError(failure.message),
      (stats) => state = DashboardLoaded(stats: stats),
    );
  }

  Future<void> refresh(String shopId) async {
    state = const DashboardLoading();

    final result = await getDashboardUseCase(
      GetDashboardParams(shopId: shopId),
    );

    result.fold(
      (failure) => state = DashboardError(failure.message),
      (stats) => state = DashboardLoaded(stats: stats),
    );
  }
}

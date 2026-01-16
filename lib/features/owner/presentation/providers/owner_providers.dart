import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/core/di/injection_container.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/owner/data/datasources/owner_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/owner/data/repositories/owner_repository_impl.dart';
import 'package:jellomark_mobile_owner/features/owner/domain/repositories/owner_repository.dart';
import 'package:jellomark_mobile_owner/features/owner/domain/usecases/get_current_owner_usecase.dart';
import 'package:jellomark_mobile_owner/features/owner/presentation/providers/owner_state.dart';

final ownerRemoteDataSourceProvider = Provider<OwnerRemoteDataSource>((ref) {
  return OwnerRemoteDataSourceImpl(apiClient: sl<ApiClient>());
});

final ownerRepositoryProvider = Provider<OwnerRepository>((ref) {
  return OwnerRepositoryImpl(
    remoteDataSource: ref.watch(ownerRemoteDataSourceProvider),
  );
});

final getCurrentOwnerUseCaseProvider = Provider<GetCurrentOwnerUseCase>((ref) {
  return GetCurrentOwnerUseCase(repository: ref.watch(ownerRepositoryProvider));
});

final ownerStateProvider =
    StateNotifierProvider<OwnerStateNotifier, OwnerState>((ref) {
  return OwnerStateNotifier(
    getCurrentOwnerUseCase: ref.watch(getCurrentOwnerUseCaseProvider),
  );
});

class OwnerStateNotifier extends StateNotifier<OwnerState> {
  final GetCurrentOwnerUseCase getCurrentOwnerUseCase;

  OwnerStateNotifier({required this.getCurrentOwnerUseCase})
      : super(const OwnerInitial());

  Future<void> loadCurrentOwner() async {
    state = const OwnerLoading();
    final result = await getCurrentOwnerUseCase(NoParams());
    result.fold(
      (failure) => state = OwnerError(failure.message),
      (owner) => state = OwnerLoaded(owner: owner),
    );
  }
}

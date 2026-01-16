import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/core/di/injection_container.dart';
import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/core/storage/secure_token_storage.dart';
import 'package:jellomark_mobile_owner/core/usecase/usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/datasources/shop_remote_data_source.dart';
import 'package:jellomark_mobile_owner/features/beautishop/data/repositories/shop_repository_impl.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/repositories/shop_repository.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/usecases/create_shop_usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/usecases/delete_shop_usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/usecases/get_my_shop_usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/usecases/update_shop_usecase.dart';
import 'package:jellomark_mobile_owner/features/beautishop/presentation/providers/shop_state.dart';

final shopRemoteDataSourceProvider = Provider<ShopRemoteDataSource>((ref) {
  return ShopRemoteDataSourceImpl(apiClient: sl<ApiClient>());
});

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepositoryImpl(
    remoteDataSource: ref.watch(shopRemoteDataSourceProvider),
    secureStorage: sl<SecureStorageWrapper>(),
  );
});

final getMyShopUseCaseProvider = Provider<GetMyShopUseCase>((ref) {
  return GetMyShopUseCase(repository: ref.watch(shopRepositoryProvider));
});

final createShopUseCaseProvider = Provider<CreateShopUseCase>((ref) {
  return CreateShopUseCase(repository: ref.watch(shopRepositoryProvider));
});

final updateShopUseCaseProvider = Provider<UpdateShopUseCase>((ref) {
  return UpdateShopUseCase(repository: ref.watch(shopRepositoryProvider));
});

final deleteShopUseCaseProvider = Provider<DeleteShopUseCase>((ref) {
  return DeleteShopUseCase(repository: ref.watch(shopRepositoryProvider));
});

final shopStateProvider =
    StateNotifierProvider<ShopStateNotifier, ShopState>((ref) {
  return ShopStateNotifier(
    getMyShopUseCase: ref.watch(getMyShopUseCaseProvider),
    createShopUseCase: ref.watch(createShopUseCaseProvider),
    updateShopUseCase: ref.watch(updateShopUseCaseProvider),
    deleteShopUseCase: ref.watch(deleteShopUseCaseProvider),
  );
});

class ShopStateNotifier extends StateNotifier<ShopState> {
  final GetMyShopUseCase getMyShopUseCase;
  final CreateShopUseCase createShopUseCase;
  final UpdateShopUseCase updateShopUseCase;
  final DeleteShopUseCase deleteShopUseCase;

  ShopStateNotifier({
    required this.getMyShopUseCase,
    required this.createShopUseCase,
    required this.updateShopUseCase,
    required this.deleteShopUseCase,
  }) : super(const ShopInitial());

  Future<void> loadMyShop() async {
    state = const ShopLoading();
    final result = await getMyShopUseCase(NoParams());
    result.fold(
      (failure) => state = ShopError(failure.message),
      (shop) {
        if (shop == null) {
          state = const ShopEmpty();
        } else {
          state = ShopLoaded(shop: shop);
        }
      },
    );
  }

  Future<void> createShop(CreateShopParams params) async {
    state = const ShopCreating();
    final result = await createShopUseCase(params);
    result.fold(
      (failure) => state = ShopError(failure.message),
      (shop) => state = ShopLoaded(shop: shop),
    );
  }

  Future<void> updateShop(UpdateShopParams params) async {
    state = const ShopUpdating();
    final result = await updateShopUseCase(params);
    result.fold(
      (failure) => state = ShopError(failure.message),
      (shop) => state = ShopLoaded(shop: shop),
    );
  }

  Future<void> deleteShop(String shopId) async {
    state = const ShopDeleting();
    final result = await deleteShopUseCase(DeleteShopParams(shopId: shopId));
    result.fold(
      (failure) => state = ShopError(failure.message),
      (_) => state = const ShopEmpty(),
    );
  }

  void reset() {
    state = const ShopInitial();
  }
}

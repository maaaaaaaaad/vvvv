import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/features/owner/presentation/providers/owner_providers.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/features/owner/presentation/providers/owner_state.dart';
import 'package:jellomark_mobile_owner/features/owner/presentation/widgets/owner_info_card.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_gradients.dart';

class OwnerProfilePage extends ConsumerStatefulWidget {
  const OwnerProfilePage({super.key});

  @override
  ConsumerState<OwnerProfilePage> createState() => _OwnerProfilePageState();
}

class _OwnerProfilePageState extends ConsumerState<OwnerProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(ownerStateProvider.notifier).loadCurrentOwner(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ownerState = ref.watch(ownerStateProvider);

    ref.listen<OwnerState>(ownerStateProvider, (previous, next) {
      if (next is OwnerError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.softWhiteGradient),
        child: SafeArea(
          child: _buildBody(ownerState),
        ),
      ),
    );
  }

  Widget _buildBody(OwnerState state) {
    return switch (state) {
      OwnerInitial() => _buildLoading(),
      OwnerLoading() => _buildLoading(),
      OwnerLoaded(:final owner) => _buildLoaded(owner),
      OwnerError(:final message) => _buildError(message),
    };
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.pastelPink),
      ),
    );
  }

  Widget _buildLoaded(Owner owner) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: OwnerInfoCard(owner: owner),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.textPrimary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(ownerStateProvider.notifier).loadCurrentOwner();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pastelPink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '다시 시도',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

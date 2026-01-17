import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/providers/treatment_providers.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/providers/treatment_state.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/widgets/treatment_card.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_gradients.dart';

class TreatmentListPage extends ConsumerStatefulWidget {
  final String shopId;
  final VoidCallback onAddPressed;
  final void Function(Treatment treatment) onTreatmentTap;
  final void Function(Treatment treatment)? onTreatmentEdit;
  final void Function(Treatment treatment)? onTreatmentDelete;
  final Future<void> Function() onRefresh;

  const TreatmentListPage({
    super.key,
    required this.shopId,
    required this.onAddPressed,
    required this.onTreatmentTap,
    this.onTreatmentEdit,
    this.onTreatmentDelete,
    required this.onRefresh,
  });

  @override
  ConsumerState<TreatmentListPage> createState() => _TreatmentListPageState();
}

class _TreatmentListPageState extends ConsumerState<TreatmentListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(treatmentStateProvider.notifier).loadTreatments(widget.shopId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('시술 관리'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.softWhiteGradient),
        child: SafeArea(
          child: _buildBody(state),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAddPressed,
        backgroundColor: AppColors.pastelPink,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody(TreatmentState state) {
    return switch (state) {
      TreatmentInitial() => _buildLoading(),
      TreatmentLoading() => _buildLoading(),
      TreatmentListLoaded(:final treatments) => _buildList(treatments),
      TreatmentEmpty() => _buildEmpty(),
      TreatmentError(:final message) => _buildError(message),
      TreatmentCreating() => _buildLoading(),
      TreatmentCreated() => _buildLoading(),
      TreatmentUpdating() => _buildLoading(),
      TreatmentUpdated() => _buildLoading(),
      TreatmentDeleting() => _buildLoading(),
      TreatmentDeleted() => _buildLoading(),
    };
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.pastelPink),
      ),
    );
  }

  Widget _buildList(List<Treatment> treatments) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: AppColors.pastelPink,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: treatments.length,
        itemBuilder: (context, index) {
          final treatment = treatments[index];
          return TreatmentCard(
            treatment: treatment,
            onTap: () => widget.onTreatmentTap(treatment),
            onEdit: widget.onTreatmentEdit != null
                ? () => widget.onTreatmentEdit!(treatment)
                : null,
            onDelete: widget.onTreatmentDelete != null
                ? () => widget.onTreatmentDelete!(treatment)
                : null,
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: AppColors.pastelPink,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.spa_outlined,
                      size: 80,
                      color: AppColors.pastelPink.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '등록된 시술이 없습니다',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '+ 버튼을 눌러 시술을 추가해보세요',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(String message) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: AppColors.pastelPink,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: AppColors.darkPink.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '아래로 당겨서 다시 시도해보세요',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

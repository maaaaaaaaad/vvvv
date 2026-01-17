import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/usecases/create_treatment_usecase.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/providers/treatment_providers.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/providers/treatment_state.dart';
import 'package:jellomark_mobile_owner/features/treatment/presentation/widgets/treatment_form.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_gradients.dart';

class TreatmentCreatePage extends ConsumerStatefulWidget {
  final String shopId;
  final VoidCallback onSuccess;

  const TreatmentCreatePage({
    super.key,
    required this.shopId,
    required this.onSuccess,
  });

  @override
  ConsumerState<TreatmentCreatePage> createState() => _TreatmentCreatePageState();
}

class _TreatmentCreatePageState extends ConsumerState<TreatmentCreatePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(treatmentStateProvider, (previous, next) {
        if (next is TreatmentCreated) {
          widget.onSuccess();
        } else if (next is TreatmentError) {
          _showErrorSnackBar(next.message);
        }
      });
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.darkPink,
      ),
    );
  }

  void _onSubmit(
    String name,
    String? description,
    int price,
    int duration,
    String? imageUrl,
  ) {
    ref.read(treatmentStateProvider.notifier).createTreatment(
      CreateTreatmentParams(
        shopId: widget.shopId,
        name: name,
        description: description,
        price: price,
        duration: duration,
        imageUrl: imageUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentStateProvider);
    final isSubmitting = state is TreatmentCreating;

    return Scaffold(
      appBar: AppBar(
        title: const Text('시술 등록'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.softWhiteGradient),
        child: SafeArea(
          child: TreatmentForm(
            onSubmit: _onSubmit,
            isSubmitting: isSubmitting,
          ),
        ),
      ),
    );
  }
}

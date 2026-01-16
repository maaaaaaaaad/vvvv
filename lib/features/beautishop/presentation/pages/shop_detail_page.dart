import 'package:flutter/material.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/features/beautishop/presentation/widgets/shop_action_buttons.dart';
import 'package:jellomark_mobile_owner/features/beautishop/presentation/widgets/shop_info_card.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_gradients.dart';

class ShopDetailPage extends StatelessWidget {
  final Beautishop shop;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Future<void> Function() onCategorySettings;
  final Future<void> Function() onRefresh;
  final bool isDeleting;

  const ShopDetailPage({
    super.key,
    required this.shop,
    required this.onEdit,
    required this.onDelete,
    required this.onCategorySettings,
    required this.onRefresh,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 샵'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.softWhiteGradient),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            color: AppColors.pastelPink,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    ShopInfoCard(shop: shop),
                    const SizedBox(height: 24),
                    ShopActionButtons(
                      onEdit: onEdit,
                      onDelete: onDelete,
                      onCategorySettings: onCategorySettings,
                      isDeleting: isDeleting,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

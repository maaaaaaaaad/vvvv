import 'package:flutter/material.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';

class ShopActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Future<void> Function() onCategorySettings;
  final bool isDeleting;

  const ShopActionButtons({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onCategorySettings,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildCategorySettingsButton(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildEditButton(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDeleteButton(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySettingsButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isDeleting ? null : onCategorySettings,
        icon: const Icon(Icons.category, size: 18),
        label: const Text('카테고리 설정'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lavenderDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: AppColors.lavenderDark.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return ElevatedButton.icon(
      onPressed: isDeleting ? null : onEdit,
      icon: const Icon(Icons.edit, size: 18),
      label: const Text('수정'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.pastelPink,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBackgroundColor: AppColors.pastelPink.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isDeleting ? null : () => _showDeleteConfirmDialog(context),
      icon: isDeleting
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.delete, size: 18),
      label: const Text('삭제'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBackgroundColor: Colors.red.shade200,
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          '샵 삭제',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          '정말로 샵을 삭제하시겠습니까?',
          style: TextStyle(
            color: AppColors.textPrimary.withValues(alpha: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '취소',
              style: TextStyle(
                color: AppColors.textPrimary.withValues(alpha: 0.6),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            child: Text(
              '삭제하기',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

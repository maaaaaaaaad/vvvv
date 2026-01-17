import 'package:flutter/material.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';

class TreatmentCard extends StatelessWidget {
  final Treatment treatment;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TreatmentCard({
    super.key,
    required this.treatment,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  String _formatPrice(int price) {
    final priceStr = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < priceStr.length; i++) {
      if (i > 0 && (priceStr.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(priceStr[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              if (treatment.description != null) ...[
                const SizedBox(height: 8),
                _buildDescription(),
              ],
              const SizedBox(height: 12),
              _buildInfoRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            treatment.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (onEdit != null || onDelete != null) _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          IconButton(
            onPressed: onEdit,
            icon: Icon(
              Icons.edit,
              size: 20,
              color: AppColors.pastelPink,
            ),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
        if (onDelete != null)
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete,
              size: 20,
              color: AppColors.darkPink,
            ),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      treatment.description!,
      style: TextStyle(
        fontSize: 14,
        color: AppColors.textPrimary.withValues(alpha: 0.7),
        height: 1.4,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        _buildPriceChip(),
        const SizedBox(width: 12),
        _buildDurationChip(),
      ],
    );
  }

  Widget _buildPriceChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${_formatPrice(treatment.price)}원',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.darkPink,
        ),
      ),
    );
  }

  Widget _buildDurationChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: 16,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 4),
          Text(
            '${treatment.duration}분',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

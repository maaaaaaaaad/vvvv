import 'package:flutter/material.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_gradients.dart';

class TreatmentDetailPage extends StatelessWidget {
  final Treatment treatment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;

  const TreatmentDetailPage({
    super.key,
    required this.treatment,
    required this.onEdit,
    required this.onDelete,
    this.isDeleting = false,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('시술 상세'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            onPressed: onEdit,
            icon: Icon(Icons.edit, color: AppColors.pastelPink),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.softWhiteGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 24),
                  _buildDeleteButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (treatment.imageUrl != null) ...[
            _buildImage(),
            const SizedBox(height: 20),
          ],
          _buildName(),
          const SizedBox(height: 16),
          _buildPriceAndDuration(),
          if (treatment.description != null) ...[
            const SizedBox(height: 16),
            _buildDivider(),
            const SizedBox(height: 16),
            _buildDescription(),
          ],
        ],
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        treatment.imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.lightPink,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              Icons.spa,
              size: 60,
              color: AppColors.pastelPink,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return Text(
      treatment.name,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildPriceAndDuration() {
    return Row(
      children: [
        _buildInfoChip(
          icon: Icons.attach_money,
          label: '${_formatPrice(treatment.price)}원',
          color: AppColors.lightPink,
          textColor: AppColors.darkPink,
        ),
        const SizedBox(width: 12),
        _buildInfoChip(
          icon: Icons.timer,
          label: '${treatment.duration}분',
          color: AppColors.backgroundLight,
          textColor: AppColors.textPrimary.withValues(alpha: 0.7),
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.glassBorder,
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '설명',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          treatment.description!,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return OutlinedButton(
      onPressed: isDeleting ? null : onDelete,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkPink,
        side: BorderSide(color: AppColors.darkPink),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: isDeleting
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkPink),
              ),
            )
          : const Text(
              '삭제',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}

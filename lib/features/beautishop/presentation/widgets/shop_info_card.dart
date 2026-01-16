import 'package:flutter/material.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';

class ShopInfoCard extends StatelessWidget {
  final Beautishop shop;

  const ShopInfoCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImageSection(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildRatingSection(),
                const SizedBox(height: 16),
                _buildDivider(),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.location_on, shop.address),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.phone, shop.phoneNumber),
                if (shop.description != null) ...[
                  const SizedBox(height: 16),
                  _buildDivider(),
                  const SizedBox(height: 16),
                  _buildDescription(),
                ],
                if (shop.categories.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildCategoryChips(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: shop.image != null
          ? ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                shop.image!,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
              ),
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.store,
        size: 60,
        color: AppColors.pastelPink,
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      shop.name,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        Icon(
          Icons.star,
          size: 20,
          color: Colors.amber,
        ),
        const SizedBox(width: 4),
        Text(
          shop.averageRating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '(${shop.reviewCount})',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.glassBorder,
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.pastelPink,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      shop.description!,
      style: TextStyle(
        fontSize: 14,
        color: AppColors.textPrimary.withValues(alpha: 0.8),
        height: 1.5,
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: shop.categories.map((category) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.lightPink,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.pastelPink.withValues(alpha: 0.5)),
          ),
          child: Text(
            category.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.darkPink,
            ),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';

class OwnerInfoCard extends StatelessWidget {
  final Owner owner;

  const OwnerInfoCard({super.key, required this.owner});

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildDivider(),
            const SizedBox(height: 20),
            _buildInfoRow(label: '이메일', value: owner.email),
            const SizedBox(height: 16),
            _buildInfoRow(label: '사업자등록번호', value: owner.businessNumber),
            const SizedBox(height: 16),
            _buildInfoRow(label: '휴대폰 번호', value: owner.phoneNumber),
            const SizedBox(height: 16),
            _buildInfoRow(label: '가입일', value: _formatDate(owner.createdAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.lightPink,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.pastelPink, width: 3),
          ),
          child: Icon(
            Icons.person,
            size: 40,
            color: AppColors.pastelPink,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          owner.nickname,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
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

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

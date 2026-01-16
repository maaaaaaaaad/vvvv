import 'package:flutter/material.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_gradients.dart';

class ShopEditPage extends StatefulWidget {
  final Beautishop shop;
  final void Function(
    Map<String, String>? operatingTime,
    String? description,
    String? image,
  ) onSave;
  final bool isUpdating;

  const ShopEditPage({
    super.key,
    required this.shop,
    required this.onSave,
    this.isUpdating = false,
  });

  @override
  State<ShopEditPage> createState() => _ShopEditPageState();
}

class _ShopEditPageState extends State<ShopEditPage> {
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.shop.description);
    _imageController = TextEditingController(text: widget.shop.image);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _onSave() {
    if (widget.isUpdating) return;

    final description = _descriptionController.text.isEmpty
        ? null
        : _descriptionController.text;
    final image = _imageController.text.isEmpty ? null : _imageController.text;

    widget.onSave(null, description, image);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('샵 정보 수정'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
        ),
        body: Container(
          decoration: const BoxDecoration(gradient: AppGradients.softWhiteGradient),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildShopInfoCard(),
                          const SizedBox(height: 24),
                          _buildEditForm(),
                          const SizedBox(height: 32),
                          _buildSaveButton(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShopInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '샵 정보',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.shop.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.shop.address,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '수정 가능 정보',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          _buildDescriptionField(),
          const SizedBox(height: 16),
          _buildImageField(),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      autofocus: false,
      maxLines: 4,
      decoration: _inputDecoration(
        label: '샵 소개',
        hint: '샵 소개를 입력해주세요',
      ),
    );
  }

  Widget _buildImageField() {
    return TextFormField(
      controller: _imageController,
      autofocus: false,
      decoration: _inputDecoration(
        label: '이미지 URL',
        hint: 'https://example.com/image.jpg',
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: widget.isUpdating ? null : _onSave,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.pastelPink,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBackgroundColor: AppColors.pastelPink.withValues(alpha: 0.5),
      ),
      child: widget.isUpdating
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              '저장',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.pastelPink, width: 2),
      ),
      labelStyle: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.7)),
      hintStyle: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.4)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/usecases/create_shop_usecase.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';

class ShopCreateBottomSheet extends StatefulWidget {
  final void Function(CreateShopParams params) onCreate;
  final bool isCreating;

  const ShopCreateBottomSheet({
    super.key,
    required this.onCreate,
    this.isCreating = false,
  });

  @override
  State<ShopCreateBottomSheet> createState() => _ShopCreateBottomSheetState();
}

class _ShopCreateBottomSheetState extends State<ShopCreateBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _regNumController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _operatingTimeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void dispose() {
    _shopNameController.dispose();
    _regNumController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _operatingTimeController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _onCreate() {
    if (widget.isCreating) return;
    if (!_formKey.currentState!.validate()) return;

    final params = CreateShopParams(
      shopName: _shopNameController.text.trim(),
      shopRegNum: _regNumController.text.trim(),
      shopPhoneNumber: _phoneController.text.trim(),
      shopAddress: _addressController.text.trim(),
      latitude: 37.5665,
      longitude: 126.9780,
      operatingTime: {'MON-FRI': _operatingTimeController.text.trim()},
      shopDescription: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text.trim(),
      shopImage:
          _imageController.text.isEmpty ? null : _imageController.text.trim(),
    );

    widget.onCreate(params);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHandle(),
                  const SizedBox(height: 16),
                  _buildTitle(),
                  const SizedBox(height: 24),
                  _buildShopNameField(),
                  const SizedBox(height: 16),
                  _buildRegNumField(),
                  const SizedBox(height: 16),
                  _buildPhoneField(),
                  const SizedBox(height: 16),
                  _buildAddressField(),
                  const SizedBox(height: 16),
                  _buildOperatingTimeField(),
                  const SizedBox(height: 16),
                  _buildDescriptionField(),
                  const SizedBox(height: 16),
                  _buildImageField(),
                  const SizedBox(height: 32),
                  _buildCreateButton(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      '샵 등록',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildShopNameField() {
    return TextFormField(
      controller: _shopNameController,
      autofocus: false,
      decoration: _inputDecoration(label: '샵 이름', hint: '예: 뷰티살롱'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '샵 이름을 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget _buildRegNumField() {
    return TextFormField(
      controller: _regNumController,
      autofocus: false,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration(label: '사업자등록번호', hint: '1234567890'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '사업자등록번호를 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      autofocus: false,
      keyboardType: TextInputType.phone,
      decoration: _inputDecoration(label: '전화번호', hint: '02-1234-5678'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '전화번호를 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      autofocus: false,
      decoration: _inputDecoration(label: '주소', hint: '서울시 강남구...'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '주소를 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget _buildOperatingTimeField() {
    return TextFormField(
      controller: _operatingTimeController,
      autofocus: false,
      decoration: _inputDecoration(label: '영업시간', hint: '09:00-18:00'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '영업시간을 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      autofocus: false,
      maxLines: 3,
      decoration: _inputDecoration(label: '샵 소개 (선택)', hint: '샵 소개를 입력해주세요'),
    );
  }

  Widget _buildImageField() {
    return TextFormField(
      controller: _imageController,
      autofocus: false,
      decoration:
          _inputDecoration(label: '이미지 URL (선택)', hint: 'https://example.com/image.jpg'),
    );
  }

  Widget _buildCreateButton() {
    return ElevatedButton(
      onPressed: widget.isCreating ? null : _onCreate,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.pastelPink,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBackgroundColor: AppColors.pastelPink.withValues(alpha: 0.5),
      ),
      child: widget.isCreating
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              '등록하기',
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
      fillColor: Colors.grey.shade50,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      labelStyle: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.7)),
      hintStyle: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.4)),
    );
  }
}

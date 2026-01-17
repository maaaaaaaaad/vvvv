import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';

class TreatmentForm extends StatefulWidget {
  final Treatment? initialTreatment;
  final void Function(
    String name,
    String? description,
    int price,
    int duration,
    String? imageUrl,
  ) onSubmit;
  final bool isSubmitting;

  const TreatmentForm({
    super.key,
    this.initialTreatment,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  @override
  State<TreatmentForm> createState() => _TreatmentFormState();
}

class _TreatmentFormState extends State<TreatmentForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialTreatment?.name,
    );
    _descriptionController = TextEditingController(
      text: widget.initialTreatment?.description,
    );
    _priceController = TextEditingController(
      text: widget.initialTreatment?.price.toString(),
    );
    _durationController = TextEditingController(
      text: widget.initialTreatment?.duration.toString(),
    );
    _imageUrlController = TextEditingController(
      text: widget.initialTreatment?.imageUrl,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _onSubmit() {
    if (widget.isSubmitting) return;
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(
        _nameController.text,
        _descriptionController.text.isEmpty ? null : _descriptionController.text,
        int.parse(_priceController.text),
        int.parse(_durationController.text),
        _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
      );
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '시술명을 입력해주세요';
    }
    return null;
  }

  String? _validatePositiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return '값을 입력해주세요';
    }
    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return '0보다 큰 값을 입력해주세요';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildNameField(),
                const SizedBox(height: 16),
                _buildDescriptionField(),
                const SizedBox(height: 16),
                _buildPriceField(),
                const SizedBox(height: 16),
                _buildDurationField(),
                const SizedBox(height: 16),
                _buildImageUrlField(),
                const SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      autofocus: false,
      decoration: _inputDecoration(
        label: '시술명',
        hint: '시술명을 입력해주세요',
      ),
      validator: _validateName,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      autofocus: false,
      maxLines: 3,
      decoration: _inputDecoration(
        label: '설명',
        hint: '시술에 대한 설명을 입력해주세요',
      ),
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      autofocus: false,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: _inputDecoration(
        label: '가격',
        hint: '가격을 입력해주세요',
        suffix: '원',
      ),
      validator: _validatePositiveNumber,
    );
  }

  Widget _buildDurationField() {
    return TextFormField(
      controller: _durationController,
      autofocus: false,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: _inputDecoration(
        label: '소요시간 (분)',
        hint: '소요시간을 입력해주세요',
        suffix: '분',
      ),
      validator: _validatePositiveNumber,
    );
  }

  Widget _buildImageUrlField() {
    return TextFormField(
      controller: _imageUrlController,
      autofocus: false,
      decoration: _inputDecoration(
        label: '이미지 URL',
        hint: 'https://example.com/image.jpg',
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: widget.isSubmitting ? null : _onSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.pastelPink,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBackgroundColor: AppColors.pastelPink.withValues(alpha: 0.5),
      ),
      child: widget.isSubmitting
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
    String? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixText: suffix,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkPink),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkPink, width: 2),
      ),
      labelStyle: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.7)),
      hintStyle: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.4)),
    );
  }
}

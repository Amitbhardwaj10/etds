import 'package:flutter/material.dart';
import 'package:frontend/theme/app_theme.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool readOnly;
  final Icon? suffixIcon;
  final VoidCallback? onTap;
  final String? Function(String?)? _validator;
  const InputField({
    super.key,
    required this.hintText,
    this.controller,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
    this._validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      validator: _validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppTheme.secondaryText),
        contentPadding: EdgeInsets.only(left: 10),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.borderColor),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

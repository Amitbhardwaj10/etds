import 'package:flutter/material.dart';
import 'package:frontend/theme/app_theme.dart';

class Button extends StatelessWidget {
  final String text;
  final Color? bgColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsetsGeometry padding;
  final IconData? icon;
  final VoidCallback? onPressed;


  const Button({
    super.key,
    required this.text,
    this.bgColor = AppTheme.primaryWhite,
    this.textColor = AppTheme.secondaryText,
    this.borderColor = AppTheme.borderColor,
    this.borderWidth = 1,
    this.padding = const EdgeInsets.symmetric(horizontal: 14),
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding,
        backgroundColor: bgColor ?? Colors.white,
        foregroundColor: textColor,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        side: BorderSide(
          color: borderColor ?? Colors.transparent,
          width: borderWidth ?? 1,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        disabledForegroundColor: textColor,
        disabledBackgroundColor: bgColor,
        disabledMouseCursor: SystemMouseCursors.forbidden,
      ),
      onPressed: onPressed,
      child: Row(
        spacing: 5,
        children: [(icon != null ? Icon(icon) : SizedBox.shrink()), Text(text)],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? backgroundColor;

  const StatusBadge({
    super.key,
    required this.text,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(50),
        border: BoxBorder.all(width: 1, color: color ?? Colors.transparent),
      ),

      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:frontend/theme/app_theme.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String? hintText;
  final ValueNotifier<String?> valueListenable;
  final ValueChanged<String?>? onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.valueListenable,
    this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      isExpanded: true,

      items: items
          .map(
            (item) => DropdownItem<String>(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),

      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 0,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.primaryColor,
            width: 2,
          ),
        ),
      ),

      dropdownStyleData: DropdownStyleData(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: AppTheme.primaryWhite,
        ),
      ),

      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 15),
      ),

      hint: Text(
        hintText ?? 'Select',
        style: TextStyle(
          color: AppTheme.secondaryText,
          fontWeight: FontWeight.normal,
        ),
      ),

      valueListenable: valueListenable,

      onChanged: (value) {
        valueListenable.value = value;
        onChanged?.call(value);
      },
    );
  }
}

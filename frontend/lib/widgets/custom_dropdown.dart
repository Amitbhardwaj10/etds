import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:frontend/theme/app_theme.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String? hintText;

  CustomDropdown({super.key, required this.items, this.hintText});

  final valueListenable = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      isExpanded: true,
      items: items
          .map((item) => DropdownItem(value: item, child: Text(item)))
          .toList(),

      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),

        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.borderColor),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
      ),

      dropdownStyleData: DropdownStyleData(
        padding: EdgeInsets.symmetric(horizontal: 0),
      ),

      menuItemStyleData: MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 15),
      ),

      hint: Text(hintText ?? ''),
      
      valueListenable: valueListenable,

      onChanged: (value) {
        valueListenable.value = value;
      },
    );
  }
}

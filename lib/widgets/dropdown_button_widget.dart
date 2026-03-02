import 'package:flutter/material.dart';

class DropdownButtonWidget extends StatelessWidget {
  final String hint;
  final TextStyle style;
  final Color dropdownColor;
  final IconData dropdownIcon;
  final double borderWidth;
  final Color borderColor;
  final double borderRadius;
  final double iconSize;
  final double horizontalPadding;
  final double verticalPadding;
  final String? selectedValue;
  final bool readOnly;
  final Function(String) selectedValueChanged;
  final List<DropdownItem> items;

  const DropdownButtonWidget({
    Key? key,
    required this.items,
    required this.selectedValue,
    required this.selectedValueChanged,
    this.hint = '',
    this.dropdownColor = Colors.white,
    this.dropdownIcon = Icons.arrow_drop_down,
    this.borderWidth = 1.0,
    this.borderColor = Colors.grey,
    this.borderRadius = 6.0,
    this.iconSize = 24,
    this.horizontalPadding = 16,
    this.verticalPadding = 0,
    this.readOnly = false,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: verticalPadding),
      decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderWidth),
          borderRadius: BorderRadius.circular(borderRadius)),
      child: DropdownButton<String>(
          hint: Text(hint),
          dropdownColor: dropdownColor,
          icon: Icon(dropdownIcon),
          iconSize: iconSize,
          isExpanded: true,
          elevation: 3,
          underline: const SizedBox(),
          value: selectedValue,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item.value,
              child: Text(
                item.text,
                style: style,
              ),
            );
          }).toList(),
          onChanged: readOnly ? null : (value) => selectedValueChanged(value!)),
    );
  }
}

class DropdownItem {
  final String text;
  final String value;
  final IconData? icon;
  DropdownItem(this.text, this.value, {this.icon});
}

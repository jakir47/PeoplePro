import 'package:peoplepro/utils/colors.dart';
import 'package:flutter/material.dart';

class CheckboxWidget extends StatelessWidget {
  final String label;
  final bool? value;
  final ValueChanged<bool?> checkedChanged;
  final bool tristate;
  final Color color;
  const CheckboxWidget(
      {Key? key,
      required this.label,
      required this.value,
      required this.checkedChanged,
      this.tristate = false,
      this.color = Colors.black87})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (tristate) {
          checkedChanged(value == null ? false : !value!);
        } else {
          checkedChanged(!value!);
        }
      },
      leading: Checkbox(
        value: value,
        onChanged: (newValue) {
          if (tristate) {
            checkedChanged(value == null ? false : !value!);
          } else {
            checkedChanged(!value!);
          }
        },
        tristate: tristate,
        activeColor: UserColors.primaryColor,
      ),
      title: Text(
        label,
        style: TextStyle(fontSize: 14, color: color),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      minVerticalPadding: 0,
      horizontalTitleGap: 0,
      minLeadingWidth: 0,
      dense: true,
    );
  }
}

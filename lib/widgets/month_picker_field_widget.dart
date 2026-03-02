import 'package:peoplepro/packages/month_picker_package.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthPickerWidget extends StatefulWidget {
  final ValueChanged<DateTime?>? onChanged;
  final TextEditingController? controller;
  final DateTime? selectedDate;
  const MonthPickerWidget({
    Key? key,
    @required this.controller,
    @required this.onChanged,
    @required this.selectedDate,
  }) : super(key: key);

  @override
  _MonthPickerWidgetState createState() => _MonthPickerWidgetState();
}

class _MonthPickerWidgetState extends State<MonthPickerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: widget.controller,
              readOnly: true,
              maxLines: 1,
              decoration: InputDecoration(
                  errorStyle:
                      const TextStyle(height: 0, color: Colors.transparent),
                  contentPadding: const EdgeInsets.only(left: 12.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: UserColors.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: UserColors.primaryColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                  ),
                  suffixIcon: GestureDetector(
                      child: Icon(
                        Icons.calendar_today_outlined,
                        size: 18.0,
                        color: UserColors.primaryColor,
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());

                        DateTime? inputDate;
                        inputDate = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MonthPickerDialog(
                              selectedDate: widget.selectedDate!,
                            );
                          },
                        );

                        if (inputDate == null) return;
                        var date = DateFormat('MMMM - yyyy').format(inputDate);
                        widget.controller!.text = date;
                        widget.onChanged!.call(inputDate);
                      })),
            ),
          ),
        ],
      );
}

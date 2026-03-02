import 'package:peoplepro/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:peoplepro/packages/date_picker_package.dart';
import 'package:intl/intl.dart';

class DateFieldWidget extends StatefulWidget {
  final ValueChanged<DateTime?>? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final DateTime? minDate;
  final DateTime? maxDate;
  final double? boderRadius;

  const DateFieldWidget(
      {Key? key,
      @required this.controller,
      @required this.onChanged,
      this.validator,
      this.minDate,
      this.maxDate,
      this.boderRadius = 10.0})
      : super(key: key);

  @override
  _DateFieldWidgetState createState() => _DateFieldWidgetState();
}

class _DateFieldWidgetState extends State<DateFieldWidget> {
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
              validator: widget.validator,
              decoration: InputDecoration(
                  errorStyle:
                      const TextStyle(height: 0, color: Colors.transparent),
                  contentPadding: const EdgeInsets.only(left: 12.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.boderRadius!),
                    borderSide: BorderSide(color: UserColors.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.boderRadius!),
                    borderSide: BorderSide(color: UserColors.primaryColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.boderRadius!),
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
                        inputDate = await showDatePickerEx(
                            context: context,
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                    colorScheme:
                                        const ColorScheme.light().copyWith(
                                      primary: UserColors.primaryColor,
                                    ),
                                    dialogTheme: const DialogTheme(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)))),
                                    textTheme: const TextTheme(
                                      headline4: TextStyle(fontSize: 16),
                                    )),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 24,
                                      ),
                                      child: SizedBox(
                                        height: 400,
                                        child: child,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            initialDate: DateTime.now(),
                            firstDate: widget.minDate == null
                                ? DateTime(1930)
                                : widget.minDate!,
                            lastDate: widget.maxDate == null
                                ? DateTime(2030)
                                : widget.maxDate!);

                        if (inputDate == null) return;
                        var date = DateFormat('dd/MM/yyyy').format(inputDate);
                        widget.controller!.text = date;
                        widget.onChanged!.call(inputDate);
                      })),
            ),
          ),
        ],
      );
}

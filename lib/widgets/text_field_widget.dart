import 'package:peoplepro/utils/colors.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final String? label;
  final String? text;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  const TextFieldWidget(
      {Key? key,
      @required this.label,
      @required this.text,
      this.maxLines = 1,
      @required this.onChanged,
      this.readOnly = false})
      : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label!,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            readOnly: widget.readOnly,
            controller: controller,
            maxLines: widget.maxLines,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(color: UserColors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(color: UserColors.primaryColor),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          ),
        ],
      );
}

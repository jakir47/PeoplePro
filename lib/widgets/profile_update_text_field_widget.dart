import 'package:peoplepro/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileUpdateTextFieldWidget extends StatefulWidget {
  final String? label;
  final TextEditingController? controller;
  final ValueChanged<bool>? onEdited;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final bool? preventSpace;
  final String? placeHolderText;
  bool readOnly;

  ProfileUpdateTextFieldWidget(
      {Key? key,
      @required this.label,
      @required this.controller,
      @required this.onEdited,
      @required this.textInputType,
      this.validator,
      this.placeHolderText = "",
      this.preventSpace = false,
      this.readOnly = false})
      : super(key: key);

  @override
  ProfileUpdateTextFieldWidgetState createState() =>
      ProfileUpdateTextFieldWidgetState();
}

class ProfileUpdateTextFieldWidgetState
    extends State<ProfileUpdateTextFieldWidget> {
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 1.0),
                      child: Text(
                        widget.label!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: UserColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: SizedBox(
                      child: TextFormField(
                          readOnly: widget.readOnly,
                          focusNode: _focusNode,
                          controller: widget.controller,
                          decoration: InputDecoration(
                            hintText: widget.placeHolderText,
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 0.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide:
                                  BorderSide(color: UserColors.borderColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide:
                                  BorderSide(color: UserColors.primaryColor),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            if (widget.preventSpace!)
                              FilteringTextInputFormatter.deny(RegExp(r"\s"))
                          ],
                          keyboardType: widget.textInputType,
                          validator: widget.validator),
                    )),
              ],
            ),
          )
        ],
      );
}

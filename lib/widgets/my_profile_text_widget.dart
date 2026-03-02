import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class MyProfileTextWidget extends StatefulWidget {
  final String? label;
  final String? text;

  const MyProfileTextWidget({
    Key? key,
    @required this.label,
    @required this.text,
  }) : super(key: key);

  @override
  _MyProfileTextWidgetState createState() => _MyProfileTextWidgetState();
}

class _MyProfileTextWidgetState extends State<MyProfileTextWidget> {
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
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
                    if (widget.text!.isNotEmpty)
                      GestureDetector(
                          onTap: () {
                            FlutterClipboard.copy(widget.text!).then((value) =>
                                Utils.showToast("${widget.label} text copied"));
                          },
                          child: const Icon(
                            Icons.copy_rounded,
                            size: 20.0,
                            color: Colors.black45,
                          ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: UserColors.primaryColor),
                    ),
                    child: Text(
                      widget.text!,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
}

import 'dart:ui';
import 'package:peoplepro/services/notification_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;

  late FocusNode _focusNodeTitle;
  late FocusNode _focusNodeText;

  var txtCtrlTitle = TextEditingController();
  var txtCtrlNotification = TextEditingController();

  @override
  void initState() {
    _focusNodeTitle = FocusNode();
    _focusNodeText = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Notification",
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.3),
                      borderRadius: BorderRadiusDirectional.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: txtCtrlTitle,
                              focusNode: _focusNodeTitle,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                contentPadding: const EdgeInsets.all(10.0),
                                hintText: 'Enter title here!',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter notification title';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _title = value!;
                              },
                            ),
                            const SizedBox(height: 12.0),
                            Flexible(
                              child: TextFormField(
                                controller: txtCtrlNotification,
                                maxLines: null,
                                minLines: 6,
                                keyboardType: TextInputType.multiline,
                                focusNode: _focusNodeText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: 'Enter text here!',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter notification text';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _content = value!;
                                },
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            ElevatedButton(
                              onPressed: () async {
                                await createNotification();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: UserColors.primaryColor),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                              ),
                              child: const Text(
                                'Send',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createNotification() async {
    _focusNodeTitle.unfocus();
    _focusNodeText.unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var success = await NotificationService.create(_title, _content);

      if (success) {
        //    Navigator.pop(context);
        MessageBox.success(
            context, "Success", "Notification created successully.");
      } else {
        MessageBox.error(context, "Error", "Unable to create notification!");
      }
    }
  }
}

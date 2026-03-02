import 'package:animations/animations.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageBox {
  static void show(BuildContext context, String title, String text,
      {bool exitApp = false}) {
    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 300),
            reverseTransitionDuration: Duration(milliseconds: 200),
            barrierDismissible: false),
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      text,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                UserColors.primaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(
                                      color: UserColors.primaryColor)),
                            )),
                        child: const Text("OK"),
                        onPressed: () => exitApp
                            ? SystemNavigator.pop()
                            : Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  static void success(BuildContext context, String title, String text,
      {bool exitApp = false, Function? onOkTapped}) async {
    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 300),
            reverseTransitionDuration: Duration(milliseconds: 200),
            barrierDismissible: false),
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextButton(
                        child: const Text(
                          "OK",
                          style: TextStyle(color: Colors.green),
                        ),
                        onPressed: () {
                          if (exitApp) {
                            SystemNavigator.pop();
                          } else {
                            Navigator.of(context).pop();
                            if (onOkTapped != null) {
                              onOkTapped.call();
                            }
                          }
                        }),
                  ],
                ),
              ),
            ));
  }

  static void error(BuildContext context, String title, String text,
      {bool exitApp = false}) {
    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 300),
            reverseTransitionDuration: Duration(milliseconds: 200),
            barrierDismissible: false),
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextButton(
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () => exitApp
                          ? SystemNavigator.pop()
                          : Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ));
  }

  static void withWidget(BuildContext context, String title, Widget child,
      {bool exitApp = false,
      Color headerColor = Colors.black87,
      Color OkColor = Colors.black87}) {
    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 300),
            reverseTransitionDuration: Duration(milliseconds: 200),
            barrierDismissible: false),
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    opacity: 0.5,
                    fit: BoxFit.cover,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 14,
                          color: headerColor,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Flexible(
                      child: child,
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    TextButton(
                      child: Text(
                        "OK",
                        style: TextStyle(color: OkColor),
                      ),
                      onPressed: () => exitApp
                          ? SystemNavigator.pop()
                          : Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ));
  }

  static void successWidget(BuildContext context, String title, Widget text,
      {bool exitApp = false}) {
    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 300),
            reverseTransitionDuration: Duration(milliseconds: 200),
            barrierDismissible: false),
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Flexible(
                      child: text,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextButton(
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: () => exitApp
                          ? SystemNavigator.pop()
                          : Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ));
  }

  static void showConfirm(
    BuildContext context,
    String title,
    String text, {
    String cancelButtonText = "CANCEL",
    Color? cancelButtonColor,
    VoidCallback? cancelCallBack,
    String okButtonText = "OK",
    required VoidCallback okCallBack,
  }) {
    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 300),
            reverseTransitionDuration: Duration(milliseconds: 200),
            barrierDismissible: false),
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      text,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () =>
                                cancelCallBack ?? Navigator.pop(context),
                            child: Text(cancelButtonText),
                          ),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        SizedBox(
                          child: ElevatedButton(
                              child: Text(okButtonText),
                              onPressed: () {
                                okCallBack();
                                Navigator.pop(context);
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }
}

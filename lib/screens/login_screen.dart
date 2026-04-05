import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:peoplepro/screens/error_screen.dart';
import 'package:peoplepro/screens/home_screen.dart';
import 'package:peoplepro/services/user_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:qr_flutter/qr_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscured = true;
  bool isRemembered = false;
  int copyrightYear = DateTime.now().year;

  var keyboardVisibilityController = KeyboardVisibilityController();
  bool isWidgetVisiabled = true;

  @override
  void initState() {
    super.initState();
    userIdController.addListener(() => setState(() {}));
    keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        isWidgetVisiabled = !visible;
      });
    });
  }

  @override
  void dispose() {
    userIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BackgroundWidget(
          showTitlebar: false,
          showPoweredBy: true,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: formKey,
                    child: AutofillGroup(
                      child: Column(
                        children: [
                          Visibility(
                            visible: isWidgetVisiabled,
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/bgi3d.png',
                                  width: 100,
                                  height: 100,
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: "People",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade700,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: "Pro",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: UserColors.primaryColor,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // child: SvgPicture.asset(
                            //   'assets/images/logo.svg',
                            //   color: UserColors.primaryColor,
                            //   height: 120,
                            //   width: 120,
                            // ),
                          ),
                          const SizedBox(height: 32.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12.0),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                border: Border.all(
                                    width: 1, color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: userIdController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Your Employee ID',
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    hintStyle:
                                        const TextStyle(color: Colors.black38),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 0.0, vertical: 12.0),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue.withOpacity(0.5),
                                          width: 1.0),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                    errorBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2.0),
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 2.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  autofillHints: const [AutofillHints.username],
                                  textInputAction: TextInputAction.done,
                                  validator: (username) =>
                                      username != null && username.isEmpty
                                          ? 'Enter Your User ID'
                                          : null,
                                ),
                                TextFormField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Your Password',
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    hintStyle:
                                        const TextStyle(color: Colors.black38),
                                    suffixIcon: GestureDetector(
                                      onTap: () => setState(
                                          () => isObscured = !isObscured),
                                      child: Icon(
                                        isObscured
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 16.0,
                                        color: UserColors.primaryColor,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 0.0, vertical: 12.0),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue.withOpacity(0.5),
                                          width: 1.0),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                    errorBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2.0),
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 2.0),
                                    ),
                                  ),
                                  obscureText: isObscured,
                                  keyboardType: TextInputType.visiblePassword,
                                  autofillHints: const [AutofillHints.password],
                                  textInputAction: TextInputAction.done,
                                  validator: (password) =>
                                      password != null && password.isEmpty
                                          ? 'Enter Your Password'
                                          : null,
                                ),
                                if (Platform.isAndroid)
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        child: Switch(
                                          value: isRemembered,
                                          activeColor: UserColors.primaryColor,
                                          onChanged: (value) {
                                            setState(() {
                                              isRemembered = value;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Remember ID",
                                        style: TextStyle(
                                            color: Colors.grey.shade800,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    UserColors.primaryColor),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                  side: BorderSide(
                                                      color: UserColors
                                                          .primaryColor)),
                                            )),
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            formKey.currentState!.save();

                                            var userId = userIdController.text;
                                            var password =
                                                passwordController.text;

                                            fetchData();

                                            login(
                                                userId, password, isRemembered);
                                          }
                                        },
                                        child: const Text(
                                          "Login",
                                        ))),
                                const SizedBox(height: 3.0),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Forgotten password?",
                                        style: TextStyle(
                                            color: Colors.grey.shade800,
                                            fontSize: 13.0),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        highlightColor:
                                            const Color.fromARGB(0, 43, 0, 0),
                                        onTap: () {
                                          if (kDebugMode) {
                                            userIdController.text = "047785";
                                            passwordController.text = "jakir87";
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0.0, vertical: 8.0),
                                          child: Text('Tap here!',
                                              style: TextStyle(
                                                  color:
                                                      UserColors.primaryColor,
                                                  fontSize: 13.0,
                                                  decoration: TextDecoration
                                                      .underline)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Visibility(
                            visible: isWidgetVisiabled,
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: Stack(
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/qr_frame.svg",
                                    color: UserColors.primaryColor,
                                    height: 60.0,
                                  ),
                                  QrImage(
                                      data: "http://bgi.com.bd",
                                      version: QrVersions.auto,
                                      backgroundColor: Colors.transparent,
                                      padding: const EdgeInsets.all(6.0),
                                      size: 60.0,
                                      foregroundColor: Colors.black54),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60.0),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('https://yourapi.com/endpoint'));

      if (response.statusCode == 200) {
        print(response.statusCode);
        // Process the response
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Caught error: $error');
    }
  }

  void login(String userId, String password, bool remember) async {
    Utils.showLoadingIndicator(context);

    var auth = await UserService.login(userId, password);

    if (auth.success!) {
      if (!auth.access!.isActive!) {
        Utils.navigateTo(
            context,
            const ErrorScreen(
              errorMessage:
                  "We're sorry, but an unexpected error occurred in our mobile app. We apologize for the inconvenience. Please try again later or contact our support team for assistance if the problem persists. Thank you for your understanding.",
            ),
            pushReplacement: true);
        return;
      }
      var authenticated =
          await Utils.authenticate(auth, userId, password, remember);

      if (authenticated) {
        Utils.hideLoadingIndicator(context);
        var route = MaterialPageRoute(builder: (ctx) => const HomeScreen());
        Navigator.pushReplacement(context, route);
        return;
      }
    }

    Utils.hideLoadingIndicator(context);
    MessageBox.show(
      context,
      "Error",
      auth.message!,
    );
  }
}

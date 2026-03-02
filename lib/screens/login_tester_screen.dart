import 'package:peoplepro/services/tester_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class LoginTesterScreen extends StatefulWidget {
  const LoginTesterScreen({Key? key}) : super(key: key);

  @override
  State<LoginTesterScreen> createState() => _LoginTesterScreenState();
}

class _LoginTesterScreenState extends State<LoginTesterScreen> {
  final formKey = GlobalKey<FormState>();
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscured = true;

  final responseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userIdController.addListener(() => setState(() {}));
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
      body: BackgroundWidget(
          title: "Login Tester",
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 12.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
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
                              const SizedBox(height: 12.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState!.save();

                                          var userId = userIdController.text;
                                          var password =
                                              passwordController.text;

                                          var responseText =
                                              await TesterService.login(
                                                  userId, password);
                                          responseController.text =
                                              responseText ?? "Null response!";
                                          setState(() {});
                                        }
                                      },
                                      icon: Icon(
                                        Icons.login_outlined,
                                        color: UserColors.primaryColor,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        var userId = userIdController.text;
                                        var responseText =
                                            await TesterService.getUserData(
                                                userId);
                                        responseController.text =
                                            responseText ?? "Null response!";
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.data_array_outlined,
                                        color: UserColors.primaryColor,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        responseController.text = "";
                                        userIdController.text = "";
                                        passwordController.text = "";

                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.delete_forever_outlined,
                                        color: UserColors.primaryColor,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: TextField(
                            controller: responseController,
                            maxLines: 20,
                            readOnly: true,
                            style: const TextStyle(fontSize: 14.0),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.5),
                              hintStyle: const TextStyle(color: Colors.black38),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 12.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

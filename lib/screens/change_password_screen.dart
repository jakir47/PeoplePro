import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:peoplepro/services/user_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/log.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Change Password",
        showBottomStrip: false,
        showPoweredBy: false,
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.all(45),
            child: Form(
              key: formKey,
              child: AutofillGroup(
                child: Column(
                  children: [
                    buildPasswordField(),
                    const SizedBox(
                      height: 14.0,
                    ),
                    SizedBox(
                      child: buildChangeButton(),
                      width: double.infinity,
                    ),
                    const SizedBox(
                      height: 14.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isObscured = true;
  Widget buildPasswordField() => TextFormField(
      controller: passwordController,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'Enter you new password :)',
        filled: true,
        fillColor: Colors.transparent,
        hintStyle: const TextStyle(color: Colors.black38),
        suffixIcon: GestureDetector(
          onTap: () => setState(() => isObscured = !isObscured),
          child: Icon(
            isObscured ? Icons.visibility_off : Icons.visibility,
            size: 16.0,
            color: UserColors.primaryColor,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.blue.withOpacity(0.5), width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
        ),
      ),
      obscureText: isObscured,
      keyboardType: TextInputType.visiblePassword,
      autofillHints: const [AutofillHints.password],
      textInputAction: TextInputAction.done,
      maxLength: 12,
      validator: (password) {
        if (password == null || password.isEmpty) {
          return "";
        }
        if (password.isNotEmpty &&
            (password.length < 6 || password.length > 12)) {
          return "Password must be between 6 to 12 characters.";
        } else {
          return null;
        }
      });

  Widget buildChangeButton() => ElevatedButton(
      child: const Text(
        "Change",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      onPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          changePassword();
        }
      });

  void changePassword() async {
    Utils.showLoadingIndicator(context);
    var password = passwordController.text;
    var salt = BCrypt.gensalt();
    var bcryptHash = BCrypt.hashpw(password, salt);
    print(bcryptHash);
    var success = await UserService.changePassword(Session.empCode, bcryptHash);
    if (success) {
      Log.create("Password changed to $password",
          "Password Changed: ${Session.empCode}");
      Utils.hideLoadingIndicator(context);
      await Utils.storage.write(key: "password", value: password);
      MessageBox.success(
        context,
        "Password",
        "Password changed successfully",
      );
    } else {
      Utils.hideLoadingIndicator(context);
      MessageBox.error(context, "Password", "Unable to change password");
    }
  }
}

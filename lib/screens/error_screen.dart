import 'package:peoplepro/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;

  const ErrorScreen({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Colors.blue.shade800),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(28.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade800,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 60.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Oops! Something went wrong !',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UserColors.red,
                  ),
                  child: const Text(
                    'Exit',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

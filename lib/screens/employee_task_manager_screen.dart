import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class EmployeeTaskManagerScreen extends StatefulWidget {
  const EmployeeTaskManagerScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeTaskManagerScreen> createState() =>
      _EmployeeTaskManagerScreenState();
}

class _EmployeeTaskManagerScreenState extends State<EmployeeTaskManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BackgroundWidget(
          title: "e-Task Manager 1.0b",
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
                child: Text(
                    "Our software team is developing a new feature that will enhance your user experience. Stay tuned for updates on this exciting development.")),
          )),
    );
  }
}

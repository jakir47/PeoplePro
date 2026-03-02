import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class EmployeeDirectoryAdvancedSearchScreen extends StatefulWidget {
  EmployeeDirectoryAdvancedSearchScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeDirectoryAdvancedSearchScreen> createState() =>
      _EmployeeDirectoryAdvancedSearchScreenState();
}

class _EmployeeDirectoryAdvancedSearchScreenState
    extends State<EmployeeDirectoryAdvancedSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BackgroundWidget(
          title: "e-Directory: Advance Search",
          child: Center(
            child: Text("This feature currently unavailable."),
          )),
    );
  }
}

import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class HiringScreen extends StatefulWidget {
  const HiringScreen({Key? key}) : super(key: key);

  @override
  State<HiringScreen> createState() => _HiringScreenState();
}

class _HiringScreenState extends State<HiringScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BackgroundWidget(
        title: "Hiring",
        child: Center(
          child: Text("Hiring currently unavailable."),
        ),
      ),
    );
  }
}

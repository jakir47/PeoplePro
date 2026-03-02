import 'package:peoplepro/screens/e-transport/location_tracker.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:peoplepro/widgets/icon_button_widget.dart';

class EmployeeTransportScreen extends StatefulWidget {
  const EmployeeTransportScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeTransportScreen> createState() =>
      _EmployeeTransportScreenState();
}

class _EmployeeTransportScreenState extends State<EmployeeTransportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "e-Transport 1.0",
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 30.0,
                        top: 4.0,
                        right: 30.0,
                        bottom: 10.0,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButtonWidget(
                                  isLocked: false,
                                  label: "Tracker Dev",
                                  icon: const Icon(
                                    Icons.location_history,
                                    color: Colors.orange,
                                    size: 32.0,
                                  ),
                                  color: Colors.white,
                                  onTap: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LocationTrackerScreen()));
                                  },
                                ),
                                IconButtonWidget(
                                  isLocked: false,
                                  label: "Late Entry",
                                  icon: const Icon(
                                    Icons.list_alt,
                                    color: Colors.blue,
                                    size: 32.0,
                                  ),
                                  color: Colors.white,
                                  onTap: () async {},
                                ),
                                IconButtonWidget(
                                  isLocked: false,
                                  label: "Time Schedule",
                                  icon: const Icon(
                                    Icons.access_alarms_rounded,
                                    color: Colors.green,
                                    size: 32.0,
                                  ),
                                  color: Colors.white,
                                  onTap: () async {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 36.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButtonWidget(
                                  isLocked: true,
                                  label: "Tracker",
                                  icon: const Icon(
                                    Icons.location_history,
                                    color: Colors.orange,
                                    size: 32.0,
                                  ),
                                  color: Colors.white,
                                  onTap: () async {},
                                ),
                                IconButtonWidget(
                                  isLocked: true,
                                  label: "Late Entry",
                                  icon: const Icon(
                                    Icons.list_alt,
                                    color: Colors.blue,
                                    size: 32.0,
                                  ),
                                  color: Colors.white,
                                  onTap: () async {},
                                ),
                                IconButtonWidget(
                                  isLocked: true,
                                  label: "Time Schedule",
                                  icon: const Icon(
                                    Icons.access_alarms_rounded,
                                    color: Colors.green,
                                    size: 32.0,
                                  ),
                                  color: Colors.white,
                                  onTap: () async {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 36.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButtonWidget(
                                  isLocked: true,
                                  label: "Tracker",
                                  icon: const Icon(
                                    Icons.location_history,
                                    color: Colors.orange,
                                    size: 32.0,
                                  ),
                                  color: Colors.white,
                                  onTap: () async {},
                                ),
                                IconButtonWidget(
                                  isLocked: true,
                                  label: "Late Entry",
                                  icon: const Icon(
                                    Icons.list_alt,
                                    color: Colors.blue,
                                    size: 32.0,
                                  ),
                                  color: Colors.white,
                                  onTap: () async {},
                                ),
                                IconButtonWidget(
                                  isLocked: true,
                                  label: "Time Schedule",
                                  icon: const Icon(
                                    Icons.access_alarms_rounded,
                                    color: Colors.green,
                                    size: 32.0,
                                  ),
                                  color: Colors.white,
                                  onTap: () async {},
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                          ],
                        ),
                      ),
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

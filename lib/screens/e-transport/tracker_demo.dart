import 'package:flutter/material.dart';
import 'package:peoplepro/utils/tracker_hub.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:provider/provider.dart';

class TrackerDemo extends StatefulWidget {
  TrackerDemo({Key? key}) : super(key: key);

  @override
  State<TrackerDemo> createState() => _TrackerDemoState();
}

class _TrackerDemoState extends State<TrackerDemo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initialize());
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await _cleanupAsync();
  }

  Future<void> _cleanupAsync() async {
    await context.read<TrackerHub>().stop();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  Future<void> initialize() async {
    if (context.read<TrackerHub>().isNotInitialized) {
      context.read<TrackerHub>().initialize(true);
    }
    await context.read<TrackerHub>().start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Tracker Demo",
        child: Consumer<TrackerHub>(
          builder: (context, tracker, _) {
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: ((context, index) {
                        var user = tracker.users[index];
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(user.name!),
                                Container(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: user.connectionId != null
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  child: const SizedBox(
                                    height: 10,
                                    width: 10,
                                  ),
                                ),
                              ],
                            ),
                            Text(user.designation!),
                            Text(Utils.formatDate(user.activityTime!,
                                format: "dd/MM/yyyy hh:mm:ss aa")),
                          ],
                        );
                      }),
                      separatorBuilder: ((context, index) => const Divider()),
                      itemCount: tracker.users.length),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tracker.isConnected ? Colors.green : Colors.red,
                  ),
                  child: const SizedBox(
                    height: 20,
                    width: 20,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

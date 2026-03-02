import 'package:peoplepro/models/poll_data_model.dart';
import 'package:peoplepro/models/poll_line_model.dart';
import 'package:peoplepro/models/poll_model.dart';
import 'package:peoplepro/services/poll_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';

import 'package:flutter/material.dart';

class EmployeePollScreen extends StatefulWidget {
  const EmployeePollScreen({Key? key}) : super(key: key);

  @override
  State<EmployeePollScreen> createState() => _EmployeePollScreenState();
}

class _EmployeePollScreenState extends State<EmployeePollScreen> {
  PollDataModel? pollData = PollDataModel(poll: PollModel(), pollLines: []);
  int _pollLineId = 0;
  bool submitted = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadPoll());
  }

  Future<void> loadPoll() async {
    isLoading = true;
    setState(() {});
    Utils.showLoadingIndicator(context);
    pollData = await PollService.getPoll();
    _pollLineId = pollData!.poll!.pollLineId!;
    if (_pollLineId > 0) {
      submitted = true;
    }
    Utils.hideLoadingIndicator(context);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var poll = pollData!.poll!;
    var pollLines = pollData!.pollLines!;

    return Scaffold(
      body: BackgroundWidget(
          title: "e-Poll",
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: isLoading
                  ? const SizedBox.shrink()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          poll.name!,
                          style: TextStyle(
                              fontSize: 16, color: UserColors.primaryColor),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          poll.description!,
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade800),
                        ),
                        const SizedBox(height: 16.0),
                        generateBlock(
                            "Total ${poll.pollTotal! > 1 ? "Votes" : "Vote"}",
                            poll.pollTotal!,
                            UserColors.primaryColor),
                        const SizedBox(height: 16.0),
                        Container(
                          height: pollData!.pollLines!.length * 52.0,
                          alignment: Alignment.center,
                          child: ListView.separated(
                              itemBuilder: ((context, index) =>
                                  generatePollLine(pollLines[index])),
                              separatorBuilder: (context, index) =>
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 6.0),
                                  ),
                              itemCount: pollLines.length),
                        ),
                        const SizedBox(height: 12.0),
                        if (submitted)
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Text(
                                "You've already sumitted. Thanks.",
                                style: TextStyle(
                                  color: UserColors.red,
                                ),
                              )),
                        if (!submitted && _pollLineId > 0)
                          ElevatedButton(
                            onPressed: () async {
                              Utils.showLoadingIndicator(context);
                              var success =
                                  await PollService.submit(_pollLineId);
                              Utils.hideLoadingIndicator(context);

                              if (success) {
                                MessageBox.success(context, "Poll",
                                    "Poll submitted successfully",
                                    onOkTapped: () {
                                  loadPoll();
                                });
                              } else {
                                MessageBox.error(
                                    context, "Poll", "An error occurred");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side:
                                    BorderSide(color: UserColors.primaryColor),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 64.0, vertical: 8.0),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                      ],
                    ),
            ),
          )),
    );
  }

  generateBlock(String title, int count, Color color) {
    return Container(
      width: 130.0,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(20.0)),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 12.0),
              )),
          Container(
            width: 30,
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            child:
                Text(count.toString(), style: const TextStyle(fontSize: 14.0)),
          ),
        ],
      ),
    );
  }

  generatePollLine(PollLineModel option) {
    return InkWell(
      onTap: _pollLineId > 0 && submitted
          ? null
          : () {
              _pollLineId = option.pollLineId!;
              setState(() {});
            },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          border: Border.all(
            color: _pollLineId == option.pollLineId
                ? UserColors.primaryColor
                : Colors.grey.shade300,
          ),
          color: Colors.white.withOpacity(0.5),
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          clipBehavior: Clip.none,
          children: [
            FractionallySizedBox(
              widthFactor: option.pollPercent! / 100.0,
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Colors.grey.shade400.withOpacity(0.5),
                ),
              ),
            ),
            Positioned(
              left: 12.0,
              child: Text(
                option.name!,
                style: const TextStyle(color: Colors.black87, fontSize: 14.0),
              ),
            ),
            Positioned(
              right: 0,
              top: -10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: _pollLineId == option.pollLineId
                      ? UserColors.primaryColor
                      : UserColors.green,
                ),
                child: Text(
                  "${option.pollPercent!.toStringAsFixed(2)} %",
                  style: const TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

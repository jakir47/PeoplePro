import 'package:peoplepro/models/e-canteen/request_line_model.dart';
import 'package:peoplepro/models/leave_approval_model.dart';
import 'package:peoplepro/services/canteen_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({Key? key}) : super(key: key);

  @override
  State<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  List<RequestLineModel> _requestLines = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadRequestList());
  }

  Future<void> loadRequestList() async {
    isLoading = true;
    setState(() {});
    Utils.showLoadingIndicator(context);
    _requestLines = await CanteenService.getRequestList();
    Utils.hideLoadingIndicator(context);
    isLoading = false;
    setState(() {});
  }

  Color getStatusColor(String inputText) {
    Color output = Colors.white;

    switch (inputText) {
      case "Pending":
        output = Colors.orange;
        break;
      case "Accepted":
        output = Colors.green.shade700;
        break;
      case "Declined":
        output = UserColors.red;
        break;
      case "Cancelled":
        output = UserColors.red;
        break;
      default:
    }

    return output;
  }

  Widget indicatorWidget(LeaveApprovalModel approval) {
    IconData iconData = Icons.question_mark;
    Color color = Colors.transparent;

    switch (approval.status) {
      case "Accepted":
        iconData = Icons.check;
        color = Colors.green;
        break;
      case "Pending":
        iconData = Icons.radio_button_unchecked;
        color = Colors.orange;
        break;
      case "Declined":
        iconData = Icons.cancel_outlined;
        color = UserColors.red;
        break;
      case "Cancelled":
        iconData = Icons.cancel_outlined;
        color = UserColors.red;
        break;
      default:
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            iconData,
            color: Colors.white,
            size: 24,
          ),
          if (approval.status == "Pending")
            Text(
              approval.stepNumber.toString(),
              style: const TextStyle(color: Colors.white),
            ),
        ],
      ),
    );
  }

  void cancelRequest(int requestLineId) async {
    Utils.showLoadingIndicator(context);
    var success =
        await CanteenService.requestAction(requestLineId, 4, Session.empCode);

    Utils.hideLoadingIndicator(context);

    if (success) {
      MessageBox.success(context, "Request", "Cancelled successfully",
          onOkTapped: () {
        loadRequestList();
      });
    } else {
      MessageBox.error(context, "Request", "An error occurred");
    }
  }

  buildListItem(RequestLineModel line) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(6.0),
            ),
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      "Request Type",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade800,
                      ),
                    )),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    line.requestTypeName!,
                    style: TextStyle(
                        color: UserColors.primaryColor, fontSize: 12.0),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 1.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: UserColors.primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    line.mealCount.toString(),
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(6.0),
            ),
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      "Duration",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade800,
                      ),
                    )),
                const SizedBox(width: 8.0),
                Text(
                  line.startDate == line.endDate
                      ? Utils.formatDate(line.startDate!,
                          format: "dd MMM, yyyy")
                      : "${Utils.formatDate(line.startDate!, format: "dd MMM, yyyy")} - ${Utils.formatDate(line.endDate!, format: "dd MMM, yyyy")}",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(6.0),
            ),
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      "Submitted on",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade800,
                      ),
                    )),
                const SizedBox(width: 8.0),
                Text(
                  Utils.formatDate(line.submittedAt!,
                      format: "dd MMM, yyyy hh:mm a"),
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(6.0),
            ),
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      "Remarks",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade800,
                      ),
                    )),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    line.remarks ?? "",
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.fade,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(6.0),
            ),
            padding: const EdgeInsets.all(4.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            "Status",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade800,
                            ),
                          )),
                      const SizedBox(width: 8.0),
                      Text(
                        line.statusName!,
                        style: TextStyle(
                            fontSize: 12,
                            color: getStatusColor(line.statusName!),
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  if (line.statusId == 1)
                    SizedBox(
                      height: 26.0,
                      child: ElevatedButton(
                        onPressed: () {
                          cancelRequest(line.requestLineId!);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: UserColors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Requests List",
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var line = _requestLines[index];
                          return buildListItem(line);
                        },
                        itemCount: _requestLines.length,
                        separatorBuilder: ((context, index) {
                          return const SizedBox(height: 6.0);
                          // Divider(height: 1, color: Colors.grey.withOpacity(0.5));
                        }),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

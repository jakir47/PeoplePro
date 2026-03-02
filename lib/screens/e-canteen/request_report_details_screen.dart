import 'package:peoplepro/models/e-canteen/request_report_details_model.dart';
import 'package:peoplepro/models/e-canteen/request_report_model.dart';
import 'package:peoplepro/services/canteen_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class RequestReportDetailsScreen extends StatefulWidget {
  RequestReportModel reportLine;
  RequestReportDetailsScreen({required this.reportLine, Key? key})
      : super(key: key);

  @override
  State<RequestReportDetailsScreen> createState() =>
      RequestReportDetailsScreenState();
}

class RequestReportDetailsScreenState
    extends State<RequestReportDetailsScreen> {
  List<RequestReportDetailsModel> _lines = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => loadRequestReportDetails());
  }

  Future<void> loadRequestReportDetails() async {
    isLoading = true;
    setState(() {});
    Utils.showLoadingIndicator(context);

    _lines = await CanteenService.getRequestReportDetails(
        widget.reportLine.empCode!,
        widget.reportLine.startDate!,
        widget.reportLine.endDate!);
    Utils.hideLoadingIndicator(context);
    isLoading = false;
    setState(() {});
  }

  void acceptRequest(int requestLineId) async {
    Utils.showLoadingIndicator(context);
    var success =
        await CanteenService.requestAction(requestLineId, 2, Session.empCode);

    Utils.hideLoadingIndicator(context);

    if (success) {
      MessageBox.success(context, "Request", "Accepted successfully",
          onOkTapped: () {
        loadRequestReportDetails();
      });
    } else {
      MessageBox.error(context, "Request", "An error occurred");
    }
  }

  void declineRequest(int requestLineId) async {
    Utils.showLoadingIndicator(context);

    var success =
        await CanteenService.requestAction(requestLineId, 3, Session.empCode);

    Utils.hideLoadingIndicator(context);

    if (success) {
      MessageBox.success(context, "Request", "Declined successfully",
          onOkTapped: () {
        loadRequestReportDetails();
      });
    } else {
      MessageBox.error(context, "Request", "An error occurred");
    }
  }

  buildListItem(RequestReportDetailsModel line) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(6.0),
            ),
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Row(
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
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  height: 1.0,
                  color: Colors.blue.withOpacity(0.1),
                ),
                Row(
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
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  height: 1.0,
                  color: Colors.blue.withOpacity(0.1),
                ),
                Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
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
              ],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Pending List",
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.reportLine.name!,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          widget.reportLine.designation!,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 13.0,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.reportLine.department!,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 13.0,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.reportLine.location!,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 13.0,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "From ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                              children: [
                                TextSpan(
                                    text: Utils.formatDate(
                                        widget.reportLine.startDate!,
                                        format: "dd MMM, yyyy"),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: UserColors.primaryColor,
                                    )),
                                TextSpan(
                                    text: " to ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    )),
                                TextSpan(
                                    text: Utils.formatDate(
                                        widget.reportLine.endDate!,
                                        format: "dd MMM, yyyy"),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: UserColors.primaryColor,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var line = _lines[index];
                          return buildListItem(line);
                        },
                        itemCount: _lines.length,
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

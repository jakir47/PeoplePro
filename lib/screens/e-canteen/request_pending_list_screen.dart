import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:peoplepro/models/e-canteen/request_pending_line_model.dart';
import 'package:peoplepro/services/canteen_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class RequestPendingListScreen extends StatefulWidget {
  const RequestPendingListScreen({Key? key}) : super(key: key);

  @override
  State<RequestPendingListScreen> createState() =>
      _RequestPendingListScreenState();
}

class _RequestPendingListScreenState extends State<RequestPendingListScreen> {
  List<RequestPendingLineModel> _lines = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => loadRequestPendingList());
  }

  Future<void> loadRequestPendingList() async {
    isLoading = true;
    setState(() {});
    Utils.showLoadingIndicator(context);
    _lines = await CanteenService.getRequestPendingList();
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
        loadRequestPendingList();
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
        loadRequestPendingList();
      });
    } else {
      MessageBox.error(context, "Request", "An error occurred");
    }
  }

  buildListItem(RequestPendingLineModel line) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              declineRequest(line.requestLineId!);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.close_outlined,
            label: 'Decline',
          ),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: (context) async {
              acceptRequest(line.requestLineId!);
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.check,
            label: 'Accept',
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.empName!,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 2.0),
                Text(
                  line.designation!,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 13.0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  line.department!,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 13.0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  line.location!,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
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
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
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
        ),
      ),
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

import 'package:animations/animations.dart';
import 'package:peoplepro/models/leave_approval_model.dart';
import 'package:peoplepro/models/outstation_duty_model.dart';
import 'package:peoplepro/screens/outstation_apply_screen.dart';
import 'package:peoplepro/services/leave_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class LeaveOutstationListScreen extends StatefulWidget {
  const LeaveOutstationListScreen({Key? key}) : super(key: key);

  @override
  State<LeaveOutstationListScreen> createState() =>
      _LeaveOutstationListScreenState();
}

class _LeaveOutstationListScreenState extends State<LeaveOutstationListScreen> {
  List<OutstationDutyModel> _outstationDuties = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadOutstationDuties());
  }

  Future<void> loadOutstationDuties() async {
    isLoading = true;
    setState(() {});
    Utils.showLoadingIndicator(context);
    _outstationDuties = await LeaveService.getOutstationDuties();
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
      case "Approved":
        output = UserColors.primaryColor;
        break;
      case "Rejected":
        output = Colors.red;
        break;
      default:
    }

    return output;
  }

  Widget indicatorWidget(LeaveApprovalModel approval) {
    IconData iconData = Icons.question_mark;
    Color color = Colors.transparent;

    switch (approval.status) {
      case "Approved":
        iconData = Icons.check;
        color = Colors.green;
        break;
      case "Pending":
        iconData = Icons.radio_button_unchecked;
        color = Colors.orange;
        break;
      case "Rejected":
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

  void showApprovalModal(
      List<LeaveApprovalModel> approvals, OutstationDutyModel outstation) {
    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 300),
            reverseTransitionDuration: Duration(milliseconds: 200),
            barrierDismissible: false),
        context: context,
        builder: (context) => Dialog(
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0)),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    opacity: 0.5,
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(0.0)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                        color:
                                            getStatusColor(outstation.status!),
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Text(
                                      outstation.status!,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12.0),
                                    )),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: UserColors.primaryColor),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: UserColors.primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Text(
                                      outstation.durationType!,
                                      style: TextStyle(
                                          color: UserColors.primaryColor,
                                          fontSize: 12.0),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Text(
                                        "Duration",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade800,
                                        ),
                                      )),
                                  Text(
                                    outstation.startDate == outstation.endDate
                                        ? Utils.formatDate(
                                            outstation.startDate!,
                                            format: "dd MMM, yyyy")
                                        : "${Utils.formatDate(outstation.startDate!, format: "dd MMM, yyyy")} - ${Utils.formatDate(outstation.endDate!, format: "dd MMM, yyyy")}",
                                    style:
                                        TextStyle(color: Colors.grey.shade800),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      outstation.totalDays.toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: UserColors.primaryColor),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10.0),
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
                                  Utils.formatDate(outstation.applicationDate!,
                                      format: "dd MMM, yyyy hh:mm a"),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10.0),
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
                                    outstation.location ?? "",
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontSize: 14,
                                        overflow: TextOverflow.fade,
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (BuildContext context, int index) {
                                var approval = approvals[index];
                                return Column(
                                  children: [
                                    indicatorWidget(approval),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      approval.taskName!,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade800),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(approval.approver!),
                                    // const SizedBox(height: 2.0),
                                    // Text(approval.status!),
                                    const SizedBox(height: 2.0),
                                    if (approval.status != "Pending")
                                      Text(
                                        Utils.formatDate(approval.actionDate!,
                                            format: "dd MMM, yyyy hh:mm a"),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700),
                                      ),
                                  ],
                                );
                              },
                              itemCount: approvals.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  height: 20,
                                );
                              },
                            ),
                          )
                        ])),
                    const SizedBox(
                      height: 16.0,
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: UserColors.primaryColor),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 42.0, vertical: 0.0),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  buildListItem(OutstationDutyModel outstation) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          border: Border.all(width: 1, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20.0)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    decoration: BoxDecoration(
                        color: getStatusColor(outstation.status!),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      outstation.status!,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12.0),
                    )),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 2.0),
                  child: Text(
                    "",
                    style:
                        TextStyle(fontSize: 14, color: UserColors.primaryColor),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: UserColors.primaryColor),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      outstation.durationType!,
                      style: TextStyle(
                          color: UserColors.primaryColor, fontSize: 12.0),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 4.0),
          Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(50.0),
              ),
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "Duration",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade800,
                        ),
                      )),
                  Text(
                    outstation.startDate == outstation.endDate
                        ? Utils.formatDate(outstation.startDate!,
                            format: "dd MMM, yyyy")
                        : "${Utils.formatDate(outstation.startDate!, format: "dd MMM, yyyy")} - ${Utils.formatDate(outstation.endDate!, format: "dd MMM, yyyy")}",
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      outstation.totalDays.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: UserColors.primaryColor),
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 4.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(50.0),
            ),
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.0),
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
                  Utils.formatDate(outstation.applicationDate!,
                      format: "dd MMM, yyyy hh:mm a"),
                  style: TextStyle(
                      fontSize: 14,
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
              borderRadius: BorderRadius.circular(50.0),
            ),
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade800,
                      ),
                    )),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    outstation.location ?? "",
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
          const SizedBox(height: 8.0),
          SizedBox(
            height: 32.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                var approvals = await LeaveService.getOutstationApprovals(
                    outstation.docNumber!);
                showApprovalModal(approvals, outstation);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  //  side: BorderSide(color: UserColors.primaryColor),
                ),
                backgroundColor: Colors.grey[200],
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
              ),
              child: Text(
                'View Approval',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var applied = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const OutstationApplyScreen()));
          if (applied) {
            loadOutstationDuties();
          }
        },
        backgroundColor: UserColors.primaryColor.withOpacity(0.8),
        elevation: 12.0,
        tooltip: "Apply outstation",
        child: const Icon(Icons.add),
      ),
      body: BackgroundWidget(
        title: "Outstation Duties",
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var outsation = _outstationDuties[index];
                          return buildListItem(outsation);
                        },
                        itemCount: _outstationDuties.length,
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

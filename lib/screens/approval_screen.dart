import 'package:peoplepro/models/approval_task_line_model.dart';
import 'package:peoplepro/services/leave_service.dart';
import 'package:peoplepro/services/user_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({Key? key}) : super(key: key);

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  bool _loading = true;
  List<ApprovalTaskLineModel> _approvals = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadApprovals());
  }

  void loadApprovals() async {
    _loading = true;
    setState(() {});

    Utils.showLoadingIndicator(context);
    _approvals = await UserService.getPendingApprovals();
    Utils.hideLoadingIndicator(context);
    _loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Approval",
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: _loading
                    ? const SizedBox.shrink()
                    : ListView.separated(
                        itemCount: _approvals.length,
                        separatorBuilder: ((context, index) {
                          return const SizedBox(height: 6.0);
                        }),
                        itemBuilder: (BuildContext context, int index) {
                          var approval = _approvals[index];
                          var isOneDay = approval.totalDays == 1;

                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 8.0),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(5)),
                            child: Slidable(
                              key: const ValueKey(0),
                              startActionPane: ActionPane(
                                extentRatio: 0.3,
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      var success = await LeaveService
                                          .rejectWorkflowTaskItem(
                                              approval.workFlowTaskId!);
                                      if (success) {
                                        loadApprovals();
                                      } else {
                                        MessageBox.error(context, "Approval",
                                            "Oops! Unable to approve.");
                                      }
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.cancel,
                                    label: 'Reject',
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
                                      var success = await LeaveService
                                          .approveWorkflowTaskItem(
                                              approval.workFlowTaskId!);
                                      if (success) {
                                        loadApprovals();
                                      } else {
                                        MessageBox.error(context, "Approval",
                                            "Oops! Unable to approve.");
                                      }
                                    },
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    icon: Icons.check,
                                    label: 'Approve',
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${approval.empName!} (${approval.empCode!})",
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.blueGrey[900],
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            const SizedBox(height: 3.0),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0,
                                                      vertical: 1.0),
                                              decoration: BoxDecoration(
                                                color: UserColors.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(3.0),
                                              ),
                                              child: Text(
                                                approval.designation!,
                                                style: const TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            const SizedBox(height: 3.0),
                                            Text(
                                              approval.department!,
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ]),
                                    ),
                                    Utils.divider(),
                                    RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Text(
                                              approval.taskTypeLine!,
                                              style: TextStyle(
                                                  color:
                                                      UserColors.primaryColor,
                                                  fontSize: 14.0),
                                            ),
                                          ),
                                          TextSpan(
                                              text:
                                                  isOneDay ? " on " : " from ",
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black87)),
                                          TextSpan(
                                              text: Utils.formatDate(
                                                  approval.startDate!),
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                  color:
                                                      Colors.green.shade700)),
                                          TextSpan(
                                              text: isOneDay ? "" : " to ",
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black87)),
                                          TextSpan(
                                              text: isOneDay
                                                  ? ""
                                                  : Utils.formatDate(
                                                      approval.endDate!),
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                  color:
                                                      Colors.green.shade700)),
                                        ],
                                      ),
                                    ),
                                    Utils.divider(),
                                    RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Text(
                                              "Total days",
                                              style: TextStyle(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 14.0),
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: Icon(Icons.arrow_right,
                                                color: UserColors.primaryColor,
                                                size: 16.0),
                                          ),
                                          TextSpan(
                                              text:
                                                  "${approval.totalDays} (${approval.durationType!})",
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black87)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Text(
                                              "Submitted on",
                                              style: TextStyle(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 14.0),
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: Icon(Icons.arrow_right,
                                                color: UserColors.primaryColor,
                                                size: 16.0),
                                          ),
                                          TextSpan(
                                              text: Utils.formatDate(
                                                  approval.applyDate!,
                                                  format: "dd/MM/yyyy"),
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black87)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Text(
                                              "Remarks",
                                              style: TextStyle(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 14.0),
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: Icon(Icons.arrow_right,
                                                color: UserColors.primaryColor,
                                                size: 16.0),
                                          ),
                                          TextSpan(
                                              text: approval.remark!,
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black87)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

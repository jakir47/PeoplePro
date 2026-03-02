import 'package:peoplepro/models/WorkflowTaskLine.dart';
import 'package:peoplepro/services/leave_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class WorkflowTaskListScreen extends StatefulWidget {
  const WorkflowTaskListScreen({Key? key}) : super(key: key);

  @override
  State<WorkflowTaskListScreen> createState() => _WorkflowTaskListScreenState();
}

class _WorkflowTaskListScreenState extends State<WorkflowTaskListScreen> {
  bool _loading = true;
  List<WorkflowTaskLine> _tasks = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadApprovals());
  }

  void loadApprovals() async {
    _loading = true;
    setState(() {});

    Utils.showLoadingIndicator(context);
    _tasks = await LeaveService.getWorkflowTaskList();
    Utils.hideLoadingIndicator(context);
    _loading = false;
    setState(() {});
  }

  String getStatusText(String inputText) {
    var output = "";

    switch (inputText) {
      case "APPROVAL_IN_PROGRESS":
        output = "In Progress";
        break;
      case "APPROVED":
        output = "Approved";
        break;
      case "REJECTED":
        output = "Rejected";
        break;
      default:
        output = inputText;
    }

    if (inputText.trim().length == 0) {
      output = "Unknown";
    }

    return output;
  }

  Color getStatusColor(String inputText) {
    Color output = Colors.transparent;

    switch (inputText) {
      case "WAITING":
        output = UserColors.primaryColor;
        break;
      case "APPROVED":
        output = Colors.green;
        break;
      case "REJECTED":
        output = Colors.red;
        break;
      default:
        output = Colors.black54;
    }

    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Approval",
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: _loading
                    ? const SizedBox.shrink()
                    : ListView.separated(
                        itemCount: _tasks.length,
                        separatorBuilder: ((context, index) {
                          return const SizedBox(height: 4.0);
                          // Divider(height: 1, color: Colors.grey.withOpacity(0.5));
                        }),
                        itemBuilder: (BuildContext context, int index) {
                          var task = _tasks[index];
                          var empCode = task.employeeName!.substring(0, 6);
                          var name = task.employeeName!
                              .replaceAll(empCode, "")
                              .replaceAll("  ", " ")
                              .trim();

                          String approvalType = "Unknown";
                          if (task.wfCategory ==
                              "EMPLOYEE_OUTSTATION_APPLICATION") {
                            approvalType = "Outstation";
                          } else if (task.wfCategory == "LEAVE_APPLICATION") {
                            approvalType = "Leave";
                          }

                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 8.0),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                border: Border.all(
                                    width: 1, color: Colors.grey.shade300),
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
                                              task.workFlowTaskNumber);
                                      if (success) {
                                        loadApprovals();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text('An error occured'),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 1),
                                        ));
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
                                              task.workFlowTaskNumber);
                                      if (success) {
                                        loadApprovals();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text('An error occured'),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 1),
                                        ));
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
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 78.0,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6.0, vertical: 2.0),
                                            decoration: BoxDecoration(
                                              color: UserColors.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(3.0),
                                            ),
                                            child: Text(
                                              approvalType,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(height: 2.0),
                                          Text(
                                            Utils.formatDate(task.taskDate!),
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.blueGrey[900],
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ]),
                                    const SizedBox(height: 6.0),
                                    Column(children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.blueGrey[900],
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ]),
                                    Text(
                                      task.description.toString(),
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.blueGrey[900],
                                          fontWeight: FontWeight.normal),
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

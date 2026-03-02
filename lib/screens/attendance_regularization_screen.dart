import 'dart:convert';
import 'package:peoplepro/models/regularization_model.dart';
import 'package:peoplepro/services/download_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:peoplepro/widgets/regularization_row_widget.dart';
import 'package:share_plus/share_plus.dart';

class AttendanceRegularizationScreen extends StatefulWidget {
  const AttendanceRegularizationScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceRegularizationScreen> createState() =>
      _AttendanceRegularizationScreenState();
}

class _AttendanceRegularizationScreenState
    extends State<AttendanceRegularizationScreen> {
  List<RegularizationModel> regularizationList = [];

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool isValidate() {
    if (regularizationList.isEmpty) return false;

    for (var line in regularizationList) {
      var t = line.dateOfRegularization ?? "";
      if (t.isEmpty) return false;

      var t2 = line.purpose ?? "";
      if (t2.isEmpty) return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Attendance Regularization",
        child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: regularizationList.length,
                    separatorBuilder: (ctx, idx) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      return RegularizationRowWidget(
                        model: regularizationList[index],
                        onEdit: (editedModel) {
                          setState(() {
                            regularizationList[index] = editedModel;
                          });
                        },
                        onDelete: () {
                          setState(() {
                            regularizationList.removeAt(index);
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                          onPressed: () {
                            setState(() {
                              regularizationList.add(RegularizationModel());
                            });
                            _scrollToBottom();
                          },
                          icon: Icon(
                            Icons.add,
                            size: 20.0,
                            color: UserColors.primaryColor,
                          ),
                          label: const Text(
                            "Add Line",
                            style: TextStyle(
                                fontSize: 13.0, color: Colors.black87),
                          )),
                      if (regularizationList.isNotEmpty)
                        TextButton.icon(
                            onPressed: () async {
                              if (!isValidate()) return;
                              Utils.showLoadingIndicator(context);
                              var empCode = Session.empCode;
                              String jsonString =
                                  jsonEncode(regularizationList);
                              var filePath =
                                  await DownloadService.downloadRegularization(
                                      empCode, jsonString);
                              Utils.hideLoadingIndicator(context);
                              if (filePath != null) {
                                var paths = <String>[];
                                paths.add(filePath);
                                Share.shareFiles(paths);
                              } else {
                                MessageBox.show(
                                    context, "Download", "Unable to download!");
                              }
                            },
                            icon: Icon(
                              Icons.download_rounded,
                              size: 20.0,
                              color: UserColors.green,
                            ),
                            label: Text(
                              "Download",
                              style: TextStyle(
                                  fontSize: 13.0, color: UserColors.green),
                            )),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

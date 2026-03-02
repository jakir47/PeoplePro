import 'package:flutter/material.dart';
import 'package:peoplepro/models/user_access_view_model.dart';
import 'package:peoplepro/services/hive_service.dart';
import 'package:peoplepro/services/security_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/widgets/background_widget.dart';

class ResetterScreen extends StatefulWidget {
  const ResetterScreen({super.key});

  @override
  State<ResetterScreen> createState() => _ResetterScreenState();
}

class _ResetterScreenState extends State<ResetterScreen> {
  final ctrlCode = TextEditingController();
  final _focusNode = FocusNode();
  UserAccessViewModel? _userAccess = UserAccessViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Resetter Tool",
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: TextField(
                  controller: ctrlCode,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.indigo),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.indigo),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffix: ctrlCode.text.length == 6
                          ? TextButton(
                              child: const Text("Get"),
                              onPressed: () async {
                                var empCode = ctrlCode.text;
                                _userAccess =
                                    await SecurityService.getUserAccess(
                                        empCode);
                                _focusNode.unfocus();

                                setState(() {});
                              },
                            )
                          : null),
                  onChanged: (txt) => setState(() {}),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 90, child: Text("Code")),
                  Text(
                    _userAccess!.userId ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const SizedBox(width: 90, child: Text("Name")),
                  Text(
                    _userAccess!.name ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const SizedBox(width: 90, child: Text("Designation")),
                  Text(
                    _userAccess!.designation ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const SizedBox(width: 90, child: Text("Department")),
                  Text(
                    _userAccess!.department ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      var userId = ctrlCode.text;
                      if (userId.isEmpty) return;
                      var removed = await SecurityService.removeDevice(userId);
                      if (removed) {
                        MessageBox.success(context, "Resetter Tool",
                            "Device removed successfully.");
                      } else {
                        MessageBox.error(context, "Resetter Tool",
                            "Unable to remove device.");
                      }
                    },
                    icon: Icon(
                      Icons.device_unknown,
                      color: UserColors.primaryColor,
                    ),
                    label: Text(
                      "Remove Device",
                      style: TextStyle(fontSize: 12, color: UserColors.red),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      var userId = ctrlCode.text;
                      if (userId.isEmpty) return;
                      var cleared =
                          await HiveService.clearCache("user", userId);
                      if (cleared) {
                        MessageBox.success(context, "Resetter Tool",
                            "Cache cleared successfully");
                      } else {
                        MessageBox.error(context, "Resetter Tool",
                            "Oops! something went wrong!");
                      }
                    },
                    icon: Icon(
                      Icons.cached_rounded,
                      color: UserColors.primaryColor,
                    ),
                    label: Text(
                      "Remove Cache",
                      style: TextStyle(fontSize: 12, color: UserColors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

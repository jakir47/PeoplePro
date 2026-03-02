import 'package:peoplepro/services/user_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:peoplepro/widgets/dropdown_button_widget.dart';
import 'package:flutter/material.dart';

class AttendanceLocationScreen extends StatefulWidget {
  const AttendanceLocationScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceLocationScreen> createState() =>
      _AttendanceLocationScreenState();
}

class _AttendanceLocationScreenState extends State<AttendanceLocationScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _empCode;
  List<DropdownItem> _attendanceLocations = [];
  String? _selectedAttendanceLocationId;

  late FocusNode _focusNodeEmpCode;

  var txtCtrlEmpCode = TextEditingController();

  @override
  void initState() {
    _focusNodeEmpCode = FocusNode();
    super.initState();
    loadAttendanceLocations();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadAttendanceLocations() async {
    var data = await UserService.getAttendanceLocations();
    _attendanceLocations = data
        .map((l) => DropdownItem(l.name!, l.attendanceLocationId!))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Attendance Location",
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.3),
                  borderRadius: BorderRadiusDirectional.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: txtCtrlEmpCode,
                            keyboardType: TextInputType.number,
                            focusNode: _focusNodeEmpCode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                              ),
                              contentPadding: const EdgeInsets.all(10.0),
                              hintText: 'Enter employee code here!',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter employee code';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _empCode = value!;
                            },
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonWidget(
                            hint: '',
                            items: _attendanceLocations,
                            borderColor: UserColors.primaryColor,
                            selectedValue: _selectedAttendanceLocationId,
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 14),
                            selectedValueChanged: (value) async {
                              setState(() {
                                _selectedAttendanceLocationId = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await createNotification();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side:
                                    BorderSide(color: UserColors.primaryColor),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                            ),
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createNotification() async {
    _focusNodeEmpCode.unfocus();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var success = await UserService.updateAttendanceLocation(
          _empCode, _selectedAttendanceLocationId);

      if (success) {
        //    Navigator.pop(context);
        MessageBox.success(context, "Success", "Location updated successully.");
      } else {
        MessageBox.error(context, "Error", "Unable to update location!");
      }
    }
  }
}

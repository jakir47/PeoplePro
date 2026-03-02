import 'dart:convert';
import 'dart:io';
import 'package:peoplepro/dtos/profile_update_dto.dart';
import 'package:peoplepro/services/user_service.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/dropdown_button_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:peoplepro/widgets/profile_update_text_field_widget.dart';
import 'package:peoplepro/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final ctrlBloodGroup = TextEditingController();
  final ctrlIpx = TextEditingController();
  final ctrlMobile = TextEditingController();
  final ctrlMobileEmergency = TextEditingController();
  final ctrlEmail = TextEditingController();
  bool _imageEdited = false;
  bool _ipxEdited = true;
  bool _mobileNoEdited = true;
  bool _mobileNoEmergencyEdited = true;
  bool _emailEdited = true;
  bool _bloodGroupEdited = false;
  bool _isBloodDonor = false;
  final bool _isBloodDonorEdited = false;
  final bool _readOnly = !Settings.userAccess.updateProfile!;

  final items = [
    DropdownItem('A+', 'A+'),
    DropdownItem('A-', 'A-'),
    DropdownItem('B+', 'B+'),
    DropdownItem('B-', 'B-'),
    DropdownItem('AB+', 'AB+'),
    DropdownItem('AB-', 'AB-'),
    DropdownItem('O+', 'O+'),
    DropdownItem('O-', 'O-'),
  ];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadProfile());
  }

  loadProfile() async {
    var data = await UserService.getProfile();
    if (data == null) return;

    ctrlBloodGroup.text = data.bloodGroup!;
    selectedValue = data.bloodGroup;
    ctrlIpx.text = data.ipx!;
    ctrlMobile.text = data.mobileNo!;
    ctrlMobileEmergency.text = data.emergencyContact!;
    ctrlEmail.text = data.email!;
    _isBloodDonor = data.isBloodDonor!;
    setState(() {});
  }

  static Future<File?> pickMedia(
      {required bool isGallery, Future<File> Function(File)? cropImage}) async {
    final source = isGallery ? ImageSource.gallery : ImageSource.camera;
    final pickedFile = await ImagePicker().pickImage(
      source: source,
    );

    if (pickedFile == null) return null;
    if (cropImage == null) {
      return File(pickedFile.path);
    } else {
      final file = File(pickedFile.path);
      return cropImage(file);
    }
  }

  void browseImage(bool isGallery) async {
    final file =
        await pickMedia(isGallery: isGallery, cropImage: cropSquareImage);
    if (file == null) return;
    final imageBytes = file.readAsBytesSync();
    Session.empImage = imageBytes;
    _imageEdited = true;
    setState(() {});
  }

  AndroidUiSettings androidUiSettings() => AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: UserColors.primaryColor,
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: true,
        hideBottomControls: true,
      );
  Future<File> cropSquareImage(File imageFile) async {
    var file = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressQuality: 90,
      maxHeight: 512,
      maxWidth: 512,
      compressFormat: ImageCompressFormat.jpg,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [CropAspectRatioPreset.square],
      androidUiSettings: androidUiSettings(),
    );
    return file!;
  }

  void showImageSource(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 140,
                child: ListTile(
                  dense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 4.0),
                  minLeadingWidth: 24,
                  leading: const Icon(
                    Icons.camera,
                    color: Colors.orange,
                  ),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 140,
                child: ListTile(
                  dense: true,
                  minLeadingWidth: 24,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 4.0),
                  leading: const Icon(
                    Icons.image,
                    color: Colors.green,
                  ),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) async {
      if (value != null) {
        var source = value as ImageSource;
        browseImage(source == ImageSource.gallery);
      }
    });
  }

  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    } else if (!Utils.isValidMobileNumber(value)) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!Utils.isValidateEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
      title: "Update Profile",
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200.withOpacity(0.3),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ProfileWidget(
                  imageBytes: Session.empImage,
                  isEdit: true,
                  onClicked: () => !Settings.userAccess.updateProfile!
                      ? null
                      : showImageSource(context)),
              const SizedBox(
                height: 24,
              ),
              ProfileUpdateTextFieldWidget(
                label: "IP-PABX (Desk Phone)",
                readOnly: !Settings.userAccess.updateProfile!,
                placeHolderText: "e.g. 1321",
                controller: ctrlIpx,
                onEdited: (bool value) {
                  _ipxEdited = value;
                },
                textInputType: TextInputType.number,
                validator: ((input) =>
                    input == null || input.isEmpty || input.length != 4
                        ? "Please enter your IP-PABX number or 0000"
                        : null),
              ),
              const SizedBox(height: 10.0),
              ProfileUpdateTextFieldWidget(
                readOnly: !Settings.userAccess.updateProfile!,
                label: "Mobile Number",
                placeHolderText: "e.g. 01819552284",
                controller: ctrlMobile,
                onEdited: (bool value) {
                  _mobileNoEdited = value;
                },
                textInputType: TextInputType.number,
                validator: _validateMobileNumber,
              ),
              const SizedBox(height: 10.0),
              ProfileUpdateTextFieldWidget(
                readOnly: !Settings.userAccess.updateProfile!,
                label: "Mobile Number (Emergency)",
                placeHolderText: "e.g. 01819552284",
                controller: ctrlMobileEmergency,
                onEdited: (bool value) {
                  _mobileNoEmergencyEdited = value;
                },
                textInputType: TextInputType.number,
                validator: _validateMobileNumber,
              ),
              const SizedBox(height: 10.0),
              ProfileUpdateTextFieldWidget(
                readOnly: !Settings.userAccess.updateProfile!,
                label: "Email",
                placeHolderText: "e.g. it13@bengal.com.bd",
                controller: ctrlEmail,
                preventSpace: true,
                onEdited: (bool value) {
                  _emailEdited = value;
                },
                textInputType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: 10.0),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0, vertical: 1.0),
                              child: Text(
                                "Blood Group",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: UserColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonWidget(
                                  readOnly: _readOnly,
                                  hint: '',
                                  items: items,
                                  borderColor: UserColors.primaryColor,
                                  selectedValue: selectedValue,
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 14),
                                  selectedValueChanged: (value) {
                                    selectedValue = value;
                                    _bloodGroupEdited = true;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: !Settings.userAccess.updateProfile!
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          formKey.currentState!.save();
                          var data = ProfileUpdateDto();
                          data.empCode = Session.empCode;
                          data.bloodGroup = ProfileUpdateDataLineModel(
                              data: selectedValue, edited: _bloodGroupEdited);
                          data.ipx = ProfileUpdateDataLineModel(
                              data: ctrlIpx.text, edited: _ipxEdited);
                          data.mobileNo = ProfileUpdateDataLineModel(
                              data: ctrlMobile.text, edited: _mobileNoEdited);
                          data.mobileNoEmergency = ProfileUpdateDataLineModel(
                              data: ctrlMobileEmergency.text,
                              edited: _mobileNoEmergencyEdited);
                          data.email = ProfileUpdateDataLineModel(
                              data: ctrlEmail.text.trim(),
                              edited: _emailEdited);

                          data.isBloodDonor = ProfileUpdateDataLineModel(
                              data: _isBloodDonor ? "1" : "0",
                              edited: _isBloodDonorEdited);

                          data.image = ProfileUpdateDataLineModel(
                              data: base64.encode(Session.empImage),
                              edited: _imageEdited);

                          if (!data.bloodGroup!.edited! &&
                              !data.ipx!.edited! &&
                              !data.mobileNo!.edited! &&
                              !data.mobileNoEmergency!.edited! &&
                              !data.email!.edited! &&
                              !data.image!.edited!) {
                            return;
                          }
                          Utils.showLoadingIndicator(context);
                          var success = await UserService.updateProfile(data);
                          Utils.hideLoadingIndicator(context);

                          if (success) {
                            MessageBox.success(context, "Profile Update",
                                "Profile updated successfully",
                                onOkTapped: () {});
                          } else {
                            MessageBox.error(
                                context, "Profile Update", "An error occurred");
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: UserColors.primaryColor),
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
            ]),
          ),
        ),
      ),
    ));
  }
}

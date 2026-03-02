import 'package:flutter/material.dart';
import 'package:peoplepro/models/e-canteen/cateen_admin_factory_guest_token_model.dart';
import 'package:peoplepro/services/canteen_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';

class CanteenAdminFactoryGuestTokenScreen extends StatefulWidget {
  const CanteenAdminFactoryGuestTokenScreen({Key? key}) : super(key: key);

  @override
  State<CanteenAdminFactoryGuestTokenScreen> createState() =>
      _CanteenAdminFactoryGuestTokenScreenState();
}

class _CanteenAdminFactoryGuestTokenScreenState
    extends State<CanteenAdminFactoryGuestTokenScreen> {
  List<AdminFactoryGuestTokenModel> _tokens = [];
  var ctrlFactoryGuestId = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => loadFactoryGuestTokens());
  }

  void loadFactoryGuestTokens() async {
    _tokens = await CanteenService.getAdminFactoryGuestTokens();

    setState(() {});
  }

  @override
  void dispose() {
    ctrlFactoryGuestId.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
          title: "e-Canteen: Factory Guests",
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.card_membership_outlined,
                        size: 20.0,
                        color: UserColors.red,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          "Pending Token (${_tokens.length})",
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                            children: _tokens.map((c) => cardRow(c)).toList())),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget cardRow(AdminFactoryGuestTokenModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.card_membership_outlined,
                color: UserColors.primaryColor,
                size: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                  data.tokenNo.toString(),
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
          Text(
            data.requestedAt,
          ),
          InkWell(
            onTap: () {
              Utils.showWidgetModal(
                context,
                "Token Update",
                Column(
                  children: [
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Enter Factory Guest ID",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        TextField(
                          controller: ctrlFactoryGuestId,
                          maxLength: 6,
                          decoration: Utils.inputDecoration(),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
                () async {
                  var empId = ctrlFactoryGuestId.text;
                  if (empId.isEmpty) return;
                  Navigator.pop(context);

                  data.factoryGuestId = empId;
                  ctrlFactoryGuestId.text = "";
                  var output =
                      await CanteenService.updateFactoryGuestToken(data);
                  if (output.isSuccess!) {
                    loadFactoryGuestTokens();
                    MessageBox.success(context, "Success", output.message!);
                  } else {
                    MessageBox.error(context, "Error", output.message!);
                  }
                },
                buttonText: "SUBMIT",
                isCancelVisibled: false,
              );
            },
            child: Container(
                decoration: BoxDecoration(
                    color: UserColors.primaryColor,
                    borderRadius: BorderRadius.circular(2.0)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  child: Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:peoplepro/models/e-canteen/canteen_admin_card_model.dart';
import 'package:peoplepro/screens/e-canteen/admin_card_member_screen.dart';
import 'package:peoplepro/services/canteen_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';

class CanteenAdminCardScreen extends StatefulWidget {
  const CanteenAdminCardScreen({Key? key}) : super(key: key);

  @override
  State<CanteenAdminCardScreen> createState() => _CanteenAdminCardScreenState();
}

class _CanteenAdminCardScreenState extends State<CanteenAdminCardScreen> {
  List<CanteenAdminCardModel> _cards = [];
  int totalMembers = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadCards());
  }

  void loadCards() async {
    _cards = await CanteenService.getAdminCards();
    for (var card in _cards) {
      totalMembers += card.total ?? 0;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
          title: "e-Canteen: Master Card",
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
                          "Master Cards (${_cards.length}) : $totalMembers",
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                            children: _cards.map((c) => cardRow(c)).toList())),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget cardRow(CanteenAdminCardModel data) {
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
                  data.cardId!,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
          Text(
            data.description!,
          ),
          data.total! == 0
              ? const SizedBox.shrink()
              : Card(
                  child: InkWell(
                    onTap: () {
                      Utils.navigateTo(
                          context, AdminCardMemberScreen(cardId: data.cardId));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 12.0),
                      child: data.total! == 0
                          ? const SizedBox(height: 16.0)
                          : Text(
                              data.total.toString(),
                              style: TextStyle(
                                  color: UserColors.primaryColor,
                                  fontSize: 16.0),
                            ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

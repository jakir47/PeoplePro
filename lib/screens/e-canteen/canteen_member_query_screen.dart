import 'package:peoplepro/models/e-canteen/canteen_member_model.dart';
import 'package:peoplepro/services/canteen_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class CanteenMemberQueryScreen extends StatefulWidget {
  final int type;
  final dynamic inputData;
  const CanteenMemberQueryScreen(
      {super.key, required this.type, this.inputData});

  @override
  State<CanteenMemberQueryScreen> createState() =>
      _CanteenMemberQueryScreenState();
}

class _CanteenMemberQueryScreenState extends State<CanteenMemberQueryScreen> {
  List<CanteenMemberModel> members = [];
  var total = 0;
  var active = 0;
  var inactive = 0;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadMembers());
  }

  Future<void> loadMembers() async {
    isLoading = true;
    setState(() {});
    Utils.showLoadingIndicator(context);

    members =
        await CanteenService.getMembersQuery(widget.type, widget.inputData);
    total = members.length;
    active = members.where((e) => e.isActive!).length;
    inactive = total - active;
    Utils.hideLoadingIndicator(context);
    isLoading = false;
    setState(() {});
  }

  String getTitle() {
    switch (widget.type) {
      case 1:
        return "Members: Paid";
      case 2:
        return "Members: Free";
      case 3:
        return "Members: Rice";
      case 4:
        return "Meal Closed: ${Utils.formatDate(widget.inputData!)}";
      case 5:
        return "Master Card: ${widget.inputData!}";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
          title: getTitle(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (ctx, index) {
                        var member = members[index];
                        var image = Image.asset("assets/images/avatar.jpg");
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius:
                                  BorderRadiusDirectional.circular(4.0)),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            leading: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3.0),
                                    child: image,
                                  ),
                                ),
                                Positioned(
                                    bottom: -5,
                                    right: -5,
                                    child: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: member.isRiceService!
                                                ? UserColors.green
                                                : member.isFreeService!
                                                    ? UserColors.red
                                                    : UserColors.primaryColor,
                                          ),
                                          child: Container(),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.name!,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                                const SizedBox(height: 2.0),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.card_membership_outlined,
                                            color: UserColors.primaryColor,
                                            size: 16.0),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            member.empCode!,
                                            overflow: TextOverflow.fade,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (member.cardId!.isNotEmpty &&
                                        widget.type == 4)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 24.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.card_membership_outlined,
                                                color: UserColors.red,
                                                size: 16.0),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                member.cardId!,
                                                overflow: TextOverflow.fade,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black87),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 2.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 0.0),
                                  decoration: BoxDecoration(
                                      color: UserColors.primaryColor,
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: Text(
                                    member.designation!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  member.department!,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 13.0,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                          child: SizedBox(),
                        );
                      },
                      itemCount: members.length),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                        ),
                        child: generateBlock("Total", total, Colors.black54)),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  generateBlock(String title, int count, Color color) {
    return Container(
      width: 110.0,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(6.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(20.0)),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 12.0),
              )),
          Container(
            width: 42,
            padding: const EdgeInsets.only(left: 6.0),
            child:
                Text(count.toString(), style: const TextStyle(fontSize: 14.0)),
          ),
        ],
      ),
    );
  }
}

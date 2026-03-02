import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:peoplepro/models/e-canteen/canteen_member_model.dart';
import 'package:peoplepro/services/canteen_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class AdminCardMemberScreen extends StatefulWidget {
  final String? cardId;
  const AdminCardMemberScreen({super.key, this.cardId});

  @override
  State<AdminCardMemberScreen> createState() => _AdminCardMemberScreenState();
}

class _AdminCardMemberScreenState extends State<AdminCardMemberScreen> {
  List<CanteenMemberModel> members = [];

  final TextEditingController searchController = TextEditingController();
  CanteenMemberModel? searchResultMember;

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

    // 4 = Card Members
    members = await CanteenService.getAdminCardMembers(widget.cardId!);
    total = members.length;
    active = members.where((e) => e.isActive!).length;
    inactive = total - active;
    Utils.hideLoadingIndicator(context);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
          title: "Master Card: ${widget.cardId!}",
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (ctx, index) {
                        var member = members[index];
                        var image = Image.asset("assets/images/avatar.jpg");
                        return buildMemberRow(image, member);
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
                        child: Container(
                          width: 110.0,
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(4.0)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                      color: UserColors.primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: const Text(
                                    "Total",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12.0),
                                  )),
                              Container(
                                width: 42,
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(members.length.toString(),
                                    style: const TextStyle(fontSize: 14.0)),
                              ),
                            ],
                          ),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          showSearchDialog(context);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.add_outlined),
                            Text("Add Member"),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget buildMemberRow(Image image, CanteenMemberModel member) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: (context) async {
              showConfirmationDialog(context, member);
            },
            backgroundColor: UserColors.red,
            foregroundColor: Colors.white,
            icon: Icons.close_outlined,
            label: 'Remove',
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadiusDirectional.circular(4.0)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 2.0),
              Row(
                children: [
                  Row(
                    children: [
                      Icon(Icons.card_membership_outlined,
                          color: UserColors.primaryColor, size: 16.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          member.empCode!,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 2.0),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 0.0),
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
        ),
      ),
    );
  }

  void showConfirmationDialog(BuildContext context, CanteenMemberModel member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.red,
              ),
              SizedBox(width: 8), // Spacing between the icon and text
              Text(
                'Confirmation',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Are you sure want to remove?'),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Column(
                  children: [
                    Text(member.name!),
                    const SizedBox(height: 2.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.card_membership_outlined,
                            color: UserColors.primaryColor, size: 16.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            member.empCode!,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
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
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Perform your "Yes" action here
                performRemoveAction(widget.cardId!, member.empCode!, true);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Red text for the button
              ),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void performRemoveAction(
      String cardId, String memberId, bool isRemove) async {
    var success =
        await CanteenService.adminMasterCardMemberAddRemove(cardId, memberId);

    if (success) {
      MessageBox.success(
          context,
          "Master Card Member",
          isRemove
              ? "Member removed succesfully"
              : "Member added successfully");
      loadMembers();
    } else {
      MessageBox.error(
          context, "Master Card Member", "Oops! something went wrong");
    }
  }

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext dialogContext, StateSetter setDialogState) {
            return AlertDialog(
              title:
                  const Text('Search Member', style: TextStyle(fontSize: 16.0)),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Enter Member ID',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          var memberId = searchController.text;
                          var data =
                              await CanteenService.getAdminCardMemberSearch(
                                  memberId);
                          setDialogState(() {
                            searchResultMember = data.firstOrNull;
                          });
                        },
                        icon: const Icon(Icons.search_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  if (searchResultMember != null)
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: Column(
                        children: [
                          Text(
                            searchResultMember!.name!,
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          const SizedBox(height: 2.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.card_membership_outlined,
                                      color: UserColors.primaryColor,
                                      size: 16.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      searchResultMember!.empCode!,
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                              if (searchResultMember!.cardId!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.card_membership_outlined,
                                          color: UserColors.red, size: 16.0),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          searchResultMember!.cardId!,
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
                                horizontal: 6.0, vertical: 1.0),
                            decoration: BoxDecoration(
                                color: UserColors.primaryColor,
                                borderRadius: BorderRadius.circular(4.0)),
                            child: Text(
                              searchResultMember!.designation!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            searchResultMember!.department!,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    searchResultMember = null;
                    searchController.text = "";
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: searchResultMember == null ||
                          searchResultMember!.cardId!.isNotEmpty
                      ? null
                      : () {
                          searchController.text = "";
                          Navigator.of(context).pop();
                          performRemoveAction(widget.cardId!,
                              searchResultMember!.empCode!, false);
                          searchResultMember = null;
                        },
                  style: TextButton.styleFrom(
                    foregroundColor:
                        searchResultMember == null ? Colors.grey : Colors.red,
                  ),
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

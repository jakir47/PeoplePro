import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:peoplepro/models/e-canteen/canteen_member_model.dart';
import 'package:peoplepro/services/canteen_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';

class CanteenMembersScreen extends StatefulWidget {
  const CanteenMembersScreen({Key? key}) : super(key: key);

  @override
  State<CanteenMembersScreen> createState() => _CanteenMembersScreenState();
}

class _CanteenMembersScreenState extends State<CanteenMembersScreen> {
  List<CanteenMemberModel> members = [];
  List<CanteenMemberModel> filteredMembers = [];
  var total = 0;
  var active = 0;
  var inactive = 0;
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadMembers());
    searchController.addListener(filterMembers);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadMembers() async {
    isLoading = true;
    setState(() {});
    Utils.showLoadingIndicator(context);
    members = await CanteenService.getMembers();
    filteredMembers = members;
    total = members.length;
    active = members.where((e) => e.isActive!).length;
    inactive = total - active;
    Utils.hideLoadingIndicator(context);
    isLoading = false;
    setState(() {});
  }

  void filterMembers() {
    String query = searchController.text.toLowerCase();
    filteredMembers = members.where((member) {
      return member.name!.toLowerCase().contains(query) ||
          member.empCode!.toLowerCase().contains(query) ||
          member.cardId!.toLowerCase().contains(query) ||
          (member.isActive! ? "Active" : "Inactive")
              .toLowerCase()
              .contains(query) ||
          member.department!.toLowerCase().contains(query);
    }).toList();

    total = filteredMembers.length;
    active = filteredMembers.where((e) => e.isActive!).length;
    inactive = total - active;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Members",
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    labelText: "Search Anything",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (ctx, index) {
                    var member = filteredMembers[index];
                    var image = Image.asset("assets/images/avatar.jpg");
                    return getMemberRow(image, member);
                  },
                  separatorBuilder: (ctx, index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                      child: SizedBox(),
                    );
                  },
                  itemCount: filteredMembers.length,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    generateBlock("Total", total, Colors.black54),
                    generateBlock("Active", active, Colors.green),
                    generateBlock("Inactive", inactive, Colors.red)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getMemberRow(Image image, CanteenMemberModel member) {
    return Slidable(
      key: ValueKey(member.empCode),
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: (context) async {
              showConfirmationDialog(context, member);
            },
            backgroundColor: member.isActive! ? UserColors.red : Colors.green,
            foregroundColor: Colors.white,
            icon: member.isActive! ? Icons.save_outlined : Icons.save_outlined,
            label: member.isActive! ? "Inactive" : "Active",
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadiusDirectional.circular(4.0),
        ),
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
                        color: member.isActive! ? Colors.green : UserColors.red,
                      ),
                      child: Container(),
                    ),
                  ),
                ),
              ),
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
                  if (member.cardId!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Row(
                        children: [
                          Icon(Icons.card_membership_outlined,
                              color: UserColors.red, size: 16.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              member.cardId!,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Row(
                      children: [
                        Icon(Icons.free_cancellation_outlined,
                            color: member.isFreeService!
                                ? UserColors.red
                                : Colors.green,
                            size: 16.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            member.isFreeService! ? "Free" : "Paid",
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2.0),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.0),
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
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(20.0)),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          ),
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

  void showConfirmationDialog(BuildContext context, CanteenMemberModel member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Text(
                'Confirmation',
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Are you sure want to make ${member.isActive! ? "inactive" : "active"}?'),
              const SizedBox(height: 16.0),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
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
                          fontSize: 12.0,
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
                performRemoveAction(
                    Session.empCode, member.empCode!, member.isActive!);
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
      String userId, String memberId, bool isActive) async {
    var success =
        await CanteenService.adminMemberStatusUpdate(userId, memberId);

    if (success) {
      MessageBox.success(
          context,
          "Member Status",
          isActive
              ? "Member inactive succesfully"
              : "Member active successfully");
      loadMembers();
    } else {
      MessageBox.error(context, "Member Status", "Oops! something went wrong");
    }
  }
}

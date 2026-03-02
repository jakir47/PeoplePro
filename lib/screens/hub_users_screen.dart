import 'dart:convert';
import 'package:peoplepro/providers/hub_provider.dart';
import 'package:peoplepro/screens/employee_directory_search_result.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HubUsersScreen extends StatefulWidget {
  const HubUsersScreen({Key? key}) : super(key: key);

  @override
  State<HubUsersScreen> createState() => _HubUsersScreenState();
}

class _HubUsersScreenState extends State<HubUsersScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var users = context.watch<HubProvider>().hubUsers;
    return Scaffold(
      body: BackgroundWidget(
          title: "Hub Users",
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (ctx, index) {
                        var user = users[index];

                        Image image;
                        var photo = user.photo;

                        if (photo.isEmpty) {
                          image = Image.asset("assets/images/avatar.jpg");
                        } else {
                          var img = const Base64Decoder().convert(photo);
                          image = Image.memory(
                            img,
                            fit: BoxFit.cover,
                            scale: 1.0,
                          );
                        }

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius:
                                  BorderRadiusDirectional.circular(4.0)),
                          child: ListTile(
                            leading: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                SizedBox(
                                  width: 60.0,
                                  height: 60.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: image,
                                  ),
                                ),
                                Positioned(
                                    bottom: -5,
                                    right: -5,
                                    child: Container(
                                      width: 16.0,
                                      height: 16.0,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: user.isConnected
                                                  ? Colors.green
                                                  : Colors.red),
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
                                  user.name,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                                const SizedBox(height: 2.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 0.0),
                                  decoration: BoxDecoration(
                                      color: UserColors.primaryColor,
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: Text(
                                    user.designation,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  user.department,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 13.0,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      user.isConnected
                                          ? "Connected: "
                                          : "Last seen: ",
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    Text(
                                      Utils.formatDateTimeAsReadable(
                                          user.lastSeen),
                                      style: const TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      EmployeeDirectorySearchResultScreen(
                                          searchText: user.empCode,
                                          searchType: "EmpCode")));
                            },
                          ),
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                          child: SizedBox(),
                        );
                      },
                      itemCount: users.length),
                ),
                Container(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        generateBlock("Total", users.length, Colors.black54),
                        generateBlock(
                            "Online",
                            users.where((item) => item.isConnected).length,
                            Colors.green),
                        generateBlock(
                            "Offline",
                            users
                                .where((item) => item.isConnected == false)
                                .length,
                            Colors.red)
                      ],
                    )),
              ],
            ),
          )),
    );
  }

  generateBlock(String title, int count, Color color) {
    return Container(
      width: 100.0,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(20.0)),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 12.0),
              )),
          Container(
            width: 40,
            padding: const EdgeInsets.only(left: 6.0),
            child:
                Text(count.toString(), style: const TextStyle(fontSize: 14.0)),
          ),
        ],
      ),
    );
  }
}

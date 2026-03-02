import 'package:peoplepro/services/hive_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:peoplepro/widgets/mini_button_widget.dart';
import 'package:flutter/material.dart';

class CacheManagerScreen extends StatefulWidget {
  const CacheManagerScreen({Key? key}) : super(key: key);

  @override
  State<CacheManagerScreen> createState() => _CacheManagerScreenState();
}

class _CacheManagerScreenState extends State<CacheManagerScreen> {
  final TextEditingController _textController = TextEditingController();
  clearUserCache() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          titlePadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          title: const Text(
            'Enter Employee Code',
            style: TextStyle(fontSize: 14),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 0.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(color: UserColors.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(color: UserColors.primaryColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    controller: _textController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop(_textController.text);
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
                      'OK',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((empCode) async {
      if (empCode != null && empCode.toString().isNotEmpty) {
        _textController.clear();
        await clearCache("user", empCode: empCode);
      }
    });
  }

  clearCache(String type, {String? empCode}) async {
    var cleared = await HiveService.clearCache(type, empCode);
    if (cleared) {
      MessageBox.success(
          context, "Cache Manager", "Cache cleared successfully");
    } else {
      MessageBox.error(context, "Cache Manager", "Oops! something went wrong!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Cache Manager",
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 4,
            children: [
              MiniButtonWidget(
                label: "Policy",
                icon: Icons.policy,
                color: Colors.red.shade600,
                onTap: () async {
                  await clearCache("policy");
                },
              ),
              MiniButtonWidget(
                label: "Notification",
                icon: Icons.notifications_active_outlined,
                color: Colors.red.shade600,
                onTap: () async {
                  await clearCache("notification");
                },
              ),
              MiniButtonWidget(
                label: "Notice",
                icon: Icons.message_outlined,
                color: Colors.red.shade600,
                onTap: () async {
                  await clearCache("notice");
                },
              ),
              MiniButtonWidget(
                label: "User",
                icon: Icons.verified_user,
                color: Colors.red.shade600,
                onTap: () {
                  clearUserCache();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:peoplepro/models/notificaiton_model.dart';
import 'package:peoplepro/providers/hub_provider.dart';
import 'package:peoplepro/services/notification_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  List<NotificationModel> _notifications = [];
  List<int> _notificationIds = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadNotifications());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadNotifications() async {
    isLoading = true;
    setState(() {});
    Utils.showLoadingIndicator(context);
    _notificationIds = context.read<HubProvider>().notificationIds;
    context.read<HubProvider>().removeNotificationIds();
    _notifications = await NotificationService.getListAll();
    Utils.hideLoadingIndicator(context);
    isLoading = false;
    setState(() {});
  }

  buildListItem(NotificationModel notification) {
    var lastNotificationId = context.watch<HubProvider>().lastNotificationId;
    var unseen = _notificationIds.contains(notification.notificationId) ||
        notification.notificationId! > lastNotificationId;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          border: Border.all(width: 1, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 16.0,
                    backgroundColor: Colors.orange.withOpacity(0.7),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  if (unseen)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(color: Colors.white, width: 1.0),
                          color: Colors.red,
                        ),
                      ),
                    )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title!,
                      style: TextStyle(
                          fontSize: 14, color: UserColors.primaryColor),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      Utils.formatDateTimeAsReadable(notification.createdAt!),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          InkWell(
            onLongPress: () {
              FlutterClipboard.copy(notification.content!)
                  .then((value) => Utils.showToast("Notification copied"));
            },
            child: Card(
              margin: const EdgeInsets.only(top: 8.0),
              elevation: 0.5,
              color: Colors.white.withOpacity(0.90),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: Linkify(
                  onOpen: (link) async {
                    var uri = Uri.parse(link.url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      // can't launch url
                    }
                  },
                  text: notification.content!,
                  style: const TextStyle(color: Colors.black87),
                  linkStyle: TextStyle(color: Colors.blue.shade700),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Notifications",
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                  child: !isLoading
                      ? RefreshIndicator(
                          onRefresh: loadNotifications,
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 6.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    "Last 15 days",
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  ),
                                );
                              }
                              var notification = _notifications[index - 1];
                              return buildListItem(notification);
                            },
                            itemCount: _notifications.length + 1,
                            separatorBuilder: ((context, index) {
                              return const SizedBox(height: 4.0);
                            }),
                          ),
                        )
                      : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}

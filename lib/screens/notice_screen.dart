import 'package:peoplepro/models/notice_model.dart';
import 'package:peoplepro/screens/notice_viewer_screen.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  List<NoticeModel> _notices = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadNotices());
  }

  Future<void> loadNotices() async {
    isLoading = true;
    setState(() {});
    Utils.showLoadingIndicator(context);
    _notices = Session.userData.notices!;
    _notices.sort((a, b) {
      var adate = a.publishDate!;
      var bdate = b.publishDate!;
      return bdate.compareTo(adate);
    });

    Utils.hideLoadingIndicator(context);
    isLoading = false;
    setState(() {});
  }

  buildListItem(NoticeModel notice) {
    var dayName = DateFormat('EEEE').format(notice.publishDate!);
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return NoticeViewerScreen(notice: notice);
        }));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(4.0)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 42.0,
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.yellow.shade700,
                            ),
                            Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.yellow.shade800,
                            ),
                            Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.yellow.shade900,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        notice.title!,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                SizedBox(
                  width: 80.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 4.0),
                        decoration: BoxDecoration(
                            color: UserColors.primaryColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4))),
                        alignment: Alignment.center,
                        child: Text(Utils.formatDate(notice.publishDate!),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white)),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2.0),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4))),
                          height: 18,
                          alignment: Alignment.center,
                          child: Text(dayName,
                              style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Notices",
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? const SizedBox.shrink()
              : RefreshIndicator(
                  onRefresh: loadNotices,
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var notice = _notices[index];
                      return buildListItem(notice);
                    },
                    itemCount: _notices.length,
                    separatorBuilder: ((context, index) {
                      return const SizedBox(height: 4.0);
                      // Divider(height: 1, color: Colors.grey.withOpacity(0.5));
                    }),
                  ),
                ),
        ),
      ),
    );
  }
}

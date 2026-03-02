import 'package:peoplepro/models/notice_model.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class NoticeViewerScreen extends StatelessWidget {
  final NoticeModel notice;

  const NoticeViewerScreen({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: notice.title,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(
                    Utils.getImageUrl(notice.image!),
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16.0),
                  Text(notice.content!),

                  // Text(Utils.formatDate(notice.publishDate!)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

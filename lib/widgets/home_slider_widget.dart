import 'package:peoplepro/models/notice_model.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeSliderWidget extends StatefulWidget {
  final List<NoticeModel> notices;
  final ValueChanged<String>? onSlideTap;
  const HomeSliderWidget({super.key, required this.notices, this.onSlideTap});

  @override
  State<HomeSliderWidget> createState() => _HomeSliderWidgetState();
}

class _HomeSliderWidgetState extends State<HomeSliderWidget> {
  final CarouselController controller = CarouselController();

  int _slideIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
            carouselController: controller,
            items: widget.notices.map((notice) {
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white.withOpacity(0.7), width: 0.0),
                    borderRadius: BorderRadius.circular(10.0)),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  child: GestureDetector(
                      onTap: () {
                        var imageUrl = Utils.getImageUrl(notice.image!);
                        widget.onSlideTap!.call(imageUrl);
                      },
                      child: Image.network(
                        Utils.getImageUrl(notice.thumbnail!),
                        fit: BoxFit.cover,
                      )),
                ),
              );
            }).toList(),
            options: CarouselOptions(
                height: 120,
                autoPlay: true,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: ((index, reason) {
                  _slideIndex = index;
                  setState(() {});
                }))),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.notices.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => controller.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54
                        .withOpacity(_slideIndex == entry.key ? 0.7 : 0.3)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

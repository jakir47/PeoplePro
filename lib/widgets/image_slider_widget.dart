import 'dart:async';

import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final ValueChanged<String>? onSlideTap;
  final Color indicatorColor;
  final int interval;
  const ImageSlider({
    required this.imageUrls,
    this.indicatorColor = Colors.blue,
    this.interval = 5,
    this.onSlideTap,
    Key? key,
  }) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentIndex = 0;
  final PageController _controller = PageController(initialPage: 0);
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: widget.interval), (timer) {
      _currentIndex =
          (_currentIndex + 1) % widget.imageUrls.length; // loop through images

      _controller.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            height: 150.0,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                var imageUrl = widget.imageUrls[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white.withOpacity(0.7), width: 0.0),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      child: widget.onSlideTap == null
                          ? null
                          : GestureDetector(
                              onTap: () => widget.onSlideTap!.call(imageUrl),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                    ),
                  ),
                );
              },
              onPageChanged: (index) {
                _currentIndex = index;
                setState(() {});
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.imageUrls.length, (index) {
              return Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? widget.indicatorColor
                      : Colors.grey.withOpacity(0.5),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/extension.dart';
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;
  final bool showBottomStrip;
  final bool showPoweredBy;
  final String? title;
  final Widget? optionWidget;
  final bool showTitlebar;
  final IconButton? leadingWidget;
  const BackgroundWidget({
    Key? key,
    required this.child,
    this.showBottomStrip = false,
    this.showPoweredBy = false,
    this.title,
    this.showTitlebar = true,
    this.optionWidget,
    this.leadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var backImage = const AssetImage("assets/images/background.jpg");

    return SafeArea(
      child: Container(
        width: double.infinity,
        height: size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: backImage,
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(children: [
          Visibility(
            visible: showPoweredBy,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 3.0,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(3.0)),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "POWERED BY ",
                      style:
                          TextStyle(fontSize: 10, color: Colors.grey.shade800),
                      children: [
                        TextSpan(
                            text: "BENGAL GROUP IT",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: UserColors.primaryColor)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: showBottomStrip,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: HexColor.fromHex("#74C0F0"),
                height: 16.0,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: UserColors.primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    height: 8.0,
                    width: size.width / 2,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Visibility(
                visible: showTitlebar,
                child: Material(
                  elevation: 12.0,
                  child: Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: backImage,
                        fit: BoxFit.cover,
                      ),
                      color: UserColors.primaryColor.withOpacity(0.9),
                      border: Border.all(
                          color: UserColors.primaryColor.withOpacity(0.2),
                          width: 1.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          leadingWidget == null
                              ? IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(
                                    Icons.arrow_back_ios_outlined,
                                    color: UserColors.primaryColor,
                                  ))
                              : leadingWidget!,
                          Text(
                            title ?? "",
                            style: TextStyle(
                                fontSize: 16.0, color: UserColors.primaryColor),
                          ),
                          optionWidget == null
                              ? const SizedBox(
                                  width: 24.0,
                                  height: 24.0,
                                )
                              : optionWidget!
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ]),
      ),
    );
  }
}

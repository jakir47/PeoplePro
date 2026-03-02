import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeviceInfoScreen extends StatelessWidget {
  const DeviceInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var copyrightYear = Settings.serverToday.year.toString();
    return Scaffold(
        body: BackgroundWidget(
      title: "Device Info",
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12.0),
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    color: UserColors.primaryColor,
                    height: 70,
                    width: 70,
                  ),
                  const SizedBox(height: 6.0),
                  // const Text(
                  //   "BGI HRIS",
                  //   style: TextStyle(
                  //       fontSize: 16.0,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.black87),
                  // ),
                  // const SizedBox(height: 2.0),
                  Text(
                    "Version ${Settings.appVersion}",
                    style: TextStyle(
                        fontSize: 12.0, color: Colors.black87.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 12.0),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Manufacturer: ",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                      children: [
                        TextSpan(
                            text: Settings.manufacturer,
                            style: TextStyle(
                                fontSize: 14, color: UserColors.primaryColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Brand: ",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                      children: [
                        TextSpan(
                            text: Settings.brand,
                            style: TextStyle(
                                fontSize: 14, color: UserColors.primaryColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Model: ",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                      children: [
                        TextSpan(
                            text: Settings.model,
                            style: TextStyle(
                                fontSize: 14, color: UserColors.primaryColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Android: ",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                      children: [
                        TextSpan(
                            text:
                                "${Utils.getOsName()} (${Settings.osVersion})",
                            style: TextStyle(
                                fontSize: 14, color: UserColors.primaryColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Architecture: ",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                      children: [
                        TextSpan(
                            text: Settings.architecture,
                            style: TextStyle(
                                fontSize: 14, color: UserColors.primaryColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Supported Abis: ",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                      children: [
                        TextSpan(
                            text: Settings.supportedAbis,
                            style: TextStyle(
                                fontSize: 14, color: UserColors.primaryColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Tags: ",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                      children: [
                        TextSpan(
                            text: Settings.tags,
                            style: TextStyle(
                                fontSize: 14, color: UserColors.primaryColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "All rights reserved. Copyright © $copyrightYear ",
                style: const TextStyle(fontSize: 12, color: Colors.white70),
                children: const [
                  TextSpan(
                      text: "Bengal Group IT.",
                      style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}

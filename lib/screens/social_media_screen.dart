import 'package:peoplepro/utils/extension.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialMediaScreen extends StatefulWidget {
  SocialMediaScreen({Key? key}) : super(key: key);

  @override
  State<SocialMediaScreen> createState() => _SocialMediaScreenState();
}

class _SocialMediaScreenState extends State<SocialMediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
      title: "Our Social Media",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  child: IconButton(
                      iconSize: 36.0,
                      icon: FaIcon(
                        FontAwesomeIcons.facebook,
                        color: HexColor.fromHex("#3b5998"),
                      ),
                      onPressed: () {
                        print("Pressed");
                      }),
                ),
                Card(
                  child: IconButton(
                      iconSize: 36.0,
                      icon: FaIcon(
                        FontAwesomeIcons.googlePlus,
                        color: HexColor.fromHex("#dc4e41"),
                      ),
                      onPressed: () {
                        print("Pressed");
                      }),
                ),
                Card(
                  child: IconButton(
                      iconSize: 36.0,
                      icon: FaIcon(
                        FontAwesomeIcons.linkedin,
                        color: HexColor.fromHex("#0077b5"),
                      ),
                      onPressed: () {
                        print("Pressed");
                      }),
                ),
                Card(
                  child: IconButton(
                      iconSize: 36.0,
                      icon: FaIcon(
                        FontAwesomeIcons.instagram,
                        color: HexColor.fromHex("#3f729b"),
                      ),
                      onPressed: () {
                        print("Pressed");
                      }),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  child: IconButton(
                      iconSize: 36.0,
                      icon: FaIcon(
                        FontAwesomeIcons.youtube,
                        color: HexColor.fromHex("#cd201f"),
                      ),
                      onPressed: () {
                        print("Pressed");
                      }),
                ),
                Card(
                  child: IconButton(
                      iconSize: 36.0,
                      icon: FaIcon(
                        FontAwesomeIcons.twitter,
                        color: HexColor.fromHex("#55acee"),
                      ),
                      onPressed: () {
                        print("Pressed");
                      }),
                ),
                Card(
                  child: IconButton(
                      iconSize: 36.0,
                      icon: FaIcon(
                        FontAwesomeIcons.yahoo,
                        color: HexColor.fromHex("#410093"),
                      ),
                      onPressed: () {
                        print("Pressed");
                      }),
                ),
                Card(
                  child: IconButton(
                      iconSize: 36.0,
                      icon: FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: HexColor.fromHex("#43d854"),
                      ),
                      onPressed: () {
                        print("Pressed");
                      }),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  child: IconButton(
                      iconSize: 36.0,
                      icon: FaIcon(
                        FontAwesomeIcons.tumblr,
                        color: HexColor.fromHex("#00405d"),
                      ),
                      onPressed: () {
                        print("Pressed");
                      }),
                ),
                Card(
                  child: IconButton(
                      iconSize: 36.0,
                      icon: FaIcon(
                        FontAwesomeIcons.pinterest,
                        color: HexColor.fromHex("#bd081c"),
                      ),
                      onPressed: () {
                        print("Pressed");
                      }),
                ),
                Card(
                  child: IconButton(
                      iconSize: 36.0,
                      icon: FaIcon(
                        FontAwesomeIcons.delicious,
                        color: HexColor.fromHex("#3399ff"),
                      ),
                      onPressed: () {
                        print("Pressed");
                      }),
                ),
                Card(
                  child: IconButton(
                      iconSize: 36.0,
                      icon: FaIcon(
                        FontAwesomeIcons.stumbleupon,
                        color: HexColor.fromHex("#eb4924"),
                      ),
                      onPressed: () {
                        print("Pressed");
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}

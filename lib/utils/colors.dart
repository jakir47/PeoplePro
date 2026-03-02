import 'package:flutter/material.dart';
import 'extension.dart';

class UserColors {
  //static Color primary = Color.fromRGBO(255, 83, 52, 1.0);

  // MaterialColor primarySwitch = MaterialColor(primary, swatch)
  static Color primaryColor = HexColor.fromHex('#1368aa');

  static Map<int, Color> colorMap = {
    50: const Color.fromRGBO(18, 107, 181, .1),
    100: const Color.fromRGBO(18, 107, 181, .2),
    200: const Color.fromRGBO(18, 107, 181, .3),
    300: const Color.fromRGBO(18, 107, 181, .4),
    400: const Color.fromRGBO(18, 107, 181, .5),
    500: const Color.fromRGBO(18, 107, 181, .6),
    600: const Color.fromRGBO(18, 107, 181, .7),
    700: const Color.fromRGBO(18, 107, 181, .8),
    800: const Color.fromRGBO(18, 107, 181, .9),
    900: const Color.fromRGBO(18, 107, 181, 1),
  };

  static MaterialColor primarySwatch =
      MaterialColor(primaryColor.value, colorMap);

  static Color red = HexColor.fromHex('#d63230');
  static Color green = HexColor.fromHex("#137547");

  static Color backgroundColor = HexColor.fromHex('#F0F0F0');
  static Color borderColor = HexColor.fromHex('#6096B4');
  static Color defaultColor = HexColor.fromHex('#E92026');
}

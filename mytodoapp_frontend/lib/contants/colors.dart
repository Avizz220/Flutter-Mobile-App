import 'package:flutter/material.dart';

class AppColor {
  static Color accentColor = Colors.blue;
  static const Color signupcolor = Color.fromARGB(255, 245, 245, 245);
  static const Color fontcolor = Color.fromRGBO(12, 14, 19, 15);
  static const Color labletextcolor = Color.fromRGBO(1, 143, 148, 154);
  static const Color loginanimationcolour = Color.fromARGB(255, 243, 246, 248);
  static const Color textfieldbordercolor = Color.fromRGBO(255, 242, 242, 242);
  static const Color progressbgcolor = Color.fromRGBO(0, 71, 151, 1);

  // Method to update the accent color dynamically
  static void updateAccentColor(Color newColor) {
    accentColor = newColor;
  }
}

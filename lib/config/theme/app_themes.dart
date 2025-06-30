import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//
// ThemeData theme() {
//   return ThemeData(
//     timePickerTheme:
//         TimePickerThemeData(backgroundColor: ColorResources.whiteColor),
//     scaffoldBackgroundColor: Colors.white,
//     textTheme: GoogleFonts.interTextTheme(),
//   );
// }
ThemeData theme() {
  return ThemeData(
    timePickerTheme: TimePickerThemeData(backgroundColor: Colors.white),
    scaffoldBackgroundColor: ColorResources.appColor,
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue, // Customize app bar color
      titleTextStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
    ),
  );
}

// Dark theme
ThemeData darkTheme() {
  return ThemeData(
    timePickerTheme: TimePickerThemeData(backgroundColor: Colors.black),
    scaffoldBackgroundColor: Colors.black,
    textTheme: GoogleFonts.robotoSlabTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueGrey, // Customize dark app bar color
      titleTextStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
    ),
  );
}

class ColorResources {
  static const Color appColor = Color.fromRGBO(3, 3, 39, 1.0);
  static const Color secondaryColor = Color.fromRGBO(132, 66, 209, 1.0);
  static const Color thirdColor = Color.fromRGBO(45, 213, 235, 1.0);
  static const Color fourthColor = Color.fromRGBO(4, 233, 200, 1.0);
  static const Color fifthColor = Color.fromRGBO(29,50,100, 1.0);
  static const Color blackColor = Color.fromRGBO(0, 0, 26, 1);
  static const Color whiteColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color bottombarColor = Color.fromRGBO(19, 38, 96, 1.0);
  static const Color txtColor = Color.fromRGBO(111, 128, 169, 1.0);
  static const Color txtLightColor = Color.fromRGBO(36, 215, 255, 1.0);
  static const Color cardBgColor = Color.fromRGBO(217, 217, 217, 1.0);
  static const Color appGreenColor = Color.fromRGBO(16, 181, 12, 1.0);
  static const Color appPurpleColor = Color.fromRGBO(178, 34, 255, 1.0);
  static const Color appRedColor = Color.fromRGBO(255, 0, 0, 1.0);
  static const Color btnColor = Color.fromRGBO(175, 100, 93, 1.0);
  static const Color grade1Color = Color.fromRGBO(0, 12, 42, 1.0);
  static const Color grade2Color = Color.fromRGBO(6, 134, 255, 1.0);
  static const Color  draweritemGradientColor = Color.fromRGBO(6, 25, 171, 1.0);
  static const Color btnGradPinkColor = Color.fromRGBO(65, 0, 148, 1.0);

  static const Color boxColor = Color.fromRGBO(247, 137, 55, 1);
  static const Color tableColor = Color.fromRGBO(254, 180, 152, 1);
  static const Color borderColor = Color.fromRGBO(201, 169, 166, 1);
  static const Color subTitleColor = Colors.white70;
}


class GradientColor {
  static const LinearGradient gradient1= LinearGradient(colors: [
    Color.fromRGBO(0,146,231, 1),
    Color.fromRGBO(54,62,225, 1),
    Color.fromRGBO(121,3,237, 1)
  ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,);

  static const LinearGradient gradient2= LinearGradient(colors: [
    Color.fromRGBO(0,146,231, 1),
    Color.fromRGBO(54,62,225, 1),
    Color.fromRGBO(121,3,237, 1)
  ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,);
}



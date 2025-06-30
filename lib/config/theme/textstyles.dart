import 'package:flutter/material.dart';

import '../../features/presentation/utility/global.dart';
import 'app_themes.dart';

class Styles {
  static thinTextStyle({
    double size = 14,
    double height = 1.2,
    Color? color,
    bool underlineNeeded = false,
  }) {
    return TextStyle(
      // fontFamily: 'PlusJakartaSans-Light',
        fontSize: size,
        fontWeight: FontWeight.w100,
        letterSpacing: 0.8,
        color: color ?? (appTheme == Brightness.dark ? Colors.white : Colors.black),
        decoration:
        underlineNeeded ? TextDecoration.underline : TextDecoration.none);
  }

  static lightTextStyle({
    double size = 14,
    double height = 1.2,
    Color? color,
    bool underlineNeeded = false,
  }) {
    return TextStyle(
      // fontFamily: 'PlusJakartaSans-Light',
        fontSize: size,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.8,
        color: color ?? (appTheme == Brightness.dark ? Colors.white : Colors.black),
        decoration:
        underlineNeeded ? TextDecoration.underline : TextDecoration.none);
  }

  static regularTextStyle({
    double size = 14,
    double height = 1.8,
    Color? color,
    bool underlineNeeded = false,
  }) {
    return TextStyle(
      // fontFamily: 'PlusJakartaSans-Regular',
        fontSize: size,
        fontWeight: FontWeight.w400,
        height: height,
        letterSpacing: 0.8,
        color: color ?? (appTheme == Brightness.dark ? Colors.white : Colors.black),
        decorationThickness: 1,
        decorationColor: ColorResources.whiteColor,
        decoration:
        underlineNeeded ? TextDecoration.underline : TextDecoration.none);
  }

  static mediumTextStyle({
    double size = 14,
    double height = 1.2,
    Color? color,
    bool underlineNeeded = false,
  }) {
    return TextStyle(
      // fontFamily: 'PlusJakartaSans-Medium',
        fontSize: size,
        decorationColor: ColorResources.whiteColor,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
        color: color ?? (appTheme == Brightness.dark ? Colors.white : Colors.black),
        decorationThickness: 1,
        decoration:
        underlineNeeded ? TextDecoration.underline : TextDecoration.none);
  }

  static semiBoldTextStyle({
    double size = 14,
    double height = 1.2,
    Color? color,
    bool underlineNeeded = false,
  }) {
    return TextStyle(
      // fontFamily: 'PlusJakartaSans-SemiBold',
        fontSize: size,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: color ?? (appTheme == Brightness.dark ? Colors.white : Colors.black),
        decoration:
        underlineNeeded ? TextDecoration.underline : TextDecoration.none,
        decorationColor: ColorResources.secondaryColor,
        decorationThickness: 1);
  }


  static semiBoldTextStyle2({
    double size = 14,
    double height = 1.2,
    Color? color,
    bool underlineNeeded = false,
  }) {
    return TextStyle(
      // fontFamily: 'PlusJakartaSans-SemiBold',
        fontSize: size,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: color ?? (appTheme == Brightness.dark ? Colors.white : Colors.black),
        decoration:
        underlineNeeded ? TextDecoration.underline : TextDecoration.none,
        decorationColor: ColorResources.whiteColor,
        decorationThickness: 1);
  }

  static boldTextStyle({
    double size = 14,
    double height = 1.2,
    Color? color,
    bool underlineNeeded = false,
  }) {
    return TextStyle(
        height: 1.2,
        // Adjust this value to change line spacing
        // fontFamily: 'PlusJakartaSans-Bold',
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: color ?? (appTheme == Brightness.dark ? Colors.white : Colors.black),
        decoration:
        underlineNeeded ? TextDecoration.lineThrough : TextDecoration.none,
        decorationColor: ColorResources.blackColor,
        decorationThickness: 1);
  }

  static boldTextStyle2({
    double size = 14,
    double height = 1.2,
    Color? color,
    bool underlineNeeded = false,
  }) {
    return TextStyle(
        height: 1.2,
        // Adjust this value to change line spacing
        // fontFamily: 'PlusJakartaSans-Bold',
        fontSize: size,
        letterSpacing: 0.8,
        fontWeight: FontWeight.w800,
        color: color ?? (appTheme == Brightness.dark ? Colors.white : Colors.black),
        decoration:
        underlineNeeded ? TextDecoration.lineThrough : TextDecoration.none,
        decorationColor: ColorResources.blackColor,
        decorationThickness: 3);
  }

  static extraBoldTextStyle({
    double size = 14,
    double height = 1.2,
    Color? color,
    bool underlineNeeded = false,
  }) {
    return TextStyle(
        height: 1.2,
        // Adjust this value to change line spacing
        // fontFamily: 'PlusJakartaSans-Bold',
        fontSize: size,
        letterSpacing: 0.8,
        fontWeight: FontWeight.w900,
        color: color ?? (appTheme == Brightness.dark ? Colors.white : Colors.black),
        decoration:
        underlineNeeded ? TextDecoration.lineThrough : TextDecoration.none,
        decorationColor: ColorResources.blackColor,
        decorationThickness: 3);
  }
}
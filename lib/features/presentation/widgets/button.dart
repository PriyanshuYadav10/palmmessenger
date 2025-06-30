import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/theme/app_themes.dart';
import '../utility/global.dart';
import '../utility/global.dart';
Widget customButton(
    Function onPressed,
    String buttonText,
    BuildContext context, {
      Color? color,
      double? radius,
      bool isLoading=false,
      Color? txtColor,
      Color? iconColor,
      Color? borderColor,
      String icon = '',
      double? iconSize,
      IconData? prefixIcon,
      Color? prefixColor,
      double? height,
      double? width,
      double? fontSize,
      Gradient? borderGradient, // ✅ NEW: Gradient for the border
    }) {
  final double buttonRadius = radius ?? 40;
  final double borderWidth = 2.0;
  return Center(
    child: Container(
      height: height ?? 50,
      width: width ?? MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        gradient: borderGradient ?? GradientColor.gradient1, // ✅ Border gradient
        borderRadius: BorderRadius.circular(buttonRadius),
      ),
      padding: EdgeInsets.all(borderWidth), // Border thickness
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius - borderWidth),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: color == null ? GradientColor.gradient1 : null,
            color: color,
            borderRadius: BorderRadius.circular(buttonRadius - borderWidth),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefixIcon != null)
                  Icon(prefixIcon, color: prefixColor),
                if (isLoading==true) CircularProgressIndicator(color: txtColor??ColorResources.whiteColor) else Text(
                  buttonText,
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                    letterSpacing: 1,
                    color: txtColor ?? ColorResources.whiteColor,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize ?? 19,
                  ),
                ),
                if (icon.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Image.asset(
                      icon,
                      color: iconColor ?? ColorResources.whiteColor,
                      height: iconSize ?? 14,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


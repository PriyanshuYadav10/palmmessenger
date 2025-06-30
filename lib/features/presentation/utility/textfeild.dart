import 'package:flutter/material.dart';

import '../../../config/theme/app_themes.dart';
import '../../../config/theme/textstyles.dart';


Widget buildTextWithBorderField(
  TextEditingController controller,
  String hintText,
  double width,
  double height,
  TextInputType keyboardType, {
  Widget? postfixIcon,
  Function? fun,
  var inputFormatters,
  bool isObsecure = false,
  bool ishint = false,
  Widget? prefixIcon,
  bool isEnabled = true,
  int maxLine = 1,
  var align,
  Color? boxColor,
  Color? txtColor,
  int? textLenght,
  TextStyle? txtStyle,
  bool uppercase = false,
  bool readData = false,
}) {
  return Container(
    //Type TextField
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: boxColor ?? Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      border: Border.all(color: ColorResources.blackColor),
    ),
    child: TextField(
        inputFormatters: inputFormatters,
        maxLength: textLenght,
        textAlign: align ?? TextAlign.start,
        readOnly: readData,
        textCapitalization: TextCapitalization.none,
        enabled: isEnabled,
        controller: controller,
        obscuringCharacter: '*',
        obscureText: isObsecure,
        maxLines: maxLine,
        onChanged: (text) {
          fun;
        },
        keyboardType: keyboardType,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          counterText: '',
          suffixIcon: postfixIcon,
          prefixIcon: prefixIcon,
          contentPadding: ishint == true
              ? const EdgeInsets.all(5.0)
              : const EdgeInsets.all(5.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          hintText: hintText,// pass the hint text parameter here
          hintStyle: Styles.mediumTextStyle(
                size: 14, color: txtColor ?? ColorResources.whiteColor),
        ),
        style: txtStyle ??
            Styles.mediumTextStyle(
                size: 14, color: txtColor ?? ColorResources.whiteColor)),
  );
}


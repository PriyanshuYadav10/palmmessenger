import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/theme/app_themes.dart';
import '../../../config/theme/textstyles.dart';
import '../utility/global.dart';

Widget buildTextField(
  TextEditingController controller,
  String hintText,
  double width,
  double height,
  TextInputType keyboardType, {
  Widget? postfixIcon,
  Function? fun,
  String? errorText,
  String? inputFormatters,
  bool isObsecure = false,
  bool ishint = false,
  Widget? prefixIcon,
  bool isEnabled = true,
  int maxLine = 1,
  double radius = 8,
  var align,
  FocusNode? focusNode,
  Color? boxColor,
  Color? txtColor,
  int? textLenght,
  TextStyle? txtStyle,
  bool uppercase = false,
  bool readData = false,
  bool showgradient = false,
}) {
  print(inputFormatters);
  return SizedBox(
    //Type TextField
    width: width,
    height:  height,

    child: TextField(
        focusNode: focusNode,
        inputFormatters: inputFormatters == 'text'
            ? [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))]
            : inputFormatters == 'number'
                ? [FilteringTextInputFormatter.digitsOnly]
                : inputFormatters == 'restricted0'
                    ? [
                        FilteringTextInputFormatter
                            .digitsOnly, // Only allow digits
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final text = newValue.text;
                          // Prevent entering just a single "0"
                          if (text == "0") {
                            return oldValue;
                          }
                          return newValue;
                        }),
                      ]
                    : null,
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
          if (fun != null) fun.call(text);
          print('text-->$text');
        },
        keyboardType: keyboardType,
        decoration: InputDecoration(
          // labelText: !ishint ? hintText : null,
          fillColor: boxColor ?? Colors.transparent,
          filled: true,
          counterText: '',
          suffixIcon: postfixIcon,
          prefixIcon: prefixIcon,
          contentPadding: const EdgeInsets.only(left: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(
                width: 2,
                color:  ColorResources.secondaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(
                width: 2,color:  ColorResources.secondaryColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(
              width: 2,
                color: ColorResources.secondaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(
                width: 2,
                color: ColorResources.secondaryColor),
          ),
          hintText:  hintText,
          errorText: errorText,
          hintStyle:Styles.semiBoldTextStyle(
            size: 16,
            color:txtColor ?? (appTheme.toString().toLowerCase()!='dark'?ColorResources.blackColor: ColorResources.whiteColor.withOpacity(0.8))
          ),
          labelStyle: txtStyle ??
              Styles.mediumTextStyle(
                  size: 16, color: txtColor ?? (appTheme.toString().toLowerCase()!='dark'?ColorResources.blackColor:ColorResources.whiteColor)),
        ),
        style: txtStyle ??
            Styles.mediumTextStyle(
                size: 16, color: txtColor ?? (appTheme.toString().toLowerCase()!='dark'?ColorResources.blackColor:ColorResources.whiteColor))),
  );
}

Widget searchTextField(
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
      borderRadius: const BorderRadius.all(Radius.circular(0)),
      // border: Border.all(color: ColorResources.borderColor),
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
          fun?.call();
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
              : const EdgeInsets.all(15.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          hintText: hintText,
          // pass the hint text parameter here
          hintStyle: TextStyle(
            color: txtColor ?? ColorResources.blackColor.withOpacity(0.8),
            fontWeight: FontWeight.w400,
          ),
        ),
        style: txtStyle ??
            Styles.mediumTextStyle(
                size: 14, color: txtColor ?? ColorResources.blackColor)),
  );
}

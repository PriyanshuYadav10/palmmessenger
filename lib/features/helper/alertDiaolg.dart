// import 'package:flutter/material.dart';
// import 'package:locumlinks/config/theme/app_themes.dart';
// import 'package:locumlinks/config/theme/textstyles.dart';
//
// showAlertSuccess(
//     String message,
//     BuildContext context,
//     ) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     content: Text(message,textAlign: TextAlign.center,style: Styles.boldTextStyle(size: 15,color: ColorResources.whiteColor),),
//     backgroundColor: ColorResources.appColor,
//   ));
// }
//
// showAlertError(
//     String message,
//     BuildContext context,
//     ) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     content: Text(message,textAlign: TextAlign.center,style: Styles.boldTextStyle(size: 15,color: ColorResources.whiteColor),),
//     backgroundColor: Colors.red,
//   ));
// }

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import '../../config/theme/app_themes.dart';

void showAlertSuccess(String message, BuildContext context) {
  showToast(
    message,
    radius: 5,
    textPadding: EdgeInsets.all(15),
    duration: const Duration(seconds: 2),
    position: ToastPosition.top,
    backgroundColor: ColorResources.secondaryColor,
    textStyle: TextStyle(
      fontSize: 15,
      color: ColorResources.whiteColor,
      fontWeight: FontWeight.bold,
    ),
  );
}

void showAlertError(String message, BuildContext context) {
  showToast(
    message,
    radius: 5,
    textPadding: EdgeInsets.all(15),
    duration: const Duration(seconds: 2),
    position: ToastPosition.top,
    backgroundColor: Colors.red,
    textStyle: TextStyle(
      fontSize: 15,
      color: ColorResources.whiteColor,
      fontWeight: FontWeight.bold,
    ),
  );
}
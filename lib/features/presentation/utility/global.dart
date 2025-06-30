import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/theme/app_themes.dart';
import '../../../config/theme/spaces.dart';
import '../../../config/theme/textstyles.dart';
import '../widgets/button.dart';

bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

var appTheme;
bool validateTextField(TextEditingController controller) {
  print(controller.text.toString());
  if (controller.text.isEmpty) {
    print(controller.text.toString());
    return false; // Field is invalid
  }



  return true; // Field is valid
}
var accessToken ='';
Future<void> showLogoutDialog(
    BuildContext context, String message, Function fun) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              height: 110,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorResources.whiteColor,
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    message,
                    style: Styles.mediumTextStyle(
                        size: 14, color: ColorResources.blackColor),
                  ),
                  hSpace(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customButton(() {
                        fun("success");
                        // Navigator.of(context).pop();
                      },
                          "Yes",
                          context,
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.65 / 2,
                        ),
                      wSpace(10),
                      customButton(() {
                        Navigator.of(context).pop();
                      },
                          "No",
                          context,
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.65 / 2,
                          ),

                    ],
                  ),

                ],
              ),
            ),
          );
        },
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: anim1,
          curve: Curves.linear,
        )),
        child: child,
      );
    },
  );
}

Future<void> showPaymentDialog(
    BuildContext context, String message, VoidCallback  fun,VoidCallback  fun2) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorResources.whiteColor,
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    message,
                    style: Styles.mediumTextStyle(
                        size: 15, color: ColorResources.blackColor),
                  ),
                  hSpace(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customButton(() {
                        fun();
                      },
                          "नहीं",
                          context,
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.65 / 2,
                          color: ColorResources.secondaryColor),
                      wSpace(10),
                      customButton(() {
                        fun2();
                        // Navigator.of(context).pop();
                       // showPaymentMode(context, "", (){});
                      },
                          "हाँ",
                          context,
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.65 / 2,
                          color: ColorResources.secondaryColor),

                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },

    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: anim1,
          curve: Curves.linear,
        )),
        child: child,
      );
    },
  );
}

Future<void> showImagePicker(
    BuildContext context, Function(XFile?) onImagePicked) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              height: 155,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorResources.whiteColor,
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customButton(() async {
                    Navigator.of(context).pop();
                    final ImagePicker _picker = ImagePicker();
                    XFile? pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                    onImagePicked(pickedFile);
                  }, 'कैमरा',  context,
                      height: 50,
                      color: ColorResources.appColor.withOpacity(0.2),
                      txtColor: ColorResources.boxColor),
                  hSpace(20),
                  customButton(() async {
                    Navigator.of(context).pop();
                    final ImagePicker _picker = ImagePicker();
                    XFile? pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                    onImagePicked(pickedFile);
                  }, 'गैलरी',  context,
                      height: 50,
                      color: ColorResources.appColor.withOpacity(0.2),
                      txtColor: ColorResources.boxColor),
                ],
              ),
            ),
          );
        },
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: anim1,
          curve: Curves.linear,
        )),
        child: child,
      );
    },
  );
}

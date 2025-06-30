import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/config/theme/spaces.dart';
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:palmmessenger/core/constants/images.dart';

class LinkedDevicesScreen extends StatelessWidget {
  const LinkedDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: ColorResources.appColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Linked Devices',
          style: Styles.semiBoldTextStyle(
            size: 22,
            color: ColorResources.whiteColor,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorResources.whiteColor,
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(app_bg), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            hSpace(50),
            Image.asset(linked_device, height: 70, width: 70),
            hSpace(20),
            Text(
              "You can link other devices",
              style: TextStyle(color: Color(0xFF87B5E2)),
            ),
            Text("to this account", style: TextStyle(color: Color(0xFF87B5E2))),
            hSpace(50),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorResources.thirdColor,
                    ColorResources.appPurpleColor,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Buy any plan to link device',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            hSpace(50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your personal messages are ",
                  style: TextStyle(color: Color(0xFF87B5E2)),
                ),
                Text(
                  "end-to-end",
                  style: TextStyle(color: ColorResources.txtLightColor),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "encrypted ",
                  style: TextStyle(color: ColorResources.thirdColor),
                ),
                Text(
                  "on all your devices",
                  style: TextStyle(color: Color(0xFF87B5E2)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

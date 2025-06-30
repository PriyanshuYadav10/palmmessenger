import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:palmmessenger/core/constants/images.dart';
import 'package:palmmessenger/features/presentation/widgets/build_switch_tile.dart';
import 'package:palmmessenger/features/presentation/widgets/build_tile.dart';
import 'package:palmmessenger/features/presentation/widgets/section_tile.dart';

class PrivacyAndSecurityScreen extends StatefulWidget {
  const PrivacyAndSecurityScreen({super.key});

  @override
  State<PrivacyAndSecurityScreen> createState() =>
      _PrivacyAndSecurityScreenState();
}

class _PrivacyAndSecurityScreenState extends State<PrivacyAndSecurityScreen> {
  bool roadReciepts = false;
  bool messageTimer = false;
  bool cameraEffects = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: ColorResources.appColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Privacy and security',
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
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(app_bg),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    child: sectionTitle("Who can see my personal info"),
                  ),
                  buildTile("Last seen and online", "Everyone"),
                  buildTile("Profile photo", "my contacts"),
                  buildTile("Status", "2 contacts excluded"),
                  buildSwitchTile(
                    title: "Road receipts",
                    subtitle:
                        "If turned off,you won't send or recieve road reciepts.read reciepts are always sent for group chats",
                    value: roadReciepts,
                    onChanged: (val) => setState(() => roadReciepts = val),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    child: sectionTitle("Disappearing messages"),
                  ),
                  buildSwitchTile(
                    title: "Default message timer",
                    subtitle:
                        "Starts new chat with disappearing messages set to your timer",
                    value: messageTimer,
                    onChanged: (val) => setState(() => messageTimer = val),
                  ),
                  buildTile("Groups", "My contacts"),
                  buildTile("Calls", "Silence unknoown callers"),
                  buildTile("Blocked contacts", "100"),
                  buildTile("Applock", "Disabled"),
                  buildTile("Live location", ""),
                  buildSwitchTile(
                    title: "Allow camera effects",
                    subtitle: "Use effects in the camera and video calls",
                    value: cameraEffects,
                    onChanged: (val) => setState(() => cameraEffects = val),
                  ),
                  buildTile(
                    "Advanced",
                    "protect IP address in the calls,Disable\nlink previews",
                  ),
                  buildTile(
                    "Privacy checkup",
                    "Control your privacy and choose the\nright settings for you",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

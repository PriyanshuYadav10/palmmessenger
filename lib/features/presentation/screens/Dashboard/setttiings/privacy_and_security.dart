import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:palmmessenger/core/constants/images.dart';
import 'package:palmmessenger/features/presentation/widgets/build_switch_tile.dart';
import 'package:palmmessenger/features/presentation/widgets/section_tile.dart';
import 'package:provider/provider.dart';

import '../../../../provider/settingProvider.dart';
import '../../../utility/global.dart';
import '../../../widgets/build_tile.dart';

class PrivacyAndSecurityScreen extends StatefulWidget {
  const PrivacyAndSecurityScreen({super.key});

  @override
  State<PrivacyAndSecurityScreen> createState() =>
      _PrivacyAndSecurityScreenState();
}

class _PrivacyAndSecurityScreenState extends State<PrivacyAndSecurityScreen> {
  bool readReciepts = false;
  bool appLock = false;
  bool messageTimer = false;
  bool cameraEffects = false;

  // Dropdown values
  String lastSeen = "Everyone";
  String profilePhoto = "My contacts";
  String status = "Everyone";
  String groups = "My contacts";
  String calls = "Everyone";

  final List<String> privacyOptions = [
    "My contacts",
    "Nobody",
    "Everyone",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final settingsProvider = Provider.of<Settingsprovider>(
        context, listen: false);
    lastSeen =
        settingsProvider.settingsModel?.privacy?.lastSeen=='nobody'?"Nobody": settingsProvider.settingsModel?.privacy?.lastSeen=='contacts'?'My contacts':'Everyone';
    profilePhoto =
    settingsProvider.settingsModel?.privacy?.profilePhoto=='nobody'?"Nobody": settingsProvider.settingsModel?.privacy?.profilePhoto=='contacts'?'My contacts':'Everyone';

    readReciepts =
        settingsProvider.settingsModel?.privacy?.readReceipts ?? false;
    appLock = settingsProvider.settingsModel?.privacy?.appLock ?? false;
  }
  Widget buildDropdownTile(String title, String value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style:  TextStyle(
                  color: appTheme.toString().toLowerCase()!='dark'?ColorResources.appColor:ColorResources.whiteColor,
                  fontSize: 16,
                ),
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: appTheme.toString().toLowerCase()!='dark'?ColorResources.whiteColor:ColorResources.appColor,
                value: value,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                style: Styles.semiBoldTextStyle(
                  size: 14,
                  color: appTheme.toString().toLowerCase()!='dark'?ColorResources.appColor:ColorResources.whiteColor,
                ),
                onChanged: onChanged,
                items: privacyOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option,
                        style: Styles.semiBoldTextStyle(
                            color: appTheme.toString().toLowerCase()!='dark'?ColorResources.appColor:ColorResources.whiteColor)),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<Settingsprovider>(context, listen: false);
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
          height: MediaQuery.sizeOf(context).height,
          decoration:appTheme.toString().toLowerCase()=='dark'? BoxDecoration(
              image: DecorationImage(image: AssetImage(app_bg),fit: BoxFit.cover)
          ):BoxDecoration(
              color: ColorResources.whiteColor
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Who can see my info
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 5),
                    child: sectionTitle("Who can see my personal info"),
                  ),
                  buildDropdownTile("Last seen and online", lastSeen,
                          (val) { setState(() {
                            lastSeen = val!;
                            settingsProvider.updatePrivacySettings({
                              "lastSeen": lastSeen=='Nobody'?"nobody": lastSeen=='My contacts'?'contacts':'everyone',
                              "online": lastSeen=='Nobody'?"nobody": lastSeen=='My contacts'?'contacts':'everyone',
                              "profilePhoto": profilePhoto=='Nobody'?"nobody": lastSeen=='My contacts'?'contacts':'everyone',
                              "readReceipts":readReciepts,
                              "appLock":appLock,
                            });});}),
                  buildDropdownTile("Profile photo", profilePhoto,
                          (val) { setState(() {
                        profilePhoto = val!;
                        settingsProvider.updatePrivacySettings({
                          "lastSeen": lastSeen=='Nobody'?"nobody": lastSeen=='My contacts'?'contacts':'everyone',
                          "online": lastSeen=='Nobody'?"nobody": lastSeen=='My contacts'?'contacts':'everyone',
                          "profilePhoto": profilePhoto=='Nobody'?"nobody": lastSeen=='My contacts'?'contacts':'everyone',
                          "readReceipts":readReciepts,
                          "appLock":appLock,
                        });});}),
                  buildSwitchTile(
                    title: "Read receipts",
                    subtitle:
                    "If turned off, you won't send or receive read receipts. Read receipts are always sent for group chats.",
                    value: readReciepts,
                    onChanged: (val) { setState(() {
                      readReciepts = val;
                      settingsProvider.updatePrivacySettings({
                        "lastSeen": lastSeen=='Nobody'?"nobody": lastSeen=='My contacts'?'contacts':'everyone',
                        "online": lastSeen=='Nobody'?"nobody": lastSeen=='My contacts'?'contacts':'everyone',
                        "profilePhoto": profilePhoto=='Nobody'?"nobody": lastSeen=='My contacts'?'contacts':'everyone',
                        "readReceipts":readReciepts,
                        "appLock":appLock,
                      });
                    });}
                  ),

                  // Disappearing messages
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10, left: 5),
                  //   child: sectionTitle("Disappearing messages"),
                  // ),
                  // buildSwitchTile(
                  //   title: "Default message timer",
                  //   subtitle:
                  //   "Starts new chat with disappearing messages set to your timer",
                  //   value: messageTimer,
                  //   onChanged: (val) => setState(() => messageTimer = val),
                  // ),

                  // buildDropdownTile("Groups", groups,
                  //         (val) => setState(() => groups = val!)),
                  // buildDropdownTile("Calls", calls,
                  //         (val) => setState(() => calls = val!)),

                  // The rest remain normal
                  buildTile("Blocked contacts", "100"),
                  buildSwitchTile(
                      title: "App lock",
                      value: appLock,
                      onChanged: (val) { setState(() {
                        appLock = val;
                        settingsProvider.updatePrivacySettings({
                          "lastSeen": lastSeen=='Nobody'?"nobody": lastSeen=='My contacts'?'contacts':'everyone',
                          "online": lastSeen=='Nobody'?"nobody": lastSeen=='My contacts'?'contacts':'everyone',
                          "profilePhoto": profilePhoto=='Nobody'?"nobody": lastSeen=='My contacts'?'contacts':'everyone',
                          "readReceipts":readReciepts,
                          "appLock":appLock,
                        });
                      });}
                  ),
                  // buildTile("Live location", ""),
                  // buildSwitchTile(
                  //   title: "Allow camera effects",
                  //   subtitle: "Use effects in the camera and video calls",
                  //   value: cameraEffects,
                  //   onChanged: (val) => setState(() => cameraEffects = val),
                  // ),
                  // buildTile(
                  //   "Advanced",
                  //   "protect IP address in the calls, Disable\nlink previews",
                  // ),
                  // buildTile(
                  //   "Privacy checkup",
                  //   "Control your privacy and choose the\nright settings for you",
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

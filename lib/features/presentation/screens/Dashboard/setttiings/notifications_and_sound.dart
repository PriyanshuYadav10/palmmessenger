import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/app_themes.dart' show ColorResources;
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:palmmessenger/core/constants/images.dart';
import 'package:palmmessenger/features/presentation/widgets/build_switch_tile.dart';
import 'package:palmmessenger/features/presentation/widgets/build_tile.dart';
import 'package:palmmessenger/features/presentation/widgets/section_tile.dart';

class NotificationAndSoundScreen extends StatefulWidget {
  const NotificationAndSoundScreen({super.key});

  @override
  State<NotificationAndSoundScreen> createState() =>
      _NotificationAndSoundScreenState();
}

class _NotificationAndSoundScreenState
    extends State<NotificationAndSoundScreen> {
  bool conversationTones = true;
  bool reminders = true;
  bool highPriorityMessages = true;
  bool reactionMessages = true;
  bool highPriorityGroups = false;
  bool reactionGroups = false;
  bool statusReactions = true;
  bool homeScreenCount = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: ColorResources.appColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Notifications and sound',
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
              padding: const EdgeInsets.only(top: 15, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSwitchTile(
                    title: "Conversation tones",
                    subtitle: "Play sounds for incoming and outgoing messages",
                    value: conversationTones,
                    onChanged: (val) => setState(() => conversationTones = val),
                  ),
                  buildSwitchTile(
                    title: "Reminders",
                    subtitle:
                        "Get occasional reminders about messages, calls or status updates you haven’t seen",
                    value: reminders,
                    onChanged: (val) => setState(() => reminders = val),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    child: sectionTitle("Messages"),
                  ),

                  buildTile("Notification tone", ""),
                  buildTile("Vibrate", "Default"),
                  buildTile("Light", "White"),
                  buildSwitchTile(
                    title: "Use high priority notifications",
                    subtitle:
                        "Show previews of notifications at the top of the screen",
                    value: highPriorityMessages,
                    onChanged:
                        (val) => setState(() => highPriorityMessages = val),
                  ),
                  buildSwitchTile(
                    title: "Reaction notifications",
                    subtitle:
                        "Show notifications for reactions to messages you send",
                    value: reactionMessages,
                    onChanged: (val) => setState(() => reactionMessages = val),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    child: sectionTitle("Calls"),
                  ),
                  buildTile("Ringtone", "Default"),
                  buildTile("Vibrate", "Off"),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    child: sectionTitle("status"),
                  ),
                  buildSwitchTile(
                    title: "Reactions",
                    subtitle:
                        "Show notifications when you get likes on a status",
                    value: reactionGroups,
                    onChanged: (val) => setState(() => reactionGroups = val),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    child: sectionTitle("Home screen notifications"),
                  ),
                  buildSwitchTile(
                    title: "Clear count",
                    subtitle:
                        "Your home screen badge clears completely after time you open the app",
                    value: homeScreenCount,
                    onChanged: (val) => setState(() => homeScreenCount = val),
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/app_themes.dart' show ColorResources;
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:palmmessenger/core/constants/images.dart';
import 'package:palmmessenger/features/data/model/notification_setting_model.dart';
import 'package:palmmessenger/features/presentation/widgets/build_switch_tile.dart';
import 'package:palmmessenger/features/presentation/widgets/build_tile.dart';
import 'package:palmmessenger/features/presentation/widgets/section_tile.dart';
import 'package:palmmessenger/features/provider/settingProvider.dart';
import 'package:provider/provider.dart';

class NotificationAndSoundScreen extends StatefulWidget {
  const NotificationAndSoundScreen({super.key});

  @override
  State<NotificationAndSoundScreen> createState() =>
      _NotificationAndSoundScreenState();
}

class _NotificationAndSoundScreenState
    extends State<NotificationAndSoundScreen> {
  bool conversationTones = false;
  bool reminders = false;
  bool highPriorityMessages = false;
  bool highPriorityGroupMessages = false;
  bool reactionMessages = false;
  bool highPriorityGroups = false;
  bool reactionGroups = false;
  bool statusReactions = false;
  bool homeScreenCount = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final settingsProvider = Provider.of<Settingsprovider>(context, listen: false);
    conversationTones = settingsProvider.settingsModel?.notifications?.conversationTone??false;
    reminders = settingsProvider.settingsModel?.notifications?.reminder??false;
    highPriorityMessages = settingsProvider.settingsModel?.notifications?.messages?.highPriorityNotification??false;
    highPriorityGroupMessages = settingsProvider.settingsModel?.notifications?.groups?.highPriorityNotification??false;
    reactionMessages = settingsProvider.settingsModel?.notifications?.messages?.reactionNotification??false;
    reactionGroups = settingsProvider.settingsModel?.notifications?.groups?.reactionNotification??false;
    homeScreenCount = settingsProvider.settingsModel?.notifications?.clearCount??false;

  }
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<Settingsprovider>(
      context,
      listen: false,
    );
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
                      onChanged: (val) { setState(() => conversationTones = val);
                        settingsProvider.updateNotificationSettings(
                         {
                           "conversationTone": conversationTones,
                         }
                        );
                      }
                  ),
                  buildSwitchTile(
                    title: "Reminders",
                    subtitle:
                    "Get occasional reminders about messages, calls or status updates you haven’t seen",
                    value: reminders,
                      onChanged: (val) { setState(() => reminders = val);
                  settingsProvider.updateNotificationSettings(
                      {
                        "reminder":reminders
                      }
                  );
                  }
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    child: sectionTitle("Messages"),
                  ),

                  // buildTile("Notification tone", ""),
                  buildTile("Vibrate", "Default"),
                  // buildTile("Light", "White"),
                  buildSwitchTile(
                    title: "Use high priority notifications",
                    subtitle:
                    "Show previews of notifications at the top of the screen",
                    value: highPriorityMessages,
                      onChanged: (val) { setState(() => highPriorityMessages = val);
                      settingsProvider.updateNotificationSettings(
                          {
                            "messages":{
                              "highPriorityNotification":highPriorityMessages,
                              "reactionNotification":reactionMessages,
                            }
                          }
                      );
                      },
                  ),
                  buildSwitchTile(
                    title: "Reaction notifications",
                    subtitle:
                    "Show notifications for reactions to messages you send",
                    value: reactionMessages,

                      onChanged: (val) { setState(() => highPriorityMessages = val);
                      settingsProvider.updateNotificationSettings(
                          {
                            "messages":{
                              "highPriorityNotification":highPriorityMessages,
                              "reactionNotification":reactionMessages,
                            }
                          }
                      );
                      }
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    child: sectionTitle("Groups"),
                  ),
                  buildTile("Vibrate", "Off"),
                  buildSwitchTile(
                    title: "Use high priority notifications",
                    subtitle:
                    "Show previews of notifications for groups at the top of the screen",
                    value: highPriorityGroupMessages,

                      onChanged: (val) { setState(() => highPriorityGroupMessages = val);
                      settingsProvider.updateNotificationSettings(
                          {
                            "groups":{
                              "highPriorityNotification":highPriorityGroupMessages,
                              "reactionNotification":reactionGroups,
                            }
                          }
                      );
                      }
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10, left: 15),
                  //   child: sectionTitle("status"),
                  // ),
                  // buildSwitchTile(
                  //   title: "Reactions",
                  //   subtitle:
                  //       "Show notifications when you get likes on a status",
                  //   value: reactionGroups,
                  //   onChanged: (val) => setState(() => reactionGroups = val),
                  // ),
                  buildSwitchTile(
                    title: "Reaction notifications",
                    subtitle:
                    "Show notifications for reactions to messages you send in groups",
                    value: reactionGroups,

                      onChanged: (val) { setState(() => highPriorityGroupMessages = val);
                      settingsProvider.updateNotificationSettings(
                          {
                            "groups":{
                              "highPriorityNotification":highPriorityGroupMessages,
                              "reactionNotification":reactionGroups,
                            }
                          }
                      );
                      }
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
                    onChanged: (val) {

                    setState(() { homeScreenCount = val;
                    settingsProvider.updateNotificationSettings(
                        {
                          "clearCount":homeScreenCount
                        });});
                    }
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
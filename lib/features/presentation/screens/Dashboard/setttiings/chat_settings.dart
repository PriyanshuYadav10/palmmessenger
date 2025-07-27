import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/config/theme/spaces.dart';
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:palmmessenger/core/constants/images.dart';
import 'package:palmmessenger/features/presentation/widgets/build_switch_tile.dart';
import 'package:palmmessenger/features/presentation/widgets/build_tile.dart';
import 'package:palmmessenger/features/presentation/widgets/section_tile.dart';

class ChatSettingsScreen extends StatefulWidget {
  const ChatSettingsScreen({super.key});

  @override
  State<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen> {
  bool enterSend = false;
  bool playAnimatedImages = false;
  bool mediaVisibility = false;
  bool voiceTranscript = false;
  bool chatsArchive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: ColorResources.appColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Chats',
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
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(app_bg), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("Display"),
                  ListTile(
                    leading: Icon(
                      Icons.brightness_6_sharp,
                      color: ColorResources.whiteColor,
                    ),
                    title: Text(
                      "Theme",
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorResources.whiteColor,
                      ),
                    ),
                    subtitle: Text(
                      "Dark",
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorResources.subTitleColor,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.color_lens,
                      color: ColorResources.whiteColor,
                    ),
                    title: Text(
                      "Default chat theme",
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorResources.whiteColor,
                      ),
                    ),
                  ),
                  sectionTitle("Chat settings"),
                  buildSwitchTile(
                    title: "Enter is send",
                    subtitle: "Enter key will send your message",
                    value: enterSend,
                    onChanged: (val) => setState(() => enterSend = val),
                  ),
                  buildSwitchTile(
                    title: "Autoplay animated images",
                    subtitle: "Make emojis,stickers and avatars\nmove",
                    value: playAnimatedImages,
                    onChanged:
                        (val) => setState(() => playAnimatedImages = val),
                  ),
                  buildSwitchTile(
                    title: "Media visibility",
                    subtitle:
                        "Show newly downloaded media in\nyour devices gallery",
                    value: mediaVisibility,
                    onChanged: (val) => setState(() => mediaVisibility = val),
                  ),
                  buildTile("Fontsize", "Small"),
                  buildSwitchTile(
                    title: "Voice messages transcript",
                    subtitle: "Read new voice messages",
                    value: voiceTranscript,
                    onChanged: (val) => setState(() => voiceTranscript = val),
                  ),
                  sectionTitle("Archived chats"),
                  buildSwitchTile(
                    title: "Keep chats archived",
                    subtitle:
                        "Archived chats will remain\narchived when you recieve a new\nmessage",
                    value: chatsArchive,
                    onChanged: (val) => setState(() => chatsArchive = val),
                  ),
                  hSpace(20),
                  Row(
                    children: [
                      Icon(
                        Icons.backup_outlined,
                        color: ColorResources.txtColor,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Chat backup",
                        style: TextStyle(
                          color: ColorResources.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  hSpace(10),
                  Row(
                    children: [
                      Icon(
                        Icons.content_paste_go_outlined,
                        color: ColorResources.txtColor,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Transfer chats",
                        style: TextStyle(
                          color: ColorResources.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  hSpace(10),
                  Row(
                    children: [
                      Icon(Icons.history, color: ColorResources.txtColor),
                      SizedBox(width: 5),
                      Text(
                        "Chat history",
                        style: TextStyle(
                          color: ColorResources.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
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

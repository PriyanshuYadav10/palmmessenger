import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/config/theme/spaces.dart';
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:palmmessenger/core/constants/images.dart';
import 'package:palmmessenger/features/presentation/widgets/build_switch_tile.dart';
import 'package:palmmessenger/features/presentation/widgets/section_tile.dart';
import 'package:palmmessenger/features/provider/settingProvider.dart';
import 'package:provider/provider.dart';

class ChatSettingsScreen extends StatefulWidget {
  const ChatSettingsScreen({super.key});

  @override
  State<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen> {
  String selectedFontsize = "Medium";
  bool enterSend = false;
  bool playAnimatedImages = false;
  bool mediaVisibility = false;
  bool voiceTranscript = false;
  bool chatsArchive = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final settingsProvider = Provider.of<Settingsprovider>(context, listen: false);
    settingsProvider.setTheme( settingsProvider.settingsModel?.chat?.theme?.capitalizeFirst.toString()??'Dark');
    selectedFontsize = settingsProvider.settingsModel?.chat?.fontSize?.capitalizeFirst.toString()??'Medium';
    enterSend = settingsProvider.settingsModel?.chat?.enterIsSend??false;
    playAnimatedImages = settingsProvider.settingsModel?.chat?.autoPlayAnimatedImages??false;
    mediaVisibility = settingsProvider.settingsModel?.chat?.mediaVisibility??false;
    voiceTranscript = settingsProvider.settingsModel?.chat?.voiceMessagesTranscript??false;
    chatsArchive = settingsProvider.settingsModel?.chat?.archiveChats??false;
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
                  buildCustomDropdownTile(
                    title: "Theme",
                    selectedValue: settingsProvider.theme,
                    options: ["Light", "Dark", "System"],
                    leadingIcon: Icons.brightness_6,
                    onChanged: (val) {
                      setState(() {
                        settingsProvider.setTheme(val!);
                      });
                      settingsProvider.setTheme(settingsProvider.theme.toLowerCase()); // ✅ update app theme
                      settingsProvider.updateChatSettings({
                        "theme": settingsProvider.theme.toLowerCase(),
                        "enterIsSend": enterSend,
                        "autoPlayAnimatedImages": playAnimatedImages,
                        "mediaVisibility": mediaVisibility,
                        "fontSize": selectedFontsize.toLowerCase(),
                        "voiceMessagesTranscript": voiceTranscript,
                        "archiveChats": chatsArchive,
                      });
                    },
                  ),
                  // ListTile(
                  //   leading: Icon(
                  //     Icons.brightness_6_sharp,
                  //     color: ColorResources.whiteColor,
                  //   ),
                  //   title: Text(
                  //     "Theme",
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       color: ColorResources.whiteColor,
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     "Dark",
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       color: ColorResources.subTitleColor,
                  //     ),
                  //   ),
                  // ),
                  // ListTile(
                  //   leading: Icon(
                  //     Icons.color_lens,
                  //     color: ColorResources.whiteColor,
                  //   ),
                  //   title: Text(
                  //     "Default chat theme",
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       color: ColorResources.whiteColor,
                  //     ),
                  //   ),
                  // ),
                  sectionTitle("Chat settings"),
                  buildSwitchTile(
                    title: "Enter is send",
                    subtitle: "Enter key will send your message",
                    value: enterSend,
                    onChanged: (val) {
                      setState(() {
                        enterSend = val;
                      });
                      settingsProvider.updateChatSettings({
                        "theme": settingsProvider.theme.toLowerCase(),
                        "enterIsSend": enterSend,
                        "autoPlayAnimatedImages": playAnimatedImages,
                        "mediaVisibility": mediaVisibility,
                        "fontSize": selectedFontsize.toLowerCase(),
                        "voiceMessagesTranscript": voiceTranscript,
                        "archiveChats": chatsArchive,
                      });
                    },
                  ),
                  buildSwitchTile(
                    title: "Autoplay animated images",
                    subtitle: "Make emojis,stickers and avatars\nmove",
                    value: playAnimatedImages,
                    onChanged: (val) {
                      setState(() {
                        playAnimatedImages = val;
                      });
                      settingsProvider.updateChatSettings({
                        "theme": settingsProvider.theme.toLowerCase(),
                        "enterIsSend": enterSend,
                        "autoPlayAnimatedImages": playAnimatedImages,
                        "mediaVisibility": mediaVisibility,
                        "fontSize": selectedFontsize.toLowerCase(),
                        "voiceMessagesTranscript": voiceTranscript,
                        "archiveChats": chatsArchive,
                      });
                    },
                  ),
                  buildSwitchTile(
                    title: "Media visibility",
                    subtitle:
                    "Show newly downloaded media in\nyour devices gallery",
                    value: mediaVisibility,
                    onChanged: (val) {
                      setState(() {
                        mediaVisibility = val;
                      });
                      settingsProvider.updateChatSettings({
                        "theme": settingsProvider.theme.toLowerCase(),
                        "enterIsSend": enterSend,
                        "autoPlayAnimatedImages": playAnimatedImages,
                        "mediaVisibility": mediaVisibility,
                        "fontSize": selectedFontsize.toLowerCase(),
                        "voiceMessagesTranscript": voiceTranscript,
                        "archiveChats": chatsArchive,
                      });
                    },
                  ),
                  buildCustomDropdownTile(
                    title: "Fontsize",
                    selectedValue: selectedFontsize,
                    options: ["Small", "Medium", "Large"],
                    onChanged: (val) {
                      setState(() {
                        selectedFontsize = val!;
                      });
                      settingsProvider.updateChatSettings({
                        "theme": settingsProvider.theme.toLowerCase(),
                        "enterIsSend": enterSend,
                        "autoPlayAnimatedImages": playAnimatedImages,
                        "mediaVisibility": mediaVisibility,
                        "fontSize": selectedFontsize.toLowerCase(),
                        "voiceMessagesTranscript": voiceTranscript,
                        "archiveChats": chatsArchive,
                      });
                    },
                  ),
                  buildSwitchTile(
                    title: "Voice messages transcript",
                    subtitle: "Read new voice messages",
                    value: voiceTranscript,
                    onChanged: (val) {
                      setState(() {
                        voiceTranscript = val;
                      });
                      settingsProvider.updateChatSettings({
                        "theme": settingsProvider.theme.toLowerCase(),
                        "enterIsSend": enterSend,
                        "autoPlayAnimatedImages": playAnimatedImages,
                        "mediaVisibility": mediaVisibility,
                        "fontSize": selectedFontsize.toLowerCase(),
                        "voiceMessagesTranscript": voiceTranscript,
                        "archiveChats": chatsArchive,
                      });
                    },
                  ),
                  sectionTitle("Archived chats"),
                  buildSwitchTile(
                    title: "Keep chats archived",
                    subtitle:
                    "Archived chats will remain\narchived when you recieve a new\nmessage",
                    value: chatsArchive,
                    onChanged: (val) {
                      setState(() {
                        chatsArchive = val;
                      });
                      settingsProvider.updateChatSettings({
                        "theme": settingsProvider.theme.toLowerCase(),
                        "enterIsSend": enterSend,
                        "autoPlayAnimatedImages": playAnimatedImages,
                        "mediaVisibility": mediaVisibility,
                        "fontSize": selectedFontsize.toLowerCase(),
                        "voiceMessagesTranscript": voiceTranscript,
                        "archiveChats": chatsArchive,
                      });
                    },
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
                  // Row(
                  //   children: [
                  //     Icon(Icons.video_chat, color: ColorResources.txtColor),
                  //     SizedBox(width: 5),
                  //     Text(
                  //       "Backup Videos",
                  //       style: TextStyle(
                  //         color: ColorResources.whiteColor,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // hSpace(10),
                  // Row(
                  //   children: [
                  //     Icon(Icons.image, color: ColorResources.txtColor),
                  //     SizedBox(width: 5),
                  //     Text(
                  //       "Backup Images",
                  //       style: TextStyle(
                  //         color: ColorResources.whiteColor,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCustomDropdownTile({
    required String title,
    required String selectedValue,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    IconData? leadingIcon, // optional leading icon
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(13),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, color: ColorResources.whiteColor),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: ColorResources.whiteColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedValue, // display selected value like subtitle
                    style: TextStyle(
                      color: ColorResources.subTitleColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: ColorResources.appColor,
                value: selectedValue,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                style: Styles.semiBoldTextStyle(
                  size: 14,
                  color: ColorResources.whiteColor,
                ),
                onChanged: onChanged,
                items: options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: Styles.semiBoldTextStyle(
                        color: ColorResources.whiteColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
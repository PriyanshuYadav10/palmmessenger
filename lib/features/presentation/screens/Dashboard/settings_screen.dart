import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/config/theme/spaces.dart';
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:palmmessenger/core/constants/images.dart';
import 'package:palmmessenger/features/presentation/screens/Dashboard/setttiings/chat_settings.dart';
import 'package:palmmessenger/features/presentation/screens/Dashboard/setttiings/linked_devices.dart';
import 'package:palmmessenger/features/presentation/screens/Dashboard/setttiings/lists.dart';
import 'package:palmmessenger/features/presentation/screens/Dashboard/setttiings/my_account.dart';
import 'package:palmmessenger/features/presentation/screens/Dashboard/setttiings/notifications_and_sound.dart';
import 'package:palmmessenger/features/presentation/screens/Dashboard/setttiings/privacy_and_security.dart';
import 'package:palmmessenger/features/presentation/utility/gradient_text.dart';
import 'package:provider/provider.dart';

import '../../../provider/authProvider.dart';
import 'setttiings/broadcast_message.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<InfoTile> infoTiles = [
    InfoTile(
      imagePath: broadcast,
      title: 'Broadcast messages',
      subtitle: 'Send a message to multiple contacts',
    ),
    InfoTile(
      imagePath: starred,
      title: 'Starred',
      subtitle: 'View important messages',
    ),
    InfoTile(
      imagePath: account,
      title: 'Account',
      subtitle: 'Manage your info',
    ),
    InfoTile(
      imagePath: lists,
      title: 'Lists',
      subtitle: 'Manage people and groups',
    ),
    InfoTile(
      imagePath: privacy_security,
      title: 'Privacy and security',
      subtitle: 'Control visibility, block contacts',
    ),
    InfoTile(imagePath: chats, title: 'Chat', subtitle: 'Chat settings'),
    InfoTile(
      imagePath: notifications_sound,
      title: 'Notifications and sounds',
      subtitle: 'Manage alerts and tones',
    ),
    InfoTile(
      imagePath: linked_device,
      title: 'Linked Devices',
      subtitle: 'Link other devices',
    ),
    InfoTile(
      imagePath: palm_id,
      title: 'Palm ID',
      subtitle: 'Buy and upgrade Palm ID plans',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(profile_circle),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            authProvider
                                        .userProfileDataModel
                                        ?.profile
                                        ?.profilePicture ==
                                    null
                                ? AssetImage(dummyProfile)
                                : NetworkImage(
                                  '${authProvider.userProfileDataModel?.profile?.profilePicture.toString()}',
                                ),
                      ),
                    ),
                    wSpace(15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientText(
                          '${authProvider.userProfileDataModel?.profile?.name.toString()}',
                          style: Styles.semiBoldTextStyle(size: 30),
                        ),
                        hSpace(4),
                        Text(
                          authProvider.userProfileDataModel?.profile?.bio ?? '',
                          style: Styles.mediumTextStyle(
                            color: ColorResources.whiteColor,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    SizedBox(width: 35, child: Image.asset(qr_code)),
                  ],
                ),
                hSpace(15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: infoTiles.length,
                  itemBuilder: (context, index) {
                    final tile = infoTiles[index];
                    return InkWell(
                      onTap: () {
                        if (index == 0) {
                          Get.to(BroadcastMessageScreen());
                        } else if (index == 2) {
                          Get.to(MyAccountScreen());
                        } else if (index == 3) {
                          Get.to(ListScreen());
                        } else if (index == 4) {
                          Get.to(PrivacyAndSecurityScreen());
                        } else if (index == 5) {
                          Get.to(ChatSettingsScreen());
                        } else if (index == 6) {
                          Get.to(NotificationAndSoundScreen());
                        } else if (index == 7) {
                          Get.to(LinkedDevicesScreen());
                        }
                      },
                      child: ListTile(
                        leading: Image.asset(
                          tile.imagePath,
                          width: 25,
                          height: 25,
                          fit: BoxFit.fill,
                          color: ColorResources.whiteColor,
                        ),
                        title: Text(
                          tile.title,
                          style: Styles.semiBoldTextStyle(
                            color: ColorResources.whiteColor,
                            size: 16,
                          ),
                        ),
                        subtitle: Text(
                          tile.subtitle,
                          style: Styles.mediumTextStyle(
                            color: ColorResources.whiteColor,
                            size: 16,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoTile {
  final String imagePath;
  final String title;
  final String subtitle;

  InfoTile({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}

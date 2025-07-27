import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/config/theme/spaces.dart';
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:palmmessenger/core/constants/images.dart';
import 'package:palmmessenger/features/presentation/widgets/build_tile.dart';
import 'package:palmmessenger/features/presentation/widgets/section_tile.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: ColorResources.appColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Lists',
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Any lists you create becomes a\nfilter at the top of your chats tab",
                    style: TextStyle(
                      color: ColorResources.txtColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                hSpace(30),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResources.thirdColor,
                    ),
                    child: Text(
                      "Create a custom list",
                      style: TextStyle(color: ColorResources.fifthColor),
                    ),
                  ),
                ),
                hSpace(40),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: sectionTitle("Your lists"),
                ),
                buildTile("Unread", "Preset"),
                buildTile("Favorites", "Add people or groups"),
                buildTile("Groups", "Preset"),
                ListTile(
                  title: Text(
                    "Communities",
                    style: TextStyle(
                      color: ColorResources.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "Preset",
                    style: TextStyle(
                      color: ColorResources.subTitleColor,
                      fontSize: 14,
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResources.thirdColor,
                      
                    ),
                    child: Text(
                      "Add",
                      style: TextStyle(color: ColorResources.fifthColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

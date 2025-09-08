import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:palmmessenger/core/constants/images.dart';
import 'package:palmmessenger/features/presentation/widgets/custom_list_tile.dart';

import '../../../utility/global.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: ColorResources.appColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Account',
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
        decoration:appTheme.toString().toLowerCase()=='dark'? BoxDecoration(
            image: DecorationImage(image: AssetImage(app_bg),fit: BoxFit.cover)
        ):BoxDecoration(
            color: ColorResources.whiteColor
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              CustomListTile(
                leadingIcon: Icons.security,
                title: "Security Notifications",
                onTap: () {},
              ),
              CustomListTile(
                leadingIcon: Icons.manage_accounts,
                title: "Passkeys",
                onTap: () {},
              ),
              CustomListTile(
                leadingIcon: Icons.email,
                title: "Email address",
                onTap: () {},
              ),
              CustomListTile(
                leadingIcon: Icons.password,
                title: "Two-Step verification",
                onTap: () {},
              ),
              CustomListTile(
                leadingIcon: Icons.content_paste_go_outlined,
                title: "Change Number",
                onTap: () {},
              ),
              CustomListTile(
                leadingIcon: Icons.info_outline,
                title: "Request account info",
                onTap: () {},
              ),
              CustomListTile(
                leadingIcon: Icons.person_add_outlined,
                title: "Add Account",
                onTap: () {},
              ),
              CustomListTile(
                leadingIcon: Icons.delete_outline_outlined,
                title: "Delete Account",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

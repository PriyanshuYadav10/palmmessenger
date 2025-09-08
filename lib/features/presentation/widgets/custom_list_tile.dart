import 'package:flutter/material.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';

import '../utility/global.dart';

class CustomListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final VoidCallback onTap;

  const CustomListTile({
    Key? key,
    required this.leadingIcon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leadingIcon, color: appTheme.toString().toLowerCase()!='dark'?ColorResources.blackColor:ColorResources.whiteColor),
      title: Text(
        title,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500,color: appTheme.toString().toLowerCase()!='dark'?ColorResources.blackColor:ColorResources.whiteColor),
      ),
      onTap: onTap,
    );
  }
}

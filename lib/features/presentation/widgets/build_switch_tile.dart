import 'package:flutter/material.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';

import '../utility/global.dart';

Widget buildSwitchTile({
  required String title,
  String? subtitle,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return SwitchListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 15),
    title: Text(
      title,
      style:  TextStyle(color: appTheme.toString().toLowerCase()!='dark'?ColorResources.appColor:ColorResources.whiteColor),
    ),
    subtitle:
        subtitle != null
            ? Text(
              subtitle,
              style:  TextStyle(color:appTheme.toString().toLowerCase()!='dark'?ColorResources.appColor: ColorResources.subTitleColor),
            )
            : null,
    value: value,
    onChanged: onChanged,
    activeColor: ColorResources.thirdColor,
    inactiveTrackColor: Colors.transparent,
    inactiveThumbColor: ColorResources.thirdColor,
  );
}

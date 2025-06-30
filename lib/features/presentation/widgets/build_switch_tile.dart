import 'package:flutter/material.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';

Widget buildSwitchTile({
  required String title,
  String? subtitle,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return SwitchListTile(
    title: Text(
      title,
      style: const TextStyle(color: ColorResources.whiteColor),
    ),
    subtitle:
        subtitle != null
            ? Text(
              subtitle,
              style: const TextStyle(color: ColorResources.subTitleColor),
            )
            : null,
    value: value,
    onChanged: onChanged,
    activeColor: ColorResources.thirdColor,
    inactiveTrackColor: Colors.transparent,
    inactiveThumbColor: ColorResources.thirdColor,
    
  );
}
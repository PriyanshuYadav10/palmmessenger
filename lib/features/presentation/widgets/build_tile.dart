import 'package:flutter/material.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';

import '../utility/global.dart';

Widget buildTile(String title, String subtext) {
  return ListTile(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:  TextStyle(
            color:appTheme.toString().toLowerCase()!='dark'?ColorResources.appColor: ColorResources.whiteColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtext,
          style:  TextStyle(
            color:appTheme.toString().toLowerCase()!='dark'?ColorResources.appColor: ColorResources.subTitleColor,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}
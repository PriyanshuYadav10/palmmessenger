import 'package:flutter/material.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';

import '../utility/global.dart';

Widget sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style:  TextStyle(
        color: appTheme.toString().toLowerCase()!='dark'?ColorResources.appColor:ColorResources.subTitleColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  );
}
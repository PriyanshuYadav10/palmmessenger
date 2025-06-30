import 'package:flutter/material.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';

Widget buildTile(String title, String subtext) {
  return ListTile(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: ColorResources.whiteColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtext,
          style: const TextStyle(
            color: ColorResources.subTitleColor,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';

Widget sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style: const TextStyle(
        color: ColorResources.subTitleColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  );
}
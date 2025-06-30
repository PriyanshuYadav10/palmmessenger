import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    return (data == null) ? '' : jsonDecode(data);
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}

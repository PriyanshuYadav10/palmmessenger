import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:palmmessenger/core/constants/app_constants.dart';
import 'package:palmmessenger/core/resources/exception/api_error_handler.dart';
import 'package:palmmessenger/features/data/data-source/remote/dio_client.dart';
import 'package:palmmessenger/features/data/model/privacy_security_model.dart';
import '../model/chat_setting_model.dart';
import '../model/user_setting_model.dart';
import 'package:palmmessenger/features/presentation/utility/global.dart';

import '../model/notification_setting_model.dart';

class SettingsRepo {

  final DioClient dioClient;

  SettingsRepo({required this.dioClient});

  Future<UserSettingsModel?> settingsRepo() async {
    dioClient.updateHeader(accessToken);

    try {

      Response response = await dioClient.get(AppConstants.getUserSettings);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserSettingsModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return null;

    }
  }

  Future<PrivacyAndSecurityModel?> privacySettingsRepo(Map<String, dynamic> param) async {
    dioClient.updateHeader(accessToken);
    try {
      Response response = await dioClient.put(AppConstants.putPrivacySettings, data: param);

      debugPrint('response.statusCode-->  ${response.statusCode}');
      debugPrint('response.data-->  ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('response.statusCode-->  ${response.statusCode}');
        debugPrint('response.data-->  ${response.data}');
        return PrivacyAndSecurityModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return null;
    }
  }

  Future<ChatSettingsModel?> chatSettingsRepo(Map<String, dynamic> param) async {
    dioClient.updateHeader(accessToken);
    try {
      Response response = await dioClient.put(AppConstants.putChatSettings, data: param);

      debugPrint('response.statusCode-->  ${response.statusCode}');
      debugPrint('response.data-->  ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('response.statusCode-->  ${response.statusCode}');
        debugPrint('response.data-->  ${response.data}');
        return ChatSettingsModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return null;
    }
  }

  Future<NotificationSettingsModel?> notificationSettingsRepo(Map<String, dynamic> param) async {
    dioClient.updateHeader(accessToken);
    try {
      Response response = await dioClient.put(AppConstants.notificationSettings, data: param);

      debugPrint('response.statusCode-->  ${response.statusCode}');
      debugPrint('response.data-->  ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('response.statusCode-->  ${response.statusCode}');
        debugPrint('response.data-->  ${response.data}');
        return NotificationSettingsModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return null;
    }
  }

}
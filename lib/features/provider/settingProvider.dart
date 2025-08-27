import 'package:flutter/material.dart';

import '../data/model/chat_setting_model.dart';
import '../data/model/notification_setting_model.dart';
import '../data/model/privacy_security_model.dart';
import '../data/model/user_setting_model.dart';
import '../data/repository/setting_repo.dart';

class Settingsprovider with ChangeNotifier {

  final SettingsRepo settingsRepo;

  Settingsprovider({required this.settingsRepo});

  bool _isLoading = false;
  String _message = '';
  UserSettingsModel? _userSettingsModel;
  PrivacyAndSecurityModel? _privacyAndSecurityModel;
  ChatSettingsModel? _chatSettingsModel;
  NotificationSettingsModel? _notificationSettingsModel;



  bool get  isLoading => _isLoading;
  String get message => _message;
  UserSettingsModel? get settingsModel => _userSettingsModel;
  PrivacyAndSecurityModel? get privacyModel => _privacyAndSecurityModel;
  ChatSettingsModel? get chatSettingsModel => _chatSettingsModel;
  NotificationSettingsModel? get notificationSettingsModel => _notificationSettingsModel;


  Future<void> getUserSettings()async{
    _isLoading = true;
    _message = "";
    notifyListeners();

    try{
      final model = await settingsRepo.settingsRepo();
      if(model != null){
        _userSettingsModel = model;
      }
      else {
        _message = "Failed to get user settings";
      }
    } catch (e) {
      _message = "Error: ${e.toString()}";
    }

    _isLoading = false;
    notifyListeners();


  }

  Future<void> updatePrivacySettings(Map<String, dynamic> params) async {
    _isLoading = true;
    _message = '';
    notifyListeners();

    try {
      final model = await settingsRepo.privacySettingsRepo(params);
      if (model != null) {
        _privacyAndSecurityModel = model;
        _message = model.message ?? 'Privacy settings updated successfully';
      } else {
        _message = 'Failed to update privacy settings';
      }
    } catch (e) {
      _message = 'Error: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateChatSettings(Map<String, dynamic> params) async {
    _isLoading = true;
    _message = '';
    notifyListeners();

    try {
      final model = await settingsRepo.chatSettingsRepo(params);
      if (model != null) {
        _chatSettingsModel = model;
        _message = model.message ?? 'Privacy settings updated successfully';
      } else {
        _message = 'Failed to update privacy settings';
      }
    } catch (e) {
      _message = 'Error: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateNotificationSettings(Map<String, dynamic> params) async {
    _isLoading = true;
    _message = '';
    notifyListeners();

    try {
      final model = await settingsRepo.notificationSettingsRepo(params);
      if (model != null) {
        _notificationSettingsModel = model;
        _message = model.message ?? 'Privacy settings updated successfully';
      } else {
        _message = 'Failed to update privacy settings';
      }
    } catch (e) {
      _message = 'Error: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

}
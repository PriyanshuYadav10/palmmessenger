import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:path/path.dart';
import '../../config/theme/app_themes.dart';
import '../data/model/contacts_user_model.dart';
import '../data/model/group_model.dart';
import '../data/repository/chat_repo.dart';
import '../helper/database_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepo chatRepo;

  ChatProvider({required this.chatRepo});

  bool _isLoading = false;
  String _message = '';
  String groupId = '';

  List<GroupModel> _groupModels = [];
  List<GroupModel> get groupModels => _groupModels;

  Future<void> loadImage(File file, {Function(String url)? onUploaded}) async {
    _isLoading = true;
    _message = '';
    notifyListeners();

    try {
      final param = {
        "image": await MultipartFile.fromFile(file.path, filename: file.path.split("/").last),
      };

      final model = await chatRepo.imageLoadRepo(param);
      _isLoading = false;

      if (model != null && model.url != null) {
        debugPrint("Uploaded URL: ${model.url}");

        // ✅ Call callback to send message with URL
        if (onUploaded != null) {
          onUploaded(model.url!);
        }
      } else {
        _message = "Failed to upload file.";
      }
    } catch (e) {
      _message = "Error: ${e.toString()}";
    }

    notifyListeners();
  }
  Future<void> createGroupAPi(Map<String, dynamic> param) async {
    _isLoading = true;
    print('_isLoading   $_isLoading');
    groupId = '';
    notifyListeners();
    try {
      final model = await chatRepo.createGroup(param);

      _isLoading = false;
      if (model != null) {
        groupId = model.sId??'';
        print('model $model');
      } else {
        _message = "Failed to create group.";
      }
    } catch (e) {
      _message = "Error: ${e.toString()}";
    }

    notifyListeners();
  }

  Future<void> userGroups() async {
    _isLoading = true;
    print('_isLoading   $_isLoading');
    groupId = '';
    notifyListeners();
    try {
      final model = await chatRepo.userGroups();

      _isLoading = false;
      if (model != null) {
        _groupModels=model;
        print('_groupModels $_groupModels');
      } else {
        _message = "Failed to create group.";
      }
    } catch (e) {
      _message = "Error: ${e.toString()}";
    }

    notifyListeners();
  }


}

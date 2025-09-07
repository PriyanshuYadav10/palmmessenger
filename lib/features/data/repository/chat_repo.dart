import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:palmmessenger/features/data/model/group_model.dart';
import 'package:palmmessenger/features/data/model/group_model.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/resources/exception/api_error_handler.dart';
import '../../../core/resources/exception/api_response.dart';
import '../../presentation/utility/global.dart';
import '../data-source/remote/dio_client.dart';
import '../model/RequestOtpModel.dart';
import '../model/contacts_user_model.dart';
import '../model/create_group_model.dart';
import '../model/imageLoad_model.dart';

class ChatRepo {
  final DioClient dioClient;

  ChatRepo({required this.dioClient});


  Future<ImageLoadModel?> imageLoadRepo(Map<String, dynamic> param) async {
    dioClient.updateHeader(accessToken);
    try {
      Response response = await dioClient.post(
        AppConstants.fileUpload,
        data: FormData.fromMap(param),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ImageLoadModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return null;
    }
  }


  Future<CreateGroupModel?> createGroup(Map<String, dynamic> param) async {
    try {
      Response response = await dioClient.post(AppConstants.createGroup, data: param);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateGroupModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return null;
    }
  }

  Future<List<GroupModel>?> userGroups() async {
    try {
      Response response = await dioClient.get(AppConstants.userGroups);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        return data.map((e) => GroupModel.fromJson(e)).toList();
      } else {
        return null;
      }
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return null;
    }
  }

}

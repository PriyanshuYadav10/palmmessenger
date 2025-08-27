import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/resources/exception/api_error_handler.dart';
import '../../../core/resources/exception/api_response.dart';
import '../../presentation/utility/global.dart';
import '../data-source/remote/dio_client.dart';
import '../model/contacts_user_model.dart';
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


}

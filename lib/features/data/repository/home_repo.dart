import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/resources/exception/api_error_handler.dart';
import '../../../core/resources/exception/api_response.dart';
import '../../presentation/utility/global.dart';
import '../data-source/remote/dio_client.dart';
import '../model/contacts_user_model.dart';

class HomeRepo {
  final DioClient dioClient;

  HomeRepo({required this.dioClient});


  Future<ContactsUserModel?> contactListRepo(Map<String, dynamic> param) async {
    dioClient.updateHeader(accessToken);
    try {
      Response response = await dioClient.getWithBody(AppConstants.searchContact, data: param);

      debugPrint('response.statusCode-->  ${response.statusCode}');
      debugPrint('response.data-->  ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('response.statusCode-->  ${response.statusCode}');
        debugPrint('response.data-->  ${response.data}');
        return ContactsUserModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return null;
    }
  }

}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:palmmessenger/features/presentation/utility/global.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/resources/exception/api_error_handler.dart';
import '../../../core/resources/exception/api_response.dart';
import '../data-source/remote/dio_client.dart';
import '../model/PlamIdModel.dart';
import '../model/RequestOtpModel.dart';
import '../model/contacts_user_model.dart';
import '../model/createOderModel.dart';
import '../model/profileUpdateModel.dart';
import '../model/public_key_add_model.dart';
import '../model/userProfileDataModel.dart';
import '../model/verifyOtpModel.dart';

class AuthRepo {
  final DioClient dioClient;

  AuthRepo({required this.dioClient});


Future<RequestOtpModel?> requestRepo(Map<String, dynamic> param) async {
  try {
    Response response = await dioClient.post(AppConstants.requestOtp, data: param);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RequestOtpModel.fromJson(response.data);
    } else {
      return null;
    }
  } catch (e) {
    print(ApiErrorHandler.getMessage(e));
    return null;
  }
}

Future<verifyOtpModel?> verifyRepo(Map<String, dynamic> param) async {
  try {
    Response response = await dioClient.post(AppConstants.verifyOtp, data: param);

    debugPrint('response.statusCode-->  ${response.statusCode}');
    debugPrint('response.data-->  ${response.data}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('response.statusCode-->  ${response.statusCode}');
      debugPrint('response.data-->  ${response.data}');
      return verifyOtpModel.fromJson(response.data);
    } else {
      return null;
    }
  } catch (e) {
    print(ApiErrorHandler.getMessage(e));
    return null;
  }
}

Future<publicKeyAddModel?> publicKeyRepo(Map<String, dynamic> param) async {
  dioClient.updateHeader(accessToken);
  try {
    Response response = await dioClient.put(AppConstants.publicKey, data: param);

    debugPrint('response.statusCode-->  ${response.statusCode}');
    debugPrint('response.data-->  ${response.data}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('response.statusCode-->  ${response.statusCode}');
      debugPrint('response.data-->  ${response.data}');
      return publicKeyAddModel.fromJson(response.data);
    } else {
      return null;
    }
  } catch (e) {
    print(ApiErrorHandler.getMessage(e));
    return null;
  }
}

Future<PalmIdModel?> loginPalmIdRepo(Map<String, dynamic> param) async {
  try {
    Response response = await dioClient.post(AppConstants.loginPalmId, data: param);

    debugPrint('response.statusCode-->  ${response.statusCode}');
    debugPrint('response.data-->  ${response.data}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('response.statusCode-->  ${response.statusCode}');
      debugPrint('response.data-->  ${response.data}');
      return PalmIdModel.fromJson(response.data);
    } else {
      return null;
    }
  } catch (e) {
    print(ApiErrorHandler.getMessage(e));
    return null;
  }
}

Future<CreateOrderModel?> createOrderRepo(Map<String, dynamic> param) async {
    try {
      Response response = await dioClient.post(AppConstants.createOrder, data: param);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateOrderModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return null;
    }
  }

Future<PalmIdModel?> registerPalmIdRepo(Map<String, dynamic> param) async {
    try {
      Response response = await dioClient.post(AppConstants.registerPalmId, data: param);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PalmIdModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return null;
    }
  }

  Future<ProfileUpdateModel?> updateProfileRepo(Map<String, dynamic> param, File? imageFile) async {
  dioClient.updateHeader(accessToken);
    try {
      FormData formData = FormData.fromMap({
        ...param,
        if (imageFile != null)
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });
      print('formData  $formData');
      Response response = await dioClient.put(
        AppConstants.updateProfile,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProfileUpdateModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return null;
    }
  }


Future<UserProfileDataModel?> profileDetailsRepo() async {
  dioClient.updateHeader(accessToken);
    try {
      Response response = await dioClient.get(AppConstants.profileDetails);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserProfileDataModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return null;
    }
  }
}

import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/resources/exception/api_error_handler.dart';
import '../../../core/resources/exception/api_response.dart';
import '../data-source/remote/dio_client.dart';

class HomeRepo {
  final DioClient dioClient;

  HomeRepo({required this.dioClient});


  // Future<ApiResponse> loginUserRepo(Map<String, dynamic> param) async {
  //   dioClient.updateHeader(UserData().model.value.token.toString());
  //   try {
  //     Response response = await dioClient.post(AppConstants.login, data: param);
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     print(ApiErrorHandler.getMessage(e));
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }
  //
  // Future<ApiResponse> getDeliveryOptions() async {
  //   print('apiToken ---->   ${UserData().model.value.token.toString()}');
  //   dioClient.updateHeader(UserData().model.value.token.toString());
  //   try {
  //     Response response = await dioClient.get(AppConstants.delivery_options);
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     print(ApiErrorHandler.getMessage(e));
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }
  //
  // Future<ApiResponse> addUserRepo(Map<String, dynamic> param, File? imageFile) async {
  //   dioClient.updateHeader(UserData().model.value.token.toString());
  //
  //   try {
  //     // Create a FormData object
  //     FormData formData = FormData.fromMap(param);
  //
  //     // If there is an image file, add it to the FormData
  //     if (imageFile != null) {
  //       formData.files.add(MapEntry(
  //         'image', // Key for the image file in the request
  //         await MultipartFile.fromFile(
  //           imageFile.path,
  //           filename: imageFile.path.split('/').last, // Extract the file name
  //         ),
  //       ));
  //     }
  //
  //     // Send the multipart request
  //     Response response = await dioClient.post(AppConstants.add_user, data: formData);
  //
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     print(ApiErrorHandler.getMessage(e));
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }
  //
  // Future<ApiResponse> updateProfile(Map<String, dynamic> param, File? imageFile) async {
  //   dioClient.updateHeader(UserData().model.value.token.toString());
  //
  //   try {
  //     // Create a FormData object with the parameters
  //     FormData formData = FormData.fromMap({
  //       ...param, // Include other parameters
  //       'image': imageFile != null
  //           ? await MultipartFile.fromFile(
  //         imageFile.path,
  //         filename: imageFile.path.split('/').last, // Extract the file name
  //       )
  //           : null, // Handle null case for the image
  //     });
  //
  //     // Log the FormData for debugging
  //     print("FormData Fields: ${formData.fields}");
  //     print("FormData Files: ${formData.files}");
  //
  //     // Make the API call using Dio
  //     Response response =
  //     await dioClient.post(AppConstants.updateProfile, data: formData);
  //
  //     return ApiResponse.withSuccess(response); // Return successful response
  //   } catch (e) {
  //     print(ApiErrorHandler.getMessage(e)); // Print error for debugging
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e)); // Return error response
  //   }
  // }

}

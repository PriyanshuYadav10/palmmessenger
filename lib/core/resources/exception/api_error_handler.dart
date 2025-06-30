import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioErrorType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioErrorType.unknown:
              errorDescription =
              "Connection to API server failed due to internet connection";
              break;
            case DioErrorType.receiveTimeout:
              errorDescription =
              "Receive timeout in connection with API server";
              break;
            case DioErrorType.badResponse:
              switch (error.response?.statusCode) {
                case 400:
                case 401:
                  errorDescription = error.response;
                  break;
                case 404:
                case 422:
                  errorDescription = error.response;
                  print(error.response?.data);
                  break;
                case 500:
                case 503:
                  errorDescription = error.response?.statusMessage;
                  print(error.response?.data);
                  break;
                default:
                  //ErrorResponse errorResponse = ErrorResponse.fromJson(error.response?.data);
                  /*if (errorResponse.errors.isNotEmpty) {
                    errorDescription = errorResponse;
                  } else {
                  }*/
                  errorDescription = "Failed to load data - status code: ${error.response?.statusCode}";
              }
              break;
            case DioErrorType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
            case DioExceptionType.badCertificate:
              // TODO: Handle this case.
              break;
            case DioExceptionType.connectionError:
              // TODO: Handle this case.
              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}

  import 'dart:io';

import 'package:flutter/material.dart';
import 'package:palmmessenger/features/data/model/profileUpdateModel.dart';
import '../data/model/PlamIdModel.dart';
import '../data/model/RequestOtpModel.dart';
import '../data/model/createOderModel.dart';
import '../data/model/userProfileDataModel.dart';
import '../data/model/verifyOtpModel.dart';
import '../data/repository/auth_repo.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;

  AuthProvider({required this.authRepo});

  bool _isLoading = false;
  String _message = '';
  RequestOtpModel? _otpModel;
  verifyOtpModel? _otpVerifyModel;
  CreateOrderModel? _createOrderModel;
  PalmIdModel? _palmIdModel;
  ProfileUpdateModel? _profileUpdateModel;
  UserProfileDataModel? _userProfileDataModel;

  bool get  isLoading => _isLoading;
  String get message => _message;
  RequestOtpModel? get otpModel => _otpModel;
  verifyOtpModel? get otpVerifyModel => _otpVerifyModel;
  CreateOrderModel? get createOrderModel => _createOrderModel;
  PalmIdModel? get palmIdModel => _palmIdModel;
  ProfileUpdateModel? get profileUpdateModel => _profileUpdateModel;
  UserProfileDataModel? get userProfileDataModel => _userProfileDataModel;

  Future<void> requestOtp(Map<String, dynamic> param) async {
    _isLoading = true;
    print('_isLoading   $_isLoading');
    _message = '';
    notifyListeners();
    _otpModel?.otp ='';
    try {
      final model = await authRepo.requestRepo(param);

      _isLoading = false;
      if (model != null) {
        _otpModel = model;
        _message = "OTP sent successfully!";
      } else {
        _message = "Failed to send OTP.";
      }
    } catch (e) {
      _message = "Error: ${e.toString()}";
    }

    notifyListeners();
  }

  Future<void> verifyOtp(Map<String, dynamic> param) async {
    _isLoading = true;
    _message = '';
    notifyListeners();
    otpVerifyModel?.isVerified =false;
    try {
      final model = await authRepo.verifyRepo(param);
        print('model');
        print(model);
      if (model?.isVerified ==true) {
        _otpVerifyModel = model;
        _message = "OTP verify successfully!";
      } else {
        _message = model?.message??"Failed to verify OTP.";
      }
    } catch (e) {
      _message = "Error: ${e.toString()}";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginPalmId(Map<String, dynamic> param) async {
    _isLoading = true;
    _message = '';
    notifyListeners();
    // otpVerifyModel?.isVerified =false;
    try {
      final model = await authRepo.loginPalmIdRepo(param);
        print('model');
        print(model);
      if (model?.message =='Login Successful') {
        _palmIdModel = model;
        _message = "Login successfully!";
      } else {
        _message = model?.message??"Failed to login";
      }
    } catch (e) {
      _message = "Error: ${e.toString()}";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createOrder(Map<String, dynamic> param) async {
    _isLoading = true;
    _message = '';
    notifyListeners();
    try {
      final model = await authRepo.createOrderRepo(param);
      if (model != null) {
        _createOrderModel = model;
      } else {
        _message = "Failed to create order.";
      }
    } catch (e) {
      _message = "Error: ${e.toString()}";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registerPalmId(Map<String, dynamic> param) async {
    _isLoading = true;
    _message = '';
    notifyListeners();
    try {
      final model = await authRepo.registerPalmIdRepo(param);
      if (model != null) {
        _palmIdModel = model;
      } else {
        _message = "Failed to create order.";
      }
    } catch (e) {
      _message = "Error: ${e.toString()}";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(Map<String, dynamic> param, File? imageFile) async {
    _isLoading = true;
    _message = '';
    notifyListeners();

    try {
      final model = await authRepo.updateProfileRepo(param, imageFile);
      if (model != null) {
        _profileUpdateModel = model;
      } else {
        _message = "Failed to update profile.";
      }
    } catch (e) {
      _message = "Error: ${e.toString()}";
    }

    _isLoading = false;
    notifyListeners();
  }


  Future<void> getProfile() async {
    _isLoading = true;
    _message = '';
    notifyListeners();
    try {
      final model = await authRepo.profileDetailsRepo();
      if (model != null) {
        _userProfileDataModel = model;
      } else {
        _message = "Failed to create order.";
      }
    } catch (e) {
      _message = "Error: ${e.toString()}";
    }

    _isLoading = false;
    notifyListeners();
  }
}

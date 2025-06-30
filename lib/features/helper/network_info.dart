import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'alertDiaolg.dart';

Future<bool> checkInternetConnection(context) async {
  // var connectivityResult = await (Connectivity().checkConnectivity());
  //
  // if (connectivityResult.contains(ConnectivityResult.none)) {
  //   showAlertError("No internet connection",context);
  //   return false;
  // } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
  //   // showAlertError("No internet connection",context);
  //   return true;
  // } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
  //   // showAlertError("No internet connection",context);
  //   return true;
  // } else {
  //   return true;
  // }
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.none) {
    showAlertError("No internet connection",context);
    return false;
  } else if (connectivityResult == ConnectivityResult.mobile) {
    // showAlertError("No internet connection",context);
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // showAlertError("No internet connection",context);
    return true;
  } else {
    return true;
  }
}
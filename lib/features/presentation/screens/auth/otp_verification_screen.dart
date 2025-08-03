import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/spaces.dart';
import 'package:palmmessenger/features/presentation/screens/auth/set_up_profile.dart';
import 'package:palmmessenger/features/presentation/utility/app_shared_prefrence.dart';
import 'package:palmmessenger/features/presentation/widgets/button.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme/app_themes.dart';
import '../../../../config/theme/textstyles.dart';
import '../../../../core/constants/images.dart';
import '../../../data/encryption/rsa_helper.dart';
import '../../../data/encryption/rsa_key_helper.dart';
import '../../../helper/alertDiaolg.dart';
import '../../../provider/authProvider.dart';
import '../../utility/global.dart';
import '../Dashboard/dashboard_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  OtpVerificationScreen(
      {super.key,
      required this.phoneNumber,
      required this.code,
      required this.path});
  String? code;
  String? phoneNumber;
  String? path;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  TextEditingController otpCtrl = TextEditingController();
  Timer? _timer;
  int _remainingTime = 60;
  bool _showResend = false;
  @override
  void initState() {
    super.initState();
    startTimer();

    otpCtrl.text = Provider.of<AuthProvider>(context, listen: false)
        .otpModel!
        .otp
        .toString();
  }

  void startTimer() {
    setState(() {
      _remainingTime = 60;
      _showResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime == 0) {
        setState(() {
          _showResend = true;
        });
        _timer?.cancel();
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> resendOtp() async {
    Map<String, dynamic> param = {"phoneNo": widget.phoneNumber};
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.requestOtp(param);

    debugPrint("OTP: ${authProvider.message}");
    debugPrint("OTP: ${authProvider.otpModel?.otp}");
    debugPrint("Expiry: ${authProvider.otpModel?.otpExpiry}");
    if (authProvider.otpModel?.otp != '') {
      startTimer();
      showAlertSuccess('Otp Resend Successfully!', context);
    } else {
      showAlertError(authProvider.message, context);
    }
  }

  Future<void> verifyOtp() async {
    Map<String, dynamic> param = {
      "phoneNo": widget.phoneNumber,
      "otp": otpCtrl.text
    };
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.verifyOtp(param);
    debugPrint("OTP: ${authProvider.message}");
    debugPrint("OTP: ${authProvider.otpVerifyModel?.isVerified}");
    debugPrint("Expiry: ${authProvider.otpVerifyModel?.accessToken}");
    if (authProvider.otpVerifyModel?.isVerified == true) {
      final prefs = AppSharedPref();
      prefs.save("userData", authProvider.otpVerifyModel);
      prefs.read('userData').then((data) {
        print('data--> ${data}');
      });
      accessToken=authProvider.otpVerifyModel!.accessToken.toString();
      if (authProvider.otpModel?.isRegistered == false) {
        if(authProvider.isLoading==false) {
          Get.offAll(SetUpProfileScreen());
        }
      } else {
        Get.offAll(DashboardScreen(),);
      }

      showAlertSuccess(authProvider.message, context);
    } else {
      showAlertError(authProvider.message, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage(app_bg), fit: BoxFit.cover),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ListView(
              children: [
                hSpace(120),
                Text(
                  'We just sent an SMS',
                  textAlign: TextAlign.center,
                  style: Styles.mediumTextStyle(
                      size: 25, color: ColorResources.whiteColor),
                ),
                hSpace(50),
                Text(
                  'Enter the security code we sent to ${widget.code} ${widget.phoneNumber}',
                  textAlign: TextAlign.center,
                  style: Styles.mediumTextStyle(
                      size: 18, color: ColorResources.whiteColor),
                ),
                hSpace(40),
                OtpTextField(
                  numberOfFields: 6,
                  enabledBorderColor: ColorResources.secondaryColor,
                  clearText: false,
                  fieldWidth: 45,
                  showFieldAsBox: true,
                  textStyle:
                      Styles.semiBoldTextStyle(color: ColorResources.whiteColor),
                  onCodeChanged: (String value) {},
                  handleControllers: (controllers) {
                    final otp = Provider.of<AuthProvider>(context, listen: false)
                            .otpModel
                            ?.otp
                            ?.toString() ??
                        '';
                    for (int i = 0; i < controllers.length; i++) {
                      if (i < otp.length) {
                        controllers[i]?.text = otp[i];
                      }
                    }
                    otpCtrl.text = otp;
                  },
                  onSubmit: (String verificationCode) {
                    // Add your verification logic
                  },
                ),
                hSpace(15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'The OTP is will expire in 00:${_remainingTime.toString().padLeft(2, '0')}',
                        textAlign: TextAlign.center,
                        style: Styles.regularTextStyle(
                            size: 14, color: ColorResources.thirdColor)),
                    InkWell(
                      onTap: () {
                        resendOtp();
                      },
                      child: Text("Resend OTP",
                          textAlign: TextAlign.center,
                          style: Styles.regularTextStyle(
                              size: 14,
                              color: ColorResources.thirdColor,
                              underlineNeeded: true)),
                    ),
                  ],
                ),
                hSpace(100),
                customButton(
                  () {
                    verifyOtp();
                  },
                  "Verify OTP",
                  context,
                  width: 150,
                  height: 50,
                  isLoading: authProvider.isLoading,
                  borderGradient: const LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                  ),
                  color: ColorResources.appColor,
                  txtColor: Colors.white,
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
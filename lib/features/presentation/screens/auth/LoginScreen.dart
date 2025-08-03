import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:palmmessenger/features/helper/alertDiaolg.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/config/theme/spaces.dart';
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:palmmessenger/core/constants/images.dart';
import 'package:palmmessenger/features/presentation/screens/auth/otp_verification_screen.dart';
import 'package:palmmessenger/features/presentation/screens/auth/register_screen.dart';
import 'package:palmmessenger/features/presentation/utility/gradient_text.dart';
import 'package:palmmessenger/features/presentation/widgets/button.dart';
import 'package:palmmessenger/features/presentation/widgets/textfeild.dart';

import '../../../provider/authProvider.dart';
import '../../utility/app_shared_prefrence.dart';
import '../../utility/global.dart';
import '../Dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController countryCodeCtrl = TextEditingController();
  TextEditingController loginCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  String? errorLoginText;
  String? errorPasswordText;
  bool showPasswordField = false;
  Future<void> requestOtp() async {
    Map<String, dynamic> param={
      "phoneNo":loginCtrl.text
    };
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.requestOtp(param);

    debugPrint("isLoading: ${authProvider.isLoading}");
    debugPrint("OTP: ${authProvider.message}");
    debugPrint("OTP: ${authProvider.otpModel?.otp}");
    debugPrint("Expiry: ${authProvider.otpModel?.otpExpiry}");
    if (authProvider.otpModel?.otp.toString() != ''&&authProvider.otpModel?.otp != null){
      if(authProvider.isLoading==false) {
        showAlertSuccess(authProvider.message, context);
        Get.to(OtpVerificationScreen(code: countryCodeCtrl.text,
          phoneNumber: loginCtrl.text,
          path: 'login',));
      }
      }else{
      showAlertError(authProvider.message, context);
    }
  }

  Future<void> loginPalmId() async {
    Map<String, dynamic> param={
      "palmId":loginCtrl.text,
      "password":passwordCtrl.text
    };
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loginPalmId(param);

    if (authProvider.palmIdModel?.message != ''&&authProvider.palmIdModel?.message !=null){

      final prefs = AppSharedPref();
      prefs.save("userData", authProvider.palmIdModel);
      prefs.read('userData').then((data) {
        print('data--> ${data}');
      });
      accessToken=authProvider.palmIdModel!.accessToken.toString();
      showAlertSuccess(authProvider.message, context);
      Get.offAll(DashboardScreen(),);
    }else{
      showAlertError(authProvider.message, context);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countryCodeCtrl.text = '+91';

    // loginCtrl.addListener(() {
    //   String input = loginCtrl.text.trim();
    //
    //   setState(() {
    //     // Check if the input contains 'pal' (case-insensitive)
    //     if (input.toLowerCase().contains('pal')) {
    //       showPasswordField = true;
    //     }
    //     // If it's all digits, treat it as a phone number
    //     else if (RegExp(r'^\d+$').hasMatch(input)) {
    //       showPasswordField = false;
    //     }
    //     // Optional fallback if you want to show password field for any non-number that's not empty
    //     else {
    //       showPasswordField = false;
    //     }
    //   });
    // });
    loginCtrl.addListener(() {
      String input = loginCtrl.text.trim();

      // Regex: digits only means mobile number
      bool isPhoneNumber = RegExp(r'^\d+$').hasMatch(input);

      setState(() {
        showPasswordField = !isPhoneNumber && input.isNotEmpty;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(app_bg),fit: BoxFit.cover)
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40,),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: GradientText('Palm Messenger',style: Styles.extraBoldTextStyle(size: 50),),
                ),
                hSpace(80),
                Text('Enter Phone number or Palm ID',style: Styles.mediumTextStyle(size: 15,color: ColorResources.whiteColor),),
                hSpace(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: !showPasswordField,
                      child: InkWell(
                          onTap: (){
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              onSelect: (Country country) {
                                setState(() {
                                  countryCodeCtrl.text = '+${country.phoneCode.toString()}';
                                });
                                print('Select country: ${country.displayName}');
                              },
                              moveAlongWithKeyboard: false,
                              countryListTheme: CountryListThemeData(
                                backgroundColor: ColorResources.appColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.0),
                                  topRight: Radius.circular(40.0),
                                ),
                                textStyle: TextStyle(color: ColorResources.whiteColor),
                                inputDecoration: InputDecoration(
                                  labelText: 'Search',
                                  hintText: 'Start typing to search',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color(0xFF8C98A8).withOpacity(0.2),
                                    ),
                                  ),
                                ),
                                // Optional. Styles the text in the search field
                                searchTextStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                ),
                              ),
                            );
                          },
                          child: buildTextField(countryCodeCtrl, '', MediaQuery.sizeOf(context).width*0.15, 45  ,TextInputType.text,isEnabled: false )),
                    ),
                    buildTextField(loginCtrl, '',!showPasswordField? MediaQuery.sizeOf(context).width*0.62:MediaQuery.sizeOf(context).width-80, 45  ,TextInputType.text,errorText: errorLoginText,fun: (){
                    }),
                  ],
                ),
                Visibility(
                  visible: showPasswordField,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      hSpace(15),
                      Text('Password',style: Styles.mediumTextStyle(size: 15,color: ColorResources.whiteColor),),
                      hSpace(10),
                      buildTextField(passwordCtrl, '', MediaQuery.sizeOf(context).width, 45  ,TextInputType.visiblePassword,errorText: errorPasswordText,fun: (){
                      }),
                    ],
                  ),
                ),
                hSpace(100),
                customButton((){
                  if(!showPasswordField) {
                    requestOtp();
                  }else{
                    loginPalmId();
                  }
                }, 'Login', context,width: 150,
                  isLoading: authProvider.isLoading,),
                hSpace(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text( "Don't have an account? ",style:Styles.mediumTextStyle(size: 15,color: ColorResources.whiteColor)),
                    InkWell(
                        onTap: (){
                          Get.offAll(RegisterScreen());
                        },
                        child: Text( "Register",style:Styles.mediumTextStyle(size: 15,color: ColorResources.whiteColor,underlineNeeded: true))),
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
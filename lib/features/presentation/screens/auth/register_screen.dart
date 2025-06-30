import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/features/presentation/screens/auth/LoginScreen.dart';
import 'package:palmmessenger/features/presentation/screens/auth/get_palm_id.dart';
import 'package:palmmessenger/features/presentation/screens/auth/otp_verification_screen.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme/app_themes.dart';
import '../../../../config/theme/spaces.dart';
import '../../../../config/theme/textstyles.dart';
import '../../../../core/constants/images.dart';
import '../../../helper/alertDiaolg.dart';
import '../../../provider/authProvider.dart';
import '../../utility/gradient_text.dart';
import '../../widgets/button.dart';
import '../../widgets/textfeild.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController countryCodeCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  String? errorLoginText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countryCodeCtrl.text = '+91';
  }

  String? errorPhoneText;
  Future<void> requestOtp() async {
    Map<String, dynamic> param={
      "phoneNo":phoneCtrl.text
    };
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.requestOtp(param);

    debugPrint("OTP: ${authProvider.message}");
    debugPrint("OTP: ${authProvider.otpModel?.otp}");
    debugPrint("Expiry: ${authProvider.otpModel?.otpExpiry}");
    if (authProvider.otpModel?.otp != ''){
      if(authProvider.isLoading==false) {
        showAlertSuccess(authProvider.message, context);
        Get.to(OtpVerificationScreen(phoneNumber: phoneCtrl.text,
          code: countryCodeCtrl.text,
          path: 'register',));
      }
    }else{
      showAlertError(authProvider.message, context);
    }
  }

  String selectedValue ='Register With Mobile';
  @override
  Widget build(BuildContext context) {
    return  Consumer<AuthProvider>(
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
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      gradient: GradientColor.gradient1,
                      borderRadius: BorderRadius.circular(40)
                  ),
                  width: MediaQuery.sizeOf(context).width*0.9,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: ColorResources.blackColor,
                        borderRadius: BorderRadius.all(Radius.circular(40))
                    ),
                    width: MediaQuery.sizeOf(context).width*0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: (){
                            setState(() {
                              selectedValue='Register With Mobile';
                            });
                          },
                          child: Container(
                              width: MediaQuery.sizeOf(context).width*0.8/2,
                              height:double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border(
                                      right: BorderSide(
                                          color: selectedValue=='Register With Mobile'?ColorResources.fourthColor:Colors.transparent
                                      )
                                  ),
                                  color: selectedValue=='Register With Mobile'?ColorResources.whiteColor.withOpacity(0.3):Colors.transparent
                              ),
                              child: Text('Register With Mobile',style: Styles.mediumTextStyle(size: 15,color: ColorResources.whiteColor),)),
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              selectedValue='Get Palm ID';
                            });
                          },
                          child: Container(
                              width: MediaQuery.sizeOf(context).width*0.8/2,
                              height:double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: selectedValue=='Get Palm ID'?ColorResources.fourthColor:Colors.transparent
                                      )
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                  color: selectedValue=='Get Palm ID'?ColorResources.whiteColor.withOpacity(0.4):Colors.transparent
                              ),
                              child: Text('Get Palm ID',style: Styles.mediumTextStyle(size: 15,color: ColorResources.whiteColor),)),
                        ),
                      ],
                    ),
                  ),
                ),
                hSpace(20),
                selectedValue=='Register With Mobile'?Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter Phone number',style: Styles.mediumTextStyle(size: 15,color: ColorResources.whiteColor),),
                    hSpace(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
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
                        buildTextField(phoneCtrl, '', MediaQuery.sizeOf(context).width*0.62, 45  ,TextInputType.text,errorText: errorLoginText,fun: (){
                        }),
                      ],
                    ),
                  ],):
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 25,
                            child: Icon(Icons.lightbulb_outline_rounded,color: ColorResources.whiteColor,)),
                        wSpace(5),
                        SizedBox(
                            width: MediaQuery.sizeOf(context).width*0.68,
                            child: Text('Your Palm ID will be generated after payment using a secure, quantum-safr process and will look like:',style: Styles.regularTextStyle(size: 13,color: ColorResources.whiteColor),))
                      ],
                    ),
                    hSpace(15),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Why Palm ID?', style: Styles.mediumTextStyle(size: 18,color: ColorResources.whiteColor),),
                          hSpace(8),
                          Text('• Anonymous, phone-free login', style: Styles.mediumTextStyle(size: 13,color: ColorResources.whiteColor),),
                          hSpace(5),
                          Text('• End-to-end quantum encryption', style: Styles.mediumTextStyle(size: 13,color: ColorResources.whiteColor),),
                          hSpace(5),
                          Text('• Lifetime secure handle', style: Styles.mediumTextStyle(size: 13,color: ColorResources.whiteColor),),
                        ],
                      ),
                    ),
                  ],
                ),
                hSpace(100),
                customButton((){
                  if(selectedValue=='Register With Mobile'){
                    requestOtp();
                  }else{
                    Get.to(GetPalmIdScreen());
                  }
                },selectedValue=='Register With Mobile'? 'Get OTP':'Get Palm ID', context,width: 150,isLoading: authProvider.isLoading),
                hSpace(20),
                InkWell(
                    onTap: (){
                      Get.offAll(LoginScreen());
                    },
                    child: Text( "Already have a Palm ID?",textAlign: TextAlign.center, style:Styles.mediumTextStyle(size: 15,color: ColorResources.whiteColor)))
              ],
            ),
          ),
        );
      }
    );
  }
}

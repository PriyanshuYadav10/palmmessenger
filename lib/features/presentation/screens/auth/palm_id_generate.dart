import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/features/helper/alertDiaolg.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme/spaces.dart';
import '../../../../config/theme/textstyles.dart';
import '../../../../core/constants/images.dart';
import '../../../provider/authProvider.dart';
import '../../utility/global.dart';
import '../../utility/gradient_text.dart';
import '../../widgets/button.dart';
import '../Dashboard/dashboard_screen.dart';
import 'LoginScreen.dart';

class PalmIdGenerateScreen extends StatefulWidget {
   PalmIdGenerateScreen({super.key, required this.name});
String? name;
  @override
  State<PalmIdGenerateScreen> createState() => _PalmIdGenerateScreenState();
}

class _PalmIdGenerateScreenState extends State<PalmIdGenerateScreen> {
  @override
  Widget build(BuildContext context) {
    return  Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
        return Scaffold(
          body: Container(
            decoration:appTheme.toString().toLowerCase()=='dark'? BoxDecoration(
                image: DecorationImage(image: AssetImage(app_bg),fit: BoxFit.cover)
            ):BoxDecoration(
                color: ColorResources.whiteColor
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: GradientText('Welcome ${widget.name??''} !',style: Styles.extraBoldTextStyle(size: 50,color:  appTheme.toString().toLowerCase()!='dark'?ColorResources.blackColor: ColorResources.whiteColor),),
                ),
                hSpace(80),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: ColorResources.secondaryColor.withOpacity(0.5))
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Palm ID is Ready!',style: Styles.semiBoldTextStyle(size: 20,color: ColorResources.secondaryColor),),
                      hSpace(15),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: ColorResources.whiteColor.withOpacity(0.15)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width:MediaQuery.sizeOf(context).width*0.4,
                                child: Text('${authProvider.palmIdModel?.palmId.toString()}',style: Styles.mediumTextStyle(size: 15,color: appTheme.toString().toLowerCase()!='dark'?ColorResources.blackColor:  ColorResources.whiteColor),)),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  Clipboard.setData(ClipboardData(text: '${authProvider.palmIdModel?.palmId.toString()}'));
                                  showAlertSuccess('PALM Id copied to clipboard', context);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  gradient: GradientColor.gradient2
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    color: ColorResources.blackColor
                                  ),
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                          width: 20,
                                          child: Icon(Icons.copy,color: ColorResources.secondaryColor)),
                                      wSpace(8),
                                      Text('Copy \nPalm ID',style: Styles.semiBoldTextStyle(size: 14,color: ColorResources.secondaryColor),)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      hSpace(15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 25,
                              child: Icon(
                                Icons.lock_outline_rounded,
                                color: ColorResources.secondaryColor,
                              )),
                          wSpace(5),
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.67,
                              child: Text(
                                'Your Palm ID is quantum-secure. Save it carefully - even we can’t recover.',
                                style: Styles.regularTextStyle(
                                    size: 13, color: ColorResources.secondaryColor),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
                hSpace(100),
                customButton(() {
                  Get.offAll(DashboardScreen(),);
                }, 'Start Messaging', context,isLoading: authProvider.isLoading),
                hSpace(30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: InkWell(
                      onTap: () {
                        Get.offAll(LoginScreen());
                      },
                      child: Text("Need Help? Contact support via Palm Web Portal",
                          textAlign: TextAlign.center,
                          style: Styles.mediumTextStyle(
                              size: 15, color:appTheme.toString().toLowerCase()!='dark'?ColorResources.blackColor.withOpacity(0.6):  ColorResources.whiteColor.withOpacity(0.6)))),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/config/theme/spaces.dart';
import 'package:palmmessenger/config/theme/textstyles.dart';

import '../../../../../core/constants/images.dart';
import '../../../utility/global.dart';

class BroadcastMessageScreen extends StatefulWidget {
  const BroadcastMessageScreen({super.key});

  @override
  State<BroadcastMessageScreen> createState() => _BroadcastMessageScreenState();
}

class _BroadcastMessageScreenState extends State<BroadcastMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: ColorResources.appColor,
        automaticallyImplyLeading: false,
        title: Text('Broadcast',style: Styles.semiBoldTextStyle(size: 22,color: ColorResources.whiteColor)),
        leading: InkWell(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_new_rounded,color: ColorResources.whiteColor)),
        centerTitle: false,
      ),
      body: Container(
        width:double.infinity,
        decoration:appTheme.toString().toLowerCase()=='dark'? BoxDecoration(
            image: DecorationImage(image: AssetImage(app_bg),fit: BoxFit.cover)
        ):BoxDecoration(
            color: ColorResources.whiteColor
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
         children: [
           Row(
             children: [
               Image.asset(add,width:50,fit: BoxFit.cover,color: appTheme.toString().toLowerCase()!='dark'?ColorResources.appColor:ColorResources.whiteColor,),
               wSpace(15),
               Text('Create a broadcast',style: Styles.mediumTextStyle(color: appTheme.toString().toLowerCase()!='dark'?ColorResources.blackColor:ColorResources.whiteColor,size: 20))
             ],
           ),

           hSpace(15),
           ListView.builder(
             shrinkWrap: true,
             physics: NeverScrollableScrollPhysics(),
             itemCount: 10,
             itemBuilder: (context, index) {
               return Column(
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   Text('created on 24/01/24 at 12:00 am',textAlign: TextAlign.right, style: Styles.mediumTextStyle(size: 12,color:appTheme.toString().toLowerCase()!='dark'?ColorResources.blackColor: ColorResources.whiteColor)),
                   ListTile(
                     leading: Image.asset(
                     broadcast,
                       width: 25,
                       height: 25,
                       fit: BoxFit.fill,
                       color: appTheme.toString().toLowerCase()!='dark'?ColorResources.blackColor:ColorResources.whiteColor,
                     ),
                     title: Text('Broadcast $index',style: Styles.semiBoldTextStyle(color: appTheme.toString().toLowerCase()!='dark'?ColorResources.blackColor:ColorResources.whiteColor,size: 16),),
                     subtitle: Text('Rachel, Emma, Tom, John, Keli',style: Styles.mediumTextStyle(color:appTheme.toString().toLowerCase()!='dark'?ColorResources.blackColor: ColorResources.whiteColor,size: 16),),
                     contentPadding: EdgeInsets.symmetric(horizontal: 5),
                   ),
                 ],
               );
             },
           )
         ],
        ),
      ),
    );
  }
}

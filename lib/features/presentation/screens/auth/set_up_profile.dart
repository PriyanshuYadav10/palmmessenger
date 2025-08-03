import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/config/theme/spaces.dart';
import 'package:palmmessenger/features/presentation/screens/Dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme/textstyles.dart';
import '../../../../core/constants/images.dart';
import '../../../data/encryption/rsa_key_helper.dart';
import '../../../helper/alertDiaolg.dart';
import '../../../provider/authProvider.dart';
import '../../utility/app_shared_prefrence.dart';
import '../../utility/global.dart';
import '../../utility/gradient_text.dart';
import '../../widgets/button.dart';
import '../../widgets/textfeild.dart';

class SetUpProfileScreen extends StatefulWidget {
  const SetUpProfileScreen({super.key});

  @override
  State<SetUpProfileScreen> createState() => _SetUpProfileScreenState();
}

class _SetUpProfileScreenState extends State<SetUpProfileScreen> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController aboutCtrl = TextEditingController();
  XFile? selectedImage;

  Future<void> setUpProfile() async {
    Map<String, dynamic> param={
      "bio":aboutCtrl.text,
      "name":nameCtrl.text,
    };
    File imageFile = File(selectedImage!.path);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.updateProfile(param,imageFile);
    if (authProvider.profileUpdateModel?.message != ''){
      if(authProvider.isLoading==false) {
        showAlertSuccess(
            authProvider.profileUpdateModel!.message.toString(), context);
        Get.offAll(DashboardScreen(),);
        publicKeyApi();
      }
    }else{
      showAlertError(authProvider.message, context);
    }
  }

  var privatePem = '';
  var publicPem = '';
  @override
  void initState() {
    // TODO: implement initState

    final keyPair = RSAKeyHelper.generateKeyPair();
    privatePem = RSAKeyHelper.encodePrivateKeyToPemPKCS1(keyPair.privateKey);
    publicPem = RSAKeyHelper.encodePublicKeyToPemPKCS1(keyPair.publicKey);
    final prefs = AppSharedPref();
    prefs.save("privateKey", privatePem);
    super.initState();
  }
  Future<void> publicKeyApi() async {
    Map<String, dynamic> param = {"publicKey": publicPem};
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.publicKey(param);

    if (authProvider.publicKeyModel?.message != '') {

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
            decoration: BoxDecoration(
                image:
                DecorationImage(image: AssetImage(app_bg), fit: BoxFit.cover)),
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: GradientText('Set up your profile',style: Styles.extraBoldTextStyle(size: 35),),
                ),
                hSpace(20),
                Text('Customize your Palm Messenger Identity',textAlign: TextAlign.center ,style: Styles.mediumTextStyle(size: 15,color: ColorResources.whiteColor.withOpacity(0.5)),),
                hSpace(15),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(profileCircle))
                      ),
                      alignment: Alignment.center,
                      child:selectedImage != null?CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius:50, backgroundImage: FileImage(File(selectedImage!.path))): CircleAvatar(
                        backgroundColor: Colors.transparent,
                          radius:50, child: Image.asset(dummyProfile),),
                    ),
                    InkWell(
                      onTap: (){
                        pickImage(ImageSource.camera);
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: ColorResources.secondaryColor,
                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: ColorResources.blackColor,
                                          child: Icon(Icons.camera_alt_outlined,color: ColorResources.whiteColor),
                                        ),
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: (){
                    showProfileBottomSheet(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorResources.secondaryColor),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 50,vertical: 15),
                    child: Text('Change Profile Picture',style: Styles.semiBoldTextStyle(color: ColorResources.whiteColor),),
                  ),
                ),
                hSpace(25),
                Text(
                  'Name',
                  style: Styles.mediumTextStyle(
                      size: 15, color: ColorResources.whiteColor),
                ),
                hSpace(5),
                buildTextField(nameCtrl, '',
                    MediaQuery.sizeOf(context).width * 0.57, 45, TextInputType.text,
                    fun: () {}),
                hSpace(15),
                Text(
                  'About(optional)',
                  style: Styles.mediumTextStyle(
                      size: 15, color: ColorResources.whiteColor),
                ),
                hSpace(5),
                buildTextField(aboutCtrl, '',
                    MediaQuery.sizeOf(context).width * 0.57, 45, TextInputType.text,
                    fun: () {}),
                hSpace(50),
                customButton(() {
                  setUpProfile();
                }, 'Submit', context,isLoading: authProvider.isLoading),
              ],
            ),
          ),
        );
      }
    );
  }
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
      print("Picked image path: ${selectedImage!.path}");
    }
  }
  void showProfileBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.only(top: 5, bottom: 0),
          decoration: BoxDecoration(
            gradient: GradientColor.gradient1,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(22),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top bar and title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white,size: 20,),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Profile Picture",
                      style: Styles.semiBoldTextStyle(size: 18,color: ColorResources.whiteColor)
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
                SizedBox(width: 20),
                // Options: Camera, Gallery, AI Avatar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _iconButton(camera, "Camera", () {
                    Navigator.pop(context);
                    pickImage(ImageSource.camera);
                    }),
                    _iconButton(gallery, "Gallery", () {
                      Navigator.pop(context);
                      pickImage(ImageSource.gallery);
                    }),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _iconButton(String icon, String label,VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(icon, color: ColorResources.secondaryColor, width: 40),
          hSpace(10),
          Text(
            label,
            style: Styles.mediumTextStyle(size: 16,color: ColorResources.whiteColor),
          ),
        ],
      ),
    );
  }

}

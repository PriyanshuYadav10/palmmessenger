import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/config/theme/spaces.dart';
import 'package:palmmessenger/features/presentation/widgets/textfeild.dart';
import 'package:palmmessenger/features/provider/chatProvider.dart';
import 'package:provider/provider.dart';
import '../../../../../config/theme/app_themes.dart';
import '../../../../../config/theme/textstyles.dart';
import '../../../../../core/constants/images.dart';
import '../../../../data/encryption/rsa_helper.dart';
import '../../../../data/encryption/rsa_key_helper.dart';
import '../../../../data/model/group_model.dart';
import '../../../../helper/database_service.dart';
import '../../../../helper/websocket_service.dart';
import '../../../utility/app_shared_prefrence.dart';
import '../../../utility/global.dart';
import '../../../widgets/button.dart';

class GroupDescriptionScreen extends StatefulWidget {
  final String localUserId;
  final RSAHelper rsaHelper;
  final String privateKeyPem;
  final SecureStorageService storage;
  final WebSocketService socket;
  final List<String> memberIds;

  const GroupDescriptionScreen({super.key, required this.memberIds,
    required this.localUserId,
    required this.rsaHelper,
    required this.privateKeyPem,
    required this.storage,
    required this.socket,});

  @override
  State<GroupDescriptionScreen> createState() => _GroupDescriptionScreenState();
}

class _GroupDescriptionScreenState extends State<GroupDescriptionScreen> {
  final TextEditingController _groupNameController = TextEditingController();

  Future<void> _createGroup() async {
    if (_groupNameController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter group name")),
      );
      return;
    }

    final keyPair = RSAKeyHelper.generateKeyPair();
    var privatePem = RSAKeyHelper.encodePrivateKeyToPemPKCS1(keyPair.privateKey);
    var publicPem = RSAKeyHelper.encodePublicKeyToPemPKCS1(keyPair.publicKey);

    Map<String, dynamic> param = {
      "name": _groupNameController.text,
      "members": widget.memberIds,
      "privateKey": privatePem,
      "publicKey": publicPem,
    };

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    await chatProvider.createGroupAPi(param);

    final prefs = AppSharedPref();
    prefs.save("privateKey_${chatProvider.groupId}", privatePem);
    prefs.save("publicKey_${chatProvider.groupId}", publicPem);

    if (!mounted) return; // <-- check before popping
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.appColor,
        title: Text(
         'Group Description',
          style: Styles.semiBoldTextStyle(
              size: 22, color: ColorResources.whiteColor),
        ),
        leading: Icon(Icons.arrow_back_ios_new_rounded,
            color: ColorResources.whiteColor),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          padding: EdgeInsets.all(16),
          decoration:appTheme.toString().toLowerCase()=='dark'? BoxDecoration(
              image: DecorationImage(image: AssetImage(app_bg),fit: BoxFit.cover)
          ):BoxDecoration(
              color: ColorResources.whiteColor
          ),
          child: Column(
            children: [
              hSpace(30),
              buildTextField(_groupNameController, 'Add group description', MediaQuery.sizeOf(context).width ,45,TextInputType.text,txtColor: appTheme.toString().toLowerCase()!='dark'?ColorResources.blackColor:ColorResources.whiteColor),
              hSpace(20),
              Text('The group description is visible to members of the group and people invited to this group.',style: Styles.mediumTextStyle(color:appTheme.toString().toLowerCase()!='dark'?ColorResources.blackColor: ColorResources.whiteColor,size: 12),),
              hSpace(200),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customButton((){
                    Get.back();
                    },'Cancel', context,
                      width: 150,
                      height: 50,
                      isLoading: false,
                      borderGradient: const LinearGradient(
                        colors: [Colors.purple, Colors.blue],
                      ),
                      radius: 15,
                      color: ColorResources.appColor,
                      txtColor: Colors.white,),
                    customButton((){
                      _createGroup();
                    },'Save', context,
                      width: 150,
                      height: 50,
                      isLoading: false,
                      borderGradient: const LinearGradient(
                        colors: [Colors.purple, Colors.blue],
                      ),
                      radius: 15,
                      color: ColorResources.appColor,
                      txtColor: Colors.white,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

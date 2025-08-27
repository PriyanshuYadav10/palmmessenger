import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/features/data/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../../../config/theme/app_themes.dart';
import '../../../../../config/theme/textstyles.dart';
import '../../../../../core/constants/images.dart';
import '../../../../data/encryption/rsa_helper.dart';
import '../../../../helper/database_service.dart';
import '../../../../helper/websocket_service.dart';
import '../../../../provider/homeProvider.dart';
import 'chat_screen.dart';

class ContactListScreen extends StatefulWidget {
  String? localUserId;
  RSAHelper? rsaHelper;
  String? privateKeyPem;
  SecureStorageService? storage;
  WebSocketService? socket;

  ContactListScreen({
    required this.localUserId,
    required this.rsaHelper,
    required this.privateKeyPem,
    required this.storage,
    required this.socket,
  });

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<HomeProvider>(context, listen: false).fetchContactsAndSend();
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    print(homeProvider.contacts);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: ColorResources.appColor,
        title: Text('Contacts',
            style: Styles.semiBoldTextStyle(
                size: 22, color: ColorResources.whiteColor)),
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new_rounded,
              color: ColorResources.whiteColor),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(app_bg), fit: BoxFit.cover),
        ),
        child: homeProvider.isLoadingContacts
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: homeProvider.contact?.users?.length ?? 0,
          itemBuilder: (context, index) {
            final contact = homeProvider.contact?.users![index];
            final peerUserId = contact!.sId!.isNotEmpty
                ? contact.phoneNo!.replaceAll(' ', '')
                : 'unknown'; // used as unique ID
            final peerName = contact.name;

            return ListTile(
              leading: contact.profilePicture != null
                  ? CircleAvatar(
                backgroundImage:
                NetworkImage(contact.profilePicture!),
              )
                  : CircleAvatar(
                child: Text(contact.name?[0]??''),
              ),
              title: Text(peerName.toString(),
                  style: Styles.semiBoldTextStyle(
                      color: ColorResources.whiteColor, size: 16)),
              subtitle: Text(
                  contact.phoneNo.toString(),
                  style: Styles.mediumTextStyle(
                      color: ColorResources.whiteColor, size: 13)),
              onTap: () {
                if (peerUserId != 'unknown') {
                  widget.storage?.saveUser( UserModel(id: contact.sId.toString(), name: contact.name.toString() , publicKey: contact.publicKey.toString(),avatarPath: contact.profilePicture.toString()));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        peer: UserModel(id: contact.sId.toString(), name: contact.name.toString() , publicKey: contact.publicKey.toString()),
                        localUserId: widget.localUserId.toString(),
                        privateKeyPem: widget.privateKeyPem.toString(),
                        rsaHelper: widget.rsaHelper,
                      storage: widget.storage,
                        socket: widget.socket,
                      ),
                    ),
                  );
                } else {
                  Get.snackbar("Invalid Contact", "This contact has no phone number");
                }
              },
            );
          },
        ),
      ),
    );
  }
}

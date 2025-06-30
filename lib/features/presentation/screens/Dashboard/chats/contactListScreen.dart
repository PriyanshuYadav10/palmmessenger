import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../config/theme/app_themes.dart';
import '../../../../../config/theme/textstyles.dart';
import '../../../../../core/constants/images.dart';
import '../../../../provider/homeProvider.dart';

class ContactListScreen extends StatefulWidget {
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

      // Delay the call until after the build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final homeProvider = Provider.of<HomeProvider>(context, listen: false);
        homeProvider.loadContacts();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: ColorResources.appColor,
        automaticallyImplyLeading: false,
        title: Text('Contacts',style: Styles.semiBoldTextStyle(size: 22,color: ColorResources.whiteColor)),
        leading: InkWell(
            onTap: (){
                Get.back();
            },
            child: Icon(Icons.arrow_back_ios_new_rounded,color: ColorResources.whiteColor)),
        centerTitle: false,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(app_bg),fit: BoxFit.cover)
        ),
        child: homeProvider.isLoadingContacts
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: homeProvider.contacts?.length ?? 0,
          itemBuilder: (context, index) {
            final contact = homeProvider.contacts![index];
            return ListTile(
              leading:contact.photoOrThumbnail != null
                  ? CircleAvatar(
                backgroundImage: MemoryImage(contact.photoOrThumbnail!),
              )
                  : CircleAvatar(
                child: Text(
                  contact.displayName.isNotEmpty ? contact.displayName[0] : '?',
                ),
              ),
              title: Text(contact.displayName,style: Styles.semiBoldTextStyle(color: ColorResources.whiteColor,size: 16),),
              subtitle: Text(contact.phones.isNotEmpty ? contact.phones.first.number : 'No number',style: Styles.mediumTextStyle(color: ColorResources.whiteColor,size: 13),),
            );
          },
        ),
      ),
    );
  }
}

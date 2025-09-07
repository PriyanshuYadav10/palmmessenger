import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palmmessenger/features/data/model/user_model.dart';
import 'package:palmmessenger/features/presentation/screens/Dashboard/chats/create_group.dart';
import 'package:provider/provider.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../../../config/theme/app_themes.dart';
import '../../../../../config/theme/textstyles.dart';
import '../../../../../core/constants/images.dart';
import '../../../../data/encryption/rsa_helper.dart';
import '../../../../data/model/contacts_user_model.dart';
import '../../../../helper/database_service.dart';
import '../../../../helper/websocket_service.dart';
import '../../../../provider/homeProvider.dart';
import 'chat_screen.dart';

class ContactListScreen extends StatefulWidget {
 final String localUserId;
 final RSAHelper rsaHelper;
 final String privateKeyPem;
 final SecureStorageService storage;
 final WebSocketService socket;

  const ContactListScreen({
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
  bool _isSelectingGroup = false;
  Set<String> _selectedContacts = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<HomeProvider>(context, listen: false)
            .fetchContactsAndSend();
      });
    }
  }

  void _toggleGroupMode() {
    setState(() {
      _isSelectingGroup = !_isSelectingGroup;
      _selectedContacts.clear();
    });
  }

  void _onContactTap(Users contact) {
    if (_isSelectingGroup) {
      setState(() {
        if (_selectedContacts.contains(contact.sId)) {
          _selectedContacts.remove(contact.sId);
        } else {
          _selectedContacts.add(contact.sId!);
        }
      });
    } else {
      // Normal single chat flow
      widget.storage?.saveUser( UserModel(id: contact.sId.toString(), name: contact.name.toString() , publicKey: contact.publicKey.toString(),avatarPath: contact.profilePicture.toString()));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            peer: UserModel(id: contact.sId.toString(), name: contact.name.toString() , publicKey: contact.publicKey.toString()),
            localUserId: widget.localUserId.toString(),
            groupId: null,
            groupName: null,
            groupPrivateKey: null,
            groupPublicKey: null,
            privateKeyPem: widget.privateKeyPem.toString(),
            rsaHelper: widget.rsaHelper,
            storage: widget.storage,
            socket: widget.socket,
          ),
        ),
      );
    }
  }

  void _createGroup(BuildContext context, List<Users> users) {
    if (_selectedContacts.length < 3) {
      Get.snackbar("Alert", "Please select at least 3 users",colorText: ColorResources.whiteColor);
      return;
    }

    final selectedUsers = users
        .where((u) => _selectedContacts.contains(u.sId))
        .toList();

    Get.off(GroupDescriptionScreen(memberIds: _selectedContacts.toList(), localUserId: widget.localUserId,
      rsaHelper: widget.rsaHelper,
      privateKeyPem: widget.privateKeyPem,
      storage: widget.storage,
      socket: widget.socket,));
    _toggleGroupMode();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: ColorResources.appColor,
        title: Text(
          _isSelectingGroup ? 'Select Contacts' : 'Contacts',
          style: Styles.semiBoldTextStyle(
              size: 22, color: ColorResources.whiteColor),
        ),
        leading: InkWell(
          onTap: () {
            if (_isSelectingGroup) {
              _toggleGroupMode();
            } else {
              Get.back();
            }
          },
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
            : Column(
              children: [
                SizedBox(
                  height: _selectedContacts.isEmpty ? 0 : 100,
                  child: Stack(
                    children: [
                      // Contact list
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedContacts.length,
                          itemBuilder: (context, index) {
                            var selectedId = _selectedContacts.toList()[index];
                            var contact = homeProvider.contact?.users
                                ?.firstWhere((u) => u.sId == selectedId, orElse: () => Users());

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundImage: (contact?.profilePicture != null &&
                                            contact!.profilePicture!.isNotEmpty)
                                            ? NetworkImage(contact.profilePicture!)
                                            : null,
                                        child: (contact?.profilePicture == null ||
                                            contact!.profilePicture!.isEmpty)
                                            ? Text(contact?.name?[0] ?? '?')
                                            : null,
                                      ),
                                      Positioned(
                                        right: -2,
                                        top: -2,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedContacts.remove(selectedId);
                                            });
                                          },
                                          child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Colors.red,
                                            child: Icon(Icons.close, size: 14, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    contact?.name ?? "Unknown",
                                    style: Styles.mediumTextStyle(
                                        color: ColorResources.whiteColor, size: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // ✅ Fixed check mark on right
                      Positioned(
                        right: 12,
                        top: 20,
                        child: GestureDetector(
                          onTap: () => _createGroup(context, homeProvider.contact?.users ?? []),
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            color: ColorResources.whiteColor,
                            ),
                            child: Icon(Icons.check, color: ColorResources.appColor, size: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: (homeProvider.contact?.users?.length ?? 0) +
                        (!_isSelectingGroup ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (!_isSelectingGroup && index == 0) {
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.group_add, color: Colors.white),
                          ),
                          title: Text(
                            "Create Group",
                            style: Styles.semiBoldTextStyle(
                              color: ColorResources.whiteColor,
                              size: 16,
                            ),
                          ),
                          onTap: _toggleGroupMode,
                        );
                      }

                      // Adjust index if Create Group is shown
                      final adjustedIndex = !_isSelectingGroup ? index - 1 : index;
                      final contact = homeProvider.contact?.users?[adjustedIndex];

                      if (contact == null) return const SizedBox();

                      final peerUserId = (contact.sId?.isNotEmpty ?? false)
                          ? contact.phoneNo?.replaceAll(' ', '') ?? "unknown"
                          : "unknown";

                      final isSelected = _selectedContacts.contains(contact.sId);

                      return Container(
                        color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                        child: ListTile(
                          leading: (contact.profilePicture != null &&
                              contact.profilePicture!.isNotEmpty)
                              ? CircleAvatar(
                            backgroundImage: NetworkImage(contact.profilePicture!),
                          )
                              : CircleAvatar(
                            child: Text(contact.name?.isNotEmpty == true
                                ? contact.name![0]
                                : "?"),
                          ),
                          title: Text(
                            contact.name ?? "Unknown",
                            style: Styles.semiBoldTextStyle(
                              color: ColorResources.whiteColor,
                              size: 16,
                            ),
                          ),
                          subtitle: Text(
                            contact.phoneNo ?? "",
                            style: Styles.mediumTextStyle(
                              color: ColorResources.whiteColor,
                              size: 13,
                            ),
                          ),
                          onTap: () {
                            if (peerUserId != "unknown") {
                              _onContactTap(contact);
                            } else {
                              Get.snackbar("Invalid Contact", "This contact has no phone number");
                            }
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
      ),
    );
  }
}

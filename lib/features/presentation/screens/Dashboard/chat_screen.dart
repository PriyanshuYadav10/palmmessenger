import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/app_themes.dart';
import '../../../../config/theme/spaces.dart';
import '../../../../config/theme/textstyles.dart';
import '../../../../core/constants/images.dart';
import '../../../data/encryption/rsa_helper.dart';
import '../../../data/model/message_model.dart';
import '../../../data/model/user_model.dart';
import '../../../helper/database_service.dart';
import '../../../helper/websocket_service.dart';
import '../../../provider/homeProvider.dart';
import '../../utility/gradient_text.dart';
import '../../widgets/textfeild.dart';
import 'chat_screen.dart';
import 'chats/chat_screen.dart';
import 'chats/contactListScreen.dart';

class ChatListScreen extends StatefulWidget {
  final String localUserId;
  final RSAHelper rsaHelper;
  final String privateKeyPem;
  final SecureStorageService storage;
  final WebSocketService socket;

  const ChatListScreen({
    super.key,
    required this.localUserId,
    required this.rsaHelper,
    required this.privateKeyPem,
    required this.storage,
    required this.socket,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final StreamController<List<LatestChatModel>> _chatStreamController =
  StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _loadChats();
    Provider.of<HomeProvider>(context, listen: false).fetchContactsAndSend();
    widget.socket.connect();
    widget.socket.onMessageReceived = (msg) async {
      if (msg["message"] == "image" && msg["attachment"] != null) {

        final model = MessageModel(
          id: msg['messageId'],
          senderId: msg['from'],
          receiverId: msg['to'],
          content:  '',
          encrypted: '',
          attachment: msg['attachment']??'',
          timestamp: DateTime.fromMillisecondsSinceEpoch(msg['timestamp']),
        );

        // Save message
        await widget.storage.saveMessage(model);

        // Find peer user (the other user in this chat)
        final peerId = model.senderId == widget.localUserId ? model.receiverId : model.senderId;

        // Check if user already exists
        var peerUser = await widget.storage.getUser(peerId);

        if (peerUser == null) {
          // Not in storage, try to find in contacts (from DB or Provider)
          final homeProvider = Provider.of<HomeProvider>(context, listen: false);
          final contact = homeProvider.contact?.users?.firstWhere(
                (c) => c.sId == peerId,
          );

          if (contact != null) {
            // Save contact into storage
            peerUser = UserModel(
              id: contact.sId.toString(),
              name: contact.name.toString(),
              publicKey: contact.publicKey.toString(),
              avatarPath: contact.profilePicture.toString(),
            );
            await widget.storage.saveUser(peerUser);
          }
        }
      }else {
        final decrypted = widget.rsaHelper.decryptWithPrivateKey(
          msg['message'],
          widget.privateKeyPem,
        );


        final model = MessageModel(
          id: msg['messageId'],
          senderId: msg['from'],
          receiverId: msg['to'],
          content: decrypted ?? '',
          encrypted: msg['message'],
          attachment: msg['attachment'] ?? '',
          timestamp: DateTime.fromMillisecondsSinceEpoch(msg['timestamp']),
        );

        // Save message
        await widget.storage.saveMessage(model);

        // Find peer user (the other user in this chat)
        final peerId = model.senderId == widget.localUserId
            ? model.receiverId
            : model.senderId;

        // Check if user already exists
        var peerUser = await widget.storage.getUser(peerId);

        if (peerUser == null) {
          // Not in storage, try to find in contacts (from DB or Provider)
          final homeProvider = Provider.of<HomeProvider>(
              context, listen: false);
          final contact = homeProvider.contact?.users?.firstWhere(
                (c) => c.sId == peerId,
          );

          if (contact != null) {
            // Save contact into storage
            peerUser = UserModel(
              id: contact.sId.toString(),
              name: contact.name.toString(),
              publicKey: contact.publicKey.toString(),
              avatarPath: contact.profilePicture.toString(),
            );
            await widget.storage.saveUser(peerUser);
          }
        }
      }
      // Now reload chats
      _loadChats();`
    };

  }
  Future<void> _loadChats() async {
    final latestMessages = await widget.storage.getLatestMessages(widget.localUserId);

    List<LatestChatModel> chats = [];
    for (var msg in latestMessages) {
      final peerId = msg.senderId == widget.localUserId ? msg.receiverId : msg.senderId;
      final peerUser = await widget.storage.getUser(peerId);
      if (peerUser != null) {
        final unread = await widget.storage.getUnreadMessageCount(widget.localUserId, peerId);
        chats.add(LatestChatModel(message: msg, peerUser: peerUser, unreadCount: unread.toString()));
      }
    }

    _chatStreamController.add(chats);
  }

  @override
  void dispose() {
    _chatStreamController.close();
    super.dispose();
  }
  int selectedFilter = 0;
  TextEditingController searchCtrl =TextEditingController();
  List<String> filters = ['All', 'Unread', 'Groups', 'Calls'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric( vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientText('Chats',style: Styles.boldTextStyle(size: 40)),
                    Row(
                      children: [
                        Image.asset(chat_people,width:35,height: 25,fit: BoxFit.cover,),
                        wSpace(10),
                        InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ContactListScreen(
                                    localUserId: widget.localUserId,
                                    rsaHelper: widget.rsaHelper,
                                    privateKeyPem: widget.privateKeyPem,
                                    storage: widget.storage,
                                    socket: widget.socket,
                                  ),
                                ),
                              );
                            },
                            child: Image.asset(add,width:40,fit: BoxFit.cover)),
                      ],
                    )
                  ],
                ),
              ),
              hSpace(20),
              buildTextField(searchCtrl, 'search', MediaQuery.sizeOf(context).width, 45, TextInputType.text,prefixIcon: Icon(Icons.search,color: ColorResources.whiteColor),postfixIcon: Icon(Icons.mic,color: ColorResources.whiteColor),radius:40, ),
              hSpace(20),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    bool isSelected = index == selectedFilter;
                    return GestureDetector(
                      onTap: () => setState(() => selectedFilter = index),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient:isSelected? GradientColor.gradient1:null,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ColorResources.blackColor
                                : ColorResources.secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                              filters[index],
                              style:Styles.semiBoldTextStyle(color:ColorResources.whiteColor,size: 14)
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              hSpace(15),
              Expanded(
                child:StreamBuilder<List<LatestChatModel>>(
                  stream: _chatStreamController.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final chats = snapshot.data!;
                    if (chats.isEmpty) {
                      return const Center(child: Text("No chats yet"));
                    }
                    return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  peer: chat.peerUser,
                                  localUserId: widget.localUserId,
                                  rsaHelper: widget.rsaHelper,
                                  privateKeyPem: widget.privateKeyPem,
                                  storage: widget.storage,
                                  socket: widget.socket,
                                ),
                              ),
                            ).then((_) {
                              _loadChats();
                            });
                          },
                          child: _chatTile(
                            chat.peerUser.name,
                            chat.message.content.toString()==''?'send a image':'',
                            DateFormat('hh:mm a').format(chat.message.timestamp),
                            chat.peerUser.avatarPath,
                            unread: int.parse(chat.unreadCount.toString()),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Widget _chatTile(String name, String message, String time, String? avatarPath, {int unread = 0}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: ColorResources.secondaryColor,
          backgroundImage: NetworkImage(avatarPath!),
          radius: 25,
        ),
        wSpace(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: Styles.semiBoldTextStyle(size: 15,color: ColorResources.whiteColor)),
              hSpace(4),
              Text(message,
                  overflow: TextOverflow.ellipsis,
                  style:  Styles.mediumTextStyle(color: ColorResources.whiteColor.withOpacity(0.7),size: 15)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(time,
                style: Styles.mediumTextStyle(color: ColorResources.whiteColor.withOpacity(0.9))),
            hSpace(4),
            if (unread > 0)
              Container(
                decoration: BoxDecoration(
                  gradient: GradientColor.gradient1,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: ColorResources.blackColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    unread.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
class LatestChatModel {
  final MessageModel message;
  final UserModel peerUser;
  final String unreadCount;

  LatestChatModel({required this.message, required this.peerUser,required this.unreadCount});
}
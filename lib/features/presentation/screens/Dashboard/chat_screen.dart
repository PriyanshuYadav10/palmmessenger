import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palmmessenger/features/provider/chatProvider.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/app_themes.dart';
import '../../../../config/theme/spaces.dart';
import '../../../../config/theme/textstyles.dart';
import '../../../../core/constants/images.dart';
import '../../../data/encryption/rsa_helper.dart';
import '../../../data/model/group_model.dart';
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

    Provider.of<ChatProvider>(context, listen: false).userGroups();
    Provider.of<HomeProvider>(context, listen: false).fetchContactsAndSend();

    widget.socket.connect();

    // ✅ Listen to new messages from socket
    widget.socket.onMessageReceived =((msg) async {
      print("📩 Incoming msg: $msg");

      final bool isGroup =
          msg['isGroup'] == true || (msg['groupId'] != null && msg['groupId'].toString().isNotEmpty);

      if (isGroup) {
        final groupId = msg['groupId'] ?? '';
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        final group = chatProvider.groupModels.firstWhere(
              (g) => g.sId == groupId,
          orElse: () => GroupModel(),
        );

        final contentType = msg["message"]?.toString().toLowerCase();
        final isImage = contentType == "image";
        final isAudio = contentType == "audio";

        final model = MessageModel(
          id: msg['messageId'],
          senderId: msg['from'],
          receiverId: groupId,
          content: isImage
              ? "image"
              : isAudio
              ? "audio"
              : widget.rsaHelper.decryptWithPrivateKey(
            msg['message'],
            group.privateKey.toString(),
          ),
          groupId: groupId,
          encrypted: isImage || isAudio ? "" : msg['message'],
          attachment: msg['attachment'] ?? '',
          timestamp: DateTime.fromMillisecondsSinceEpoch(msg['timestamp']),
        );

        await widget.storage.saveMessage(model);
      } else {
        // 1-to-1
        final peerId =
        msg['from'] == widget.localUserId ? msg['to'] : msg['from'];

        final contentType = msg["message"]?.toString().toLowerCase();
        final decrypted = (contentType == "image" || contentType == "audio")
            ? contentType
            : widget.rsaHelper.decryptWithPrivateKey(
          msg['message'],
          widget.privateKeyPem,
        );

        final model = MessageModel(
          id: msg['messageId'],
          senderId: msg['from'],
          receiverId: msg['to'],
          groupId: msg['groupId'] ?? '',
          content: decrypted ?? '',
          encrypted: msg['message'] ?? '',
          attachment: msg['attachment'] ?? '',
          timestamp: DateTime.fromMillisecondsSinceEpoch(msg['timestamp']),
        );

        await widget.storage.saveMessage(model);

        // Save peer if new
        var peerUser = await widget.storage.getUser(peerId);
        if (peerUser == null) {
          final homeProvider = Provider.of<HomeProvider>(context, listen: false);
          final contact = homeProvider.contact?.users?.firstWhere(
                (c) => c.sId == peerId,
            // orElse: () => null,
          );

          peerUser = UserModel(
            id: contact?.sId ?? peerId,
            name: contact?.name ?? "Unknown",
            publicKey: contact?.publicKey ?? "",
            avatarPath: contact?.profilePicture ?? "",
          );
          await widget.storage.saveUser(peerUser);
        }
      }

      _loadChats();
    });
  }

  Future<void> _loadChats() async {
    final latestMessages =
    await widget.storage.getLatestMessages(widget.localUserId);

    List<LatestChatModel> chats = [];

    // ---- SINGLE ----
    for (var msg in latestMessages) {
      final peerId =
      msg.senderId == widget.localUserId ? msg.receiverId : msg.senderId;
      final peerUser = await widget.storage.getUser(peerId);
      if (peerUser != null) {
        final unread =
        await widget.storage.getUnreadMessageCount(widget.localUserId, peerId);
        chats.add(LatestChatModel(
          message: msg,
          peerUser: peerUser,
          unreadCount: unread.toString(),
          isGroup: false,
        ));
      }
    }

    // ---- GROUP ----
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    for (var group in chatProvider.groupModels) {
      final groupMessages =
      await widget.storage.getMessages(widget.localUserId, group.sId ?? "");
      if (groupMessages.isNotEmpty) {
        final lastMsg = groupMessages.last;
        final unread = groupMessages.where((m) => !m.isRead).length;
        chats.add(LatestChatModel(
          message: lastMsg,
          peerUser: null,
          unreadCount: unread.toString(),
          isGroup: true,
          groupName: group.name,
          groupId: group.sId,
          groupAvatar:  "",
          groupPublicKey: group.publicKey,
          groupPrivateKey: group.privateKey,
        ));
      }
    }

    chats.sort((a, b) => b.message.timestamp.compareTo(a.message.timestamp));
    _chatStreamController.add(chats);
  }

  @override
  void dispose() {
    _chatStreamController.close();
    super.dispose();
  }

  int selectedFilter = 0;
  TextEditingController searchCtrl = TextEditingController();
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
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientText('Chats',
                        style: Styles.boldTextStyle(size: 40)),
                    Row(
                      children: [
                        Image.asset(chat_people,
                            width: 35, height: 25, fit: BoxFit.cover),
                        wSpace(10),
                        InkWell(
                          onTap: () {
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
                          child: Image.asset(add, width: 40, fit: BoxFit.cover),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              hSpace(20),
              buildTextField(
                searchCtrl,
                'search',
                MediaQuery.sizeOf(context).width,
                45,
                TextInputType.text,
                prefixIcon:
                Icon(Icons.search, color: ColorResources.whiteColor),
                postfixIcon:
                Icon(Icons.mic, color: ColorResources.whiteColor),
                radius: 40,
              ),
              hSpace(20),

              // Filters
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
                          gradient:
                          isSelected ? GradientColor.gradient1 : null,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(2),
                          padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ColorResources.blackColor
                                : ColorResources.secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(filters[index],
                              style: Styles.semiBoldTextStyle(
                                  color: ColorResources.whiteColor, size: 14)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              hSpace(15),

              // Chats
              Expanded(
                child: StreamBuilder<List<LatestChatModel>>(
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  peer: chat.isGroup ? null : chat.peerUser!,
                                  localUserId: widget.localUserId,
                                  rsaHelper: widget.rsaHelper,
                                  privateKeyPem: widget.privateKeyPem,
                                  storage: widget.storage,
                                  socket: widget.socket,
                                  groupId: chat.isGroup ? chat.groupId : null,
                                  groupName:
                                  chat.isGroup ? chat.groupName : null,
                                  groupPrivateKey:
                                  chat.isGroup ? chat.groupPrivateKey : null,
                                  groupPublicKey:
                                  chat.isGroup ? chat.groupPublicKey : null,
                                ),
                              ),
                            ).then((_) => _loadChats());
                          },
                          child: _chatTile(
                            chat.isGroup
                                ? chat.groupName!
                                : chat.peerUser!.name,
                            chat.message.content == "image"
                                ? "📷 Image"
                                : chat.message.content == "audio"
                                ? "🎵 Audio"
                                : chat.message.content,
                            DateFormat('hh:mm a')
                                .format(chat.message.timestamp),
                            chat.isGroup
                                ? chat.groupAvatar
                                : chat.peerUser!.avatarPath,
                            unread: int.parse(chat.unreadCount),
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

Widget _chatTile(String name, String message, String time, String? avatarPath,
    {int unread = 0}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: ColorResources.secondaryColor,
          backgroundImage: (avatarPath != null && avatarPath.isNotEmpty)
              ? NetworkImage(avatarPath)
              : null,
          child: (avatarPath == null || avatarPath.isEmpty)
              ? Icon(Icons.person, color: Colors.white)
              : null,
          radius: 25,
        ),
        wSpace(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: Styles.semiBoldTextStyle(
                      size: 15, color: ColorResources.whiteColor)),
              hSpace(4),
              Text(message,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.mediumTextStyle(
                      color: ColorResources.whiteColor.withOpacity(0.7),
                      size: 15)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(time,
                style: Styles.mediumTextStyle(
                    color: ColorResources.whiteColor.withOpacity(0.9))),
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
                  child: Text(unread.toString(),
                      style:
                      const TextStyle(color: Colors.white, fontSize: 12)),
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
  final UserModel? peerUser;
  final String unreadCount;
  final bool isGroup;
  final String? groupName;
  final String? groupId;
  final String? groupAvatar;
  final String? groupPublicKey;
  final String? groupPrivateKey;

  LatestChatModel({
    required this.message,
    this.peerUser,
    required this.unreadCount,
    this.isGroup = false,
    this.groupName,
    this.groupId,
    this.groupAvatar,
    this.groupPrivateKey,
    this.groupPublicKey,
  });
}

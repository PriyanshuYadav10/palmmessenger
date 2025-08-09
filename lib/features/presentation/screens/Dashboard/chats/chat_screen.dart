import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/constants/images.dart';
import '../../../../data/encryption/rsa_helper.dart';
import '../../../../data/model/message_model.dart';
import '../../../../data/model/user_model.dart';
import '../../../../helper/database_service.dart';
import '../../../../helper/websocket_service.dart';

class ChatScreen extends StatefulWidget {
  UserModel? peer;
  String? localUserId;
  RSAHelper? rsaHelper;
  String? privateKeyPem;
  DBService? db;
  WebSocketService? socket;

  ChatScreen({
    required this.peer,
    required this.localUserId,
    required this.rsaHelper,
    required this.privateKeyPem,
    required this.db,
    required this.socket,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<MessageModel> messages = [];

  @override
  void initState() {
    super.initState();
    loadChat();

    widget.socket?.onMessageReceived = (msg) async {
      final decrypted = widget.rsaHelper?.decryptWithPrivateKey(
        msg['message'],
        widget.privateKeyPem.toString(),
      );

      final model = MessageModel(
        id: msg['messageId'],
        senderId: msg['from'],
        receiverId: msg['to'],
        content: decrypted.toString(),
        encrypted: msg['message'],
        timestamp: DateTime.fromMillisecondsSinceEpoch(msg['timestamp']),
      );

      await widget.db?.insertMessage(model);
      loadChat();

      // Send "delivered" update
      widget.socket?.sendMessageUpdate(
        messageId: msg['messageId'],
        to: msg['from'],
        status: 'delivered',
      );
    };

    widget.socket?.onMessageUpdate = (update) {
      // Optional: You can mark the message as seen/delivered in local DB
      print("Message status update: $update");
    };
  }

  Future<void> loadChat() async {
    final data = await widget.db?.getMessages(
      widget.localUserId.toString(),
      widget.peer!.id,
    );
    if (mounted) setState(() => messages = data ?? []);
  }

  void sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final encrypted = widget.rsaHelper?.encryptWithPublicKey(
      text,
      widget.peer!.publicKey.toString(),
    );

    final messageId = const Uuid().v4();
    final timestamp = DateTime.now();

    final model = MessageModel(
      id: messageId.toString(),
      senderId: widget.localUserId.toString(),
      receiverId: widget.peer!.id,
      content: text,
      encrypted: encrypted.toString(),
      timestamp: timestamp,
    );

    widget.socket?.sendMessage(
      to: widget.peer!.id,
      message: encrypted.toString(),
    );

    await widget.db?.insertMessage(model);
    _controller.clear();
    loadChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(widget.peer!.name,style: Styles.semiBoldTextStyle(color: ColorResources.whiteColor,size: 23),),
          automaticallyImplyLeading: false,
          leading: Icon(Icons.arrow_back_ios_new_rounded,color: ColorResources.whiteColor,),
      ),
      body: Container(decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(app_bg), fit: BoxFit.cover),
      ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isMe = msg.senderId == widget.localUserId;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(msg.content),
                          SizedBox(height: 4),
                          Text(
                            DateFormat('hh:mm a').format(msg.timestamp),
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(hintText: "Type message"),
                    ),
                  ),
                  IconButton(
                    onPressed: sendMessage,
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

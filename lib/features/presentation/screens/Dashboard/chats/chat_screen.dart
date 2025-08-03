import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      final decrypted = widget.rsaHelper?.decryptWithPrivateKey(msg['message'], widget.privateKeyPem.toString());
      final model = MessageModel(
        senderId: msg['from'],
        receiverId: widget.localUserId.toString(),
        content: decrypted.toString(),
        encrypted: msg['message'],
        timestamp: DateTime.now(),
      );
      await widget.db?.insertMessage(model);
      loadChat();
    };
  }

  Future<void> loadChat() async {
    final data = await widget.db?.getMessages(widget.localUserId.toString(), widget.peer!.id);
    setState(() => messages = data!);
  }

  void sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final encrypted = widget.rsaHelper?.encryptWithPublicKey(text, widget.peer!.publicKey.toString());

    final model = MessageModel(
      senderId: widget.localUserId.toString(),
      receiverId: widget.peer!.id,
      content: text,
      encrypted: encrypted.toString(),
      timestamp: DateTime.now(),
    );
    widget.socket?.sendMessage({ 'to': widget.peer?.id, 'message': encrypted });
    await widget.db?.insertMessage(model);
    _controller.clear();
    loadChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.peer!.name)),
      body: Column(
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
                    child: Text(msg.content),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: "Type message"),
                ),
              ),
              IconButton(onPressed: sendMessage, icon: Icon(Icons.send)),
            ],
          )
        ],
      ),
    );
  }
}
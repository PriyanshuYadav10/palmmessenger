import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:palmmessenger/features/provider/chatProvider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/config/theme/spaces.dart';
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/constants/images.dart';
import '../../../../data/encryption/rsa_helper.dart';
import '../../../../data/model/message_model.dart';
import '../../../../data/model/user_model.dart';
import '../../../../helper/database_service.dart';
import '../../../../helper/websocket_service.dart';
import '../../../widgets/textfeild.dart';

class ChatScreen extends StatefulWidget {
  UserModel? peer;
  String? localUserId;
  RSAHelper? rsaHelper;
  String? privateKeyPem;
  SecureStorageService? storage;
  WebSocketService? socket;

 ChatScreen({
    super.key,
    required this.peer,
    required this.localUserId,
    required this.rsaHelper,
    required this.privateKeyPem,
    required this.storage,
    required this.socket,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<MessageModel> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _controller.addListener(() {
      setState(() {}); // re-render on text change
    });
    widget.socket?.onMessageReceived = (msg) async {
      if (msg['from'] != widget.peer?.id) return;
      if (msg["message"] == "image" && msg["attachment"] != null) {

        final model = MessageModel(
          id: msg['messageId'],
          senderId: msg['from'],
          receiverId: msg['to'],
          content:   '',
          encrypted: '',
          attachment: msg['attachment'],
          timestamp: DateTime.fromMillisecondsSinceEpoch(msg['timestamp']),
        );

        await widget.storage?.saveMessage(model);
        setState(() => messages.add(model));
      }else{
      final decrypted = widget.rsaHelper?.decryptWithPrivateKey(
        msg['message'],
        widget.privateKeyPem.toString(),
      );

      final model = MessageModel(
        id: msg['messageId'],
        senderId: msg['from'],
        receiverId: msg['to'],
        content: decrypted ?? '',
        encrypted: msg['message'],
        attachment: msg['attachment'],
        timestamp: DateTime.fromMillisecondsSinceEpoch(msg['timestamp']),
      );

      await widget.storage?.saveMessage(model);
      setState(() => messages.add(model));
      }
      _scrollToBottom();
    };
  }

  Future<void> _loadMessages() async {
    messages = await widget.storage?.getMessages(widget.localUserId!, widget.peer!.id) ?? [];

    // Mark messages as read
    for (var msg in messages) {
      if (!msg.isRead && msg.receiverId == widget.localUserId) {
        await widget.storage?.markMessageAsRead(msg.id!); // Implement this
      }
    }

    setState(() {});
    _scrollToBottom();
  }
  // final _recorder = Record();
  //
  // Future<void> _handleAudioRecording() async {
  //   final status = await Permission.microphone.request();
  //   if (!status.isGranted) {
  //     Get.snackbar("Permission Denied", "Please allow microphone access");
  //     return;
  //   }
  //
  //   if (await _recorder.hasPermission()) {
  //     if (await _recorder.isRecording()) {
  //       // Stop and send audio
  //       final path = await _recorder.stop();
  //       if (path != null) {
  //         // await _sendMediaMessage(path, type: "audio");
  //       }
  //     } else {
  //       // Start recording
  //       await _recorder.start();
  //       Get.snackbar("Recording...", "Tap mic again to stop");
  //     }
  //   }
  // }
  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final encrypted = widget.rsaHelper?.encryptWithPublicKey(
      _controller.text,
      widget.peer!.publicKey,
    );

    final model = MessageModel(
      id: const Uuid().v4(),
      senderId: widget.localUserId.toString(),
      receiverId: widget.peer!.id,
      content: _controller.text,
      attachment: '',
      encrypted: encrypted!,
      timestamp: DateTime.now(),
    );

    await widget.storage?.saveMessage(model);

    widget.socket?.sendMessage(
      to: widget.peer!.id,
      message: encrypted,
    );

    setState(() {
      messages.add(model);
      _controller.clear();
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
          backgroundColor: ColorResources.appColor,
          leading: InkWell(
              onTap: (){Get.back();},
              child: Icon(Icons.arrow_back_ios_new_rounded,color: ColorResources.whiteColor,)),
          title: Row(
            children: [
              CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.peer!.avatarPath.toString())),
              wSpace(5),
              Text(widget.peer!.name),
            ],
          ),
        actions: [
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(app_bg), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isMe = msg.senderId == widget.localUserId;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF00CFFF), Color(0xFF8442D1)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: isMe ? Radius.circular(15) : Radius.circular(3),
                          bottomRight: isMe ? Radius.circular(3) : Radius.circular(15),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(1),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          gradient: isMe
                              ? LinearGradient(
                            stops: [1, 0.2],
                            colors: [Color(0xFFAE01EA), Color(0xFF2320E3)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                              : LinearGradient(
                            colors: [ColorResources.appColor, ColorResources.appColor],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: isMe ? Radius.circular(15) : Radius.circular(3),
                            bottomRight: isMe ? Radius.circular(3) : Radius.circular(15),
                          ),
                          boxShadow: [
                            if (isMe)
                              BoxShadow(
                                color: Color(0xFF8C00FF).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            /// ✅ Show Image if available
                            if (msg.attachment != null && msg.attachment!.isNotEmpty) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  msg.attachment!,
                                  fit: BoxFit.cover,
                                  width: 180,
                                  height: 200,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.broken_image,
                                    color: Colors.white70,
                                    size: 80,
                                  ),
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 180,
                                      height: 200,
                                      alignment: Alignment.center,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 6),
                            ],

                            /// ✅ Show text if available
                            if (msg.content.isNotEmpty)
                              Text(
                                msg.content,
                                style: Styles.semiBoldTextStyle(
                                    color: ColorResources.whiteColor),
                              ),

                            const SizedBox(height: 4),
                            Text(
                              DateFormat('hh:mm a').format(msg.timestamp),
                              style: Styles.semiBoldTextStyle(
                                size: 10,
                                color: ColorResources.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      Row(
        children: [
          // ➕ Add button → Gallery
          IconButton(
            icon: const Icon(Icons.add, color: ColorResources.secondaryColor),
            onPressed: () async {
              final picker = ImagePicker();
              final picked = await picker.pickImage(source: ImageSource.gallery);
              if (picked != null) {
                Provider.of<ChatProvider>(context, listen: false).loadImage(
                  File(picked.path),
                  onUploaded: (url) {
                    print('url--> $url');
                    // ✅ Send message with attachment
                    widget.socket?.sendMessage(
                      to: widget.peer!.id,
                      message: "image",
                      attachment: url,
                    );

                    final model = MessageModel(
                      id: const Uuid().v4(),
                      senderId: widget.localUserId!,
                      receiverId: widget.peer!.id,
                      content: "",
                      encrypted: "",
                      attachment: url,
                      timestamp: DateTime.now(),
                    );

                    widget.storage?.saveMessage(model);
                    setState(() => messages.add(model));
                    _scrollToBottom();
                  },
                );
              }
            },
          ),
          hSpace(5),
          Expanded(
            child: buildTextField(
              _controller,
              'Type a message..',
              MediaQuery.sizeOf(context).width,
              45,
              TextInputType.text,
              // postfixIcon: Icon(Icons.file_present_rounded, color: ColorResources.whiteColor),
              radius: 40,
              fun: (_) => setState(() {}), // realtime update
            ),
          ),
          wSpace(10),

          // 🎤 Mic or 📩 Send
          if (_controller.text.isEmpty) ...[
            InkWell(
                onTap: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    Provider.of<ChatProvider>(context, listen: false).loadImage(
                      File(picked.path),
                      onUploaded: (url) {
                        // ✅ Send message with attachment
                        widget.socket?.sendMessage(
                          to: widget.peer!.id,
                          message: "", // since it's an image
                          attachment: url, // send uploaded URL here
                        );

                        final model = MessageModel(
                          id: const Uuid().v4(),
                          senderId: widget.localUserId!,
                          receiverId: widget.peer!.id,
                          content: "[Image]", // show placeholder text
                          encrypted: "",
                          attachment: url,
                          timestamp: DateTime.now(),
                        );

                        widget.storage?.saveMessage(model);
                        setState(() => messages.add(model));
                        _scrollToBottom();
                      },
                    );
                  }
                },
                child: Image.asset(camera,height: 22,)),
            IconButton(
              icon: const Icon(Icons.mic, color: ColorResources.secondaryColor),
              onPressed: () async {
                // await _handleAudioRecording();
              },
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.send, color: ColorResources.secondaryColor),
              onPressed: _sendMessage,
            ),
          ],
        ],
      ),
          ],
        ),
      ),
    );
  }
}

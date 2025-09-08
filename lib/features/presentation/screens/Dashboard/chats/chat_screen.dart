import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:palmmessenger/features/provider/chatProvider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
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
import '../../../utility/global.dart';
import '../../../widgets/textfeild.dart';

class ChatScreen extends StatefulWidget {
  UserModel? peer;
  String? groupId;
  String? groupName;
  String? groupPublicKey;
  String? groupPrivateKey;
  String? localUserId;
  RSAHelper? rsaHelper;
  String? privateKeyPem;
  SecureStorageService? storage;
  WebSocketService? socket;

  ChatScreen({
    super.key,
    required this.peer,
    required this.groupId,
    required this.groupName,
    required this.groupPublicKey,
    required this.groupPrivateKey,
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

  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();

    _controller.addListener(() => setState(() {}));

    // ✅ FIX: Properly decrypt received messages
    widget.socket?.onMessageReceived = (msg) async {
      final bool isImage = msg["message"]?.toString().toLowerCase() == "image";
      final bool isAudio = msg["message"]?.toString().toLowerCase() == "audio";

      String decrypted = "";
      if (!isImage && !isAudio) {
        decrypted = widget.rsaHelper!.decryptWithPrivateKey(
          msg['message'],
          widget.privateKeyPem!,
        );
      } else {
        decrypted = msg["message"];
      }

      final model = MessageModel(
        id: msg['messageId'],
        senderId: msg['from'],
        receiverId: widget.groupId != null ? widget.groupId! : msg['to'],
        content: decrypted,
        groupId: widget.groupId?.toString() ?? '',
        encrypted: msg['message'] ?? '',
        attachment: msg['attachment'] ?? '',
        timestamp: DateTime.fromMillisecondsSinceEpoch(msg['timestamp']),
      );

      await widget.storage?.saveMessage(model);
      setState(() => messages.add(model));
      _scrollToBottom();
    };
  }

  Future<void> _loadMessages() async {
    if (widget.peer != null) {
      messages = await widget.storage?.getMessages(
        widget.localUserId!,
        widget.peer!.id,
      ) ??
          [];
    } else {
      messages = await widget.storage?.getMessages(
        widget.localUserId.toString(),
        '${widget.groupId}',
      ) ??
          [];
    }
    setState(() {});
    _scrollToBottom();
  }

  Future<void> _handleAudioRecording() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      Get.snackbar("Permission Denied", "Please allow microphone access");
      return;
    }

    if (_isRecording) {
      final path = await _recorder.stop();
      setState(() => _isRecording = false);

      if (path != null) {
        Provider.of<ChatProvider>(context, listen: false).loadImage(
          File(path),
          onUploaded: (url) {
            widget.socket?.sendMessage(
              to: widget.groupId != null ? widget.groupId! : widget.peer!.id,
              message: "audio",
              attachment: url,
              isGroup: widget.groupId != null,
            );

            final model = MessageModel(
              id: const Uuid().v4(),
              senderId: widget.localUserId!,
              receiverId: widget.groupId != null
                  ? widget.groupId!
                  : widget.peer!.id,
              content: "audio",
              encrypted: "",
              attachment: url,
              groupId: widget.groupId.toString(),
              timestamp: DateTime.now(),
            );

            widget.storage?.saveMessage(model);
            setState(() => messages.add(model));
            _scrollToBottom();
          },
        );
      }
    } else {
      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: filePath,
      );

      setState(() => _isRecording = true);
      Get.snackbar("Recording...", "Tap mic again to stop");
    }
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String encrypted;
    if (widget.groupId != null) {
      encrypted = widget.rsaHelper!.encryptWithPublicKey(
        _controller.text,
        widget.groupPublicKey!,
      );
    } else {
      encrypted = widget.rsaHelper!.encryptWithPublicKey(
        _controller.text,
        widget.peer!.publicKey,
      );
    }

    final model = MessageModel(
      id: const Uuid().v4(),
      senderId: widget.localUserId.toString(),
      receiverId: widget.groupId != null ? widget.groupId! : widget.peer!.id,
      content: _controller.text,
      groupId: widget.groupId.toString(),
      attachment: '',
      encrypted: encrypted,
      timestamp: DateTime.now(),
    );

    await widget.storage?.saveMessage(model);

    widget.socket?.sendMessage(
      to: widget.groupId != null ? widget.groupId! : widget.peer!.id,
      message: encrypted,
      isGroup: widget.groupId != null,
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

  // ---------------- UI ------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorResources.appColor,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.peer?.avatarPath != null &&
                  widget.peer!.avatarPath!.isNotEmpty
                  ? NetworkImage(widget.peer!.avatarPath.toString())
                  : null,
              child: (widget.peer?.avatarPath == null ||
                  widget.peer!.avatarPath!.isEmpty)
                  ? Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            wSpace(8),
            Text(
              widget.peer == null
                  ? widget.groupName ?? ''
                  : widget.peer?.name ?? '',
            ),
          ],
        ),
      ),
      body: Container(
        decoration:appTheme.toString().toLowerCase()=='dark'? BoxDecoration(
            image: DecorationImage(image: AssetImage(app_bg),fit: BoxFit.cover)
        ):BoxDecoration(
            color: ColorResources.whiteColor
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(messages[index]);
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel msg) {
    final isMe = msg.senderId == widget.localUserId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          gradient: isMe
              ? LinearGradient(
            colors: [Color(0xFFAE01EA), Color(0xFF2320E3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
              : LinearGradient(
            colors: [ColorResources.appColor, ColorResources.appColor],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: isMe ? Radius.circular(15) : Radius.circular(3),
            bottomRight: isMe ? Radius.circular(3) : Radius.circular(15),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (msg.content == "image" && msg.attachment.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    msg.attachment,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 220,
                  ),
                ),
              if (msg.content == "audio") _buildAudioMessage(msg),
              if (msg.content.isNotEmpty &&
                  msg.content != "image" &&
                  msg.content != "audio")
                Text(
                  msg.content,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormat('hh:mm a').format(msg.timestamp),
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAudioMessage(MessageModel msg) {
    final isMe = msg.senderId == widget.localUserId;
    return AudioMessageBubble(url: msg.attachment, isMe: isMe);
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.add, color: ColorResources.secondaryColor),
          onPressed: () async {
            final picker = ImagePicker();
            final picked = await picker.pickImage(source: ImageSource.gallery);
            if (picked != null) {
              Provider.of<ChatProvider>(context, listen: false).loadImage(
                File(picked.path),
                onUploaded: (url) {
                  widget.socket?.sendMessage(
                    to: widget.groupId != null ? widget.groupId! : widget.peer!.id,
                    message: "image",
                    attachment: url,
                    isGroup: widget.groupId != null,
                  );

                  final model = MessageModel(
                    id: const Uuid().v4(),
                    senderId: widget.localUserId!,
                    receiverId: widget.groupId != null
                        ? widget.groupId!
                        : widget.peer!.id,
                    content: "image",
                    encrypted: "",
                    attachment: url,
                    groupId: widget.groupId.toString(),
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
        Expanded(
          child: buildTextField(
            _controller,
            'Type a message..',
            MediaQuery.sizeOf(context).width,
            45,
            TextInputType.text,
            radius: 40,
            fun: (_) => setState(() {}),
          ),
        ),
        if (_controller.text.isEmpty)
          IconButton(
            icon: Icon(
              _isRecording ? Icons.stop_circle : Icons.mic,
              color: _isRecording ? Colors.red : ColorResources.secondaryColor,
            ),
            onPressed: _handleAudioRecording,
          )
        else
          IconButton(
            icon: const Icon(Icons.send, color: ColorResources.secondaryColor),
            onPressed: _sendMessage,
          ),
      ],
    );
  }
}

// ---------------- AUDIO BUBBLE ----------------
class AudioMessageBubble extends StatefulWidget {
  final String url;
  final bool isMe;

  const AudioMessageBubble({Key? key, required this.url, required this.isMe})
      : super(key: key);

  @override
  State<AudioMessageBubble> createState() => _AudioMessageBubbleState();
}

class _AudioMessageBubbleState extends State<AudioMessageBubble> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });

    // ✅ Preload audio to fetch duration
    _loadAudioDuration();
  }

  Future<void> _loadAudioDuration() async {
    try {
      await _audioPlayer.setSourceUrl(widget.url);
      final d = await _audioPlayer.getDuration();
      if (d != null) {
        setState(() => _duration = d);
      }
    } catch (e) {
      print("Error loading audio: $e");
    }
  }


  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.play(UrlSource(widget.url)); // ✅ FIX: load & play
      setState(() => _isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: Colors.white,
              size: 34,
            ),
            onPressed: _togglePlay,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slider(
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble() > 0
                      ? _duration.inSeconds.toDouble()
                      : 1,
                  onChanged: (val) async {
                    final newPos = Duration(seconds: val.toInt());
                    await _audioPlayer.seek(newPos);
                  },
                  activeColor: Colors.white,
                  inactiveColor: Colors.white38,
                ),
                Text(
                  "${_formatTime(_position)} / ${_formatTime(_duration)}",
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

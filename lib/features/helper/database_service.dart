import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/model/user_model.dart';
import '../data/model/message_model.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  // Save user
  Future<void> saveUser(UserModel user) async {
    await _storage.write(key: 'user_${user.id}', value: jsonEncode(user.toJson()));
  }

  // Get user
  Future<UserModel?> getUser(String id) async {
    final data = await _storage.read(key: 'user_$id');
    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  // Save message
  Future<void> saveMessage(MessageModel msg) async {
    final chatKey = 'chat_${_chatId(msg.senderId, msg.receiverId)}';
    final existing = await _storage.read(key: chatKey);
    List messages = existing != null ? jsonDecode(existing) : [];
    messages.add(msg.toJson());
    await _storage.write(key: chatKey, value: jsonEncode(messages));
  }

  // Get messages for a chat
  Future<List<MessageModel>> getMessages(String user1, String user2) async {
    final chatKey = 'chat_${_chatId(user1, user2)}';
    final data = await _storage.read(key: chatKey);
    if (data == null) return [];
    final List decoded = jsonDecode(data);
    return decoded.map((e) => MessageModel.fromJson(e)).toList();
  }

  // Get latest messages for chat list
  Future<List<MessageModel>> getLatestMessages(String myId) async {
    final allKeys = await _storage.readAll();
    final chats = allKeys.keys.where((k) => k.startsWith('chat_'));
    List<MessageModel> latest = [];

    for (var chatKey in chats) {
      final data = allKeys[chatKey];
      if (data != null) {
        final List decoded = jsonDecode(data);
        if (decoded.isNotEmpty) {
          final last = MessageModel.fromJson(decoded.last);
          if (last.senderId == myId || last.receiverId == myId) {
            latest.add(last);
          }
        }
      }
    }
    return latest;
  }
  Future<int> getUnreadMessageCount(String localUserId, String peerId) async {
    final messages = await getMessages(peerId, localUserId);
    return messages.where((msg) => msg.receiverId == localUserId && !msg.isRead).length;
  }

  Future<void> markMessageAsRead(String messageId) async {
    final allKeys = await _storage.readAll();
    final chatKeys = allKeys.keys.where((k) => k.startsWith('chat_'));

    for (final key in chatKeys) {
      final data = await _storage.read(key: key);
      if (data != null) {
        final List decoded = jsonDecode(data);
        bool updated = false;

        final updatedMessages = decoded.map((e) {
          final msg = MessageModel.fromJson(e);
          if (msg.id == messageId && !msg.isRead) {
            updated = true;
            return msg.copyWith(isRead: true);
          }
          return msg;
        }).toList();

        if (updated) {
          await _storage.write(key: key, value: jsonEncode(updatedMessages));
          break; // message ID is unique, no need to check other chats
        }
      }
    }
  }

  List<String> _chatId(String a, String b) {
    return [a, b]..sort();
    // joining sorted IDs ensures same key for both directions
  }
}

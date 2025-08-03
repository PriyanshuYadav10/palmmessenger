// import 'dart:convert';
//
// import 'package:uuid/uuid.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// import '../presentation/utility/global.dart';
//
// class WebSocketService {
//   late WebSocketChannel _channel;
//   Function(Map<String, dynamic>)? onMessageReceived;
//
//   void connect(String userId) {
//     _channel = WebSocketChannel.connect(
//       Uri.parse('wss://palm-messenger.onrender.com?token=$accessToken'),
//     );
//     _channel.stream.listen((raw) {
//       try {
//         final Map<String, dynamic> message = jsonDecode(raw);
//         onMessageReceived?.call(message);
//       } catch (e) {
//         print("WebSocket error: $e");
//       }
//     });
//   }
//
//   void sendMessage({required String to, required String message}) {
//     final msg = {
//       'messageId': const Uuid().v4(),
//       'to': to,
//       'message': message,
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//     };
//     _channel.sink.add(jsonEncode(msg));
//   }
//
//   void disconnect() {
//     _channel.sink.close();
//   }
// }
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../presentation/utility/global.dart';

class WebSocketService {
  late WebSocketChannel _channel;
  Function(Map<String, dynamic>)? onMessageReceived;

  void connect() {
    _channel = WebSocketChannel.connect( Uri.parse('wss://palm-messenger.onrender.com/ws?token=$accessToken'));
    _channel.stream.listen((event) {
      final data = jsonDecode(event);
      onMessageReceived?.call(data);
    });
  }

  void sendMessage(Map<String, dynamic> msg) {
    _channel.sink.add(jsonEncode(msg));
  }

  void disconnect() => _channel.sink.close();
}
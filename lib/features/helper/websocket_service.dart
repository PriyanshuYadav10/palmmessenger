import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';
import '../presentation/utility/global.dart';

class WebSocketService {
  late IO.Socket _socket;
  Function(Map<String, dynamic>)? onMessageReceived;
  Function(Map<String, dynamic>)? onMessageUpdate;
  bool _isConnected = false;

  void connect() {
    if (_isConnected) return; // prevent multiple connects

    _socket = IO.io(
      'https://palm-messenger.onrender.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setQuery({'token': accessToken})
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      print('✅ Connected to socket server');
      _isConnected = true;
    });

    _socket.onConnectError((err) {
      print('❌ Connection error: $err');
    });

    _socket.onDisconnect((_) {
      print('🔌 Disconnected from socket server');
      _isConnected = false;
    });

    // Prevent duplicate event listeners
    _socket.off('receive-message');
    _socket.on('receive-message', (data) {
      print('📩 Received message: $data');
      if (data is Map) {
        onMessageReceived?.call(Map<String, dynamic>.from(data));
      }
    });

    _socket.off('receive-message-update');
    _socket.on('receive-message-update', (data) {
      print('📬 Received message update: $data');
      if (data is Map) {
        onMessageUpdate?.call(Map<String, dynamic>.from(data));
      }
    });
  }

  void sendMessage({
    required String to,
    required String message,
    bool? isGroup,
    String? attachment,
  }) {
    final payload = {
      'messageId': const Uuid().v4(),
      'to': to,
      'message': message,
      if (isGroup != null||isGroup!='')  'isGroup': isGroup,
      if (attachment != null) 'attachment': attachment,
    };

    print('📤 Sending message: $payload');
    _socket.emitWithAck('send-message', payload, ack: (response) {
      print('✅ Ack from server: $response');
    });
  }

  void sendMessageUpdate({
    required String messageId,
    required String to,
    required String status,
  }) {
    _socket.emit('send-message-update', {
      'messageId': messageId,
      'to': to,
      'status': status,
    });
  }

  void disconnect() {
    _socket.disconnect();
    _isConnected = false;
  }
}

  import 'package:socket_io_client/socket_io_client.dart' as IO;
  import 'package:uuid/uuid.dart';

  import '../presentation/utility/global.dart';

  class WebSocketService {
    late IO.Socket _socket;

    /// Callbacks for incoming events
    Function(Map<String, dynamic>)? onMessageReceived;
    Function(Map<String, dynamic>)? onMessageUpdate;

    /// Connect to the Socket.IO server
    void connect() {
      _socket = IO.io(
        'https://palm-messenger.onrender.com',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setQuery({'token': accessToken}) // send token as query param
            .build(),
      );

      _socket.connect();

      _socket.onConnect((_) {
        print('✅ Connected to socket server');
      });

      _socket.onConnectError((err) {
        print('❌ Connection error: $err');
      });

      _socket.onDisconnect((_) {
        print('🔌 Disconnected from socket server');
      });

      // 📥 Receive new message
      _socket.on('receive-message', (data) {
        print('📩 Received message: $data');
        if (data is Map) {
          onMessageReceived?.call(Map<String, dynamic>.from(data));
        }
      });

      // 📥 Receive message status update
      _socket.on('receive-message-update', (data) {
        print('📬 Received mes sage update: $data');
        if (data is Map) {
          onMessageUpdate?.call(Map<String, dynamic>.from(data));
        }
      });
    }

    /// 📤 Send a new message
    void sendMessage({
      required String to,
      required String message,
      String? attachment,
    }) {
      final payload = {
        'messageId': const Uuid().v4(),
        'to': to,
        'message': message,
        if (attachment != null) 'attachment': attachment,
      };

      print('📤 Sending message: $payload');
      _socket.emitWithAck('send-message', payload,ack:  (response) {
        print('✅ Ack received from server: $response');
      });
    }

    /// 📤 Send a message update (delivered/seen/deleted)
    void sendMessageUpdate({
      required String messageId,
      required String to,
      required String status,
    }) {
      final payload = {
        'messageId': messageId,
        'to': to,
        'status': status,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      print('📤 Sending message update: $payload');
      _socket.emit('send-message-update', payload);
    }

    /// Disconnect from socket
    void disconnect() {
      _socket.disconnect();
    }
  }

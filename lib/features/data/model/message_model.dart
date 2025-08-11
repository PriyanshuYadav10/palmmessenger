class MessageModel {
  final String? id;
  final String senderId;
  final String receiverId;
  final String content; // decrypted content
  final String encrypted; // encrypted string
  // final DateTime timestamp;

  MessageModel({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.encrypted,
    // required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'senderId': senderId,
    'receiverId': receiverId,
    'content': content,
    'encrypted': encrypted,
    // 'timestamp': timestamp.toIso8601String(),
  };

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
    id: map['id'],
    senderId: map['senderId'],
    receiverId: map['receiverId'],
    content: map['content'],
    encrypted: map['encrypted'],
    // timestamp: DateTime.parse(map['timestamp']),
  );
}
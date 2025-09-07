class MessageModel {
  final String? id;
  final String senderId;
  final String receiverId;
  final String groupId;
  final String content;
  final String encrypted;
  final String attachment;
  final DateTime timestamp;
  final bool isRead;
  final bool isGroup;

  MessageModel({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.groupId,
    required this.content,
    required this.encrypted,
    required this.timestamp,
    required this.attachment,
    this.isRead = false,
    this.isGroup = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'receiverId': receiverId,
    'content': content,
    'isGroup': isGroup,
    'encrypted': encrypted,
    'attachment': attachment,
    'timestamp': timestamp.toIso8601String(),
    'isRead': isRead,
  };
  factory MessageModel.fromJson(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id']?.toString(),
      senderId: map['senderId']?.toString() ?? '',
      receiverId: map['receiverId']?.toString() ?? '',
      groupId: map['groupId']?.toString() ?? '',
      content: map['content']?.toString() ?? '',
      encrypted: map['encrypted']?.toString() ?? '',
      attachment: map['attachment']?.toString() ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isRead: map['isRead'] ?? false,
      isGroup: map['isGroup'] ?? false,
    );
  }

  // 👇 New method
  MessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    String? groupId,
    String? encrypted,
    String? attachment,
    DateTime? timestamp,
    bool? isRead,
    bool? isGroup,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      groupId: groupId ?? this.groupId,
      content: content ?? this.content,
      encrypted: encrypted ?? this.encrypted,
      attachment: attachment ?? this.attachment,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isGroup: isGroup ?? this.isGroup,
    );
  }
}

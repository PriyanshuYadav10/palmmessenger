class UserSettingsModel {
  UserSettingsModel({
    required this.privacy,
    required this.chat,
    required this.notifications,
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final Privacy? privacy;
  final Chat? chat;
  final Notifications? notifications;
  final String? id;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory UserSettingsModel.fromJson(Map<String, dynamic> json){
    return UserSettingsModel(
      privacy: json["privacy"] == null ? null : Privacy.fromJson(json["privacy"]),
      chat: json["chat"] == null ? null : Chat.fromJson(json["chat"]),
      notifications: json["notifications"] == null ? null : Notifications.fromJson(json["notifications"]),
      id: json["_id"],
      userId: json["userId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

}

class Chat {
  Chat({
    required this.theme,
    required this.enterIsSend,
    required this.autoPlayAnimatedImages,
    required this.mediaVisibility,
    required this.fontSize,
    required this.voiceMessagesTranscript,
    required this.archiveChats,
    required this.backupVideos,
    required this.backupImages,
  });

  final String? theme;
  final bool? enterIsSend;
  final bool? autoPlayAnimatedImages;
  final bool? mediaVisibility;
  final String? fontSize;
  final bool? voiceMessagesTranscript;
  final bool? archiveChats;
  final bool? backupVideos;
  final bool? backupImages;

  factory Chat.fromJson(Map<String, dynamic> json){
    return Chat(
      theme: json["theme"],
      enterIsSend: json["enterIsSend"],
      autoPlayAnimatedImages: json["autoPlayAnimatedImages"],
      mediaVisibility: json["mediaVisibility"],
      fontSize: json["fontSize"],
      voiceMessagesTranscript: json["voiceMessagesTranscript"],
      archiveChats: json["archiveChats"],
      backupVideos: json["backupVideos"],
      backupImages: json["backupImages"],
    );
  }

}

class Notifications {
  Notifications({
    required this.messages,
    required this.groups,
    required this.conversationTone,
    required this.reminder,
    required this.clearCount,
  });

  final Groups? messages;
  final Groups? groups;
  final bool? conversationTone;
  final bool? reminder;
  final bool? clearCount;

  factory Notifications.fromJson(Map<String, dynamic> json){
    return Notifications(
      messages: json["messages"] == null ? null : Groups.fromJson(json["messages"]),
      groups: json["groups"] == null ? null : Groups.fromJson(json["groups"]),
      conversationTone: json["conversationTone"],
      reminder: json["reminder"],
      clearCount: json["clearCount"],
    );
  }

}

class Groups {
  Groups({
    required this.vibrate,
    required this.highPriorityNotification,
    required this.reactionNotification,
  });

  final bool? vibrate;
  final bool? highPriorityNotification;
  final bool? reactionNotification;

  factory Groups.fromJson(Map<String, dynamic> json){
    return Groups(
      vibrate: json["vibrate"],
      highPriorityNotification: json["highPriorityNotification"],
      reactionNotification: json["reactionNotification"],
    );
  }

}

class Privacy {
  Privacy({
    required this.lastSeen,
    required this.online,
    required this.profilePhoto,
    required this.readReceipts,
    required this.blockedUsers,
    required this.appLock,
    required this.cameraEffects,
  });

  final String? lastSeen;
  final String? online;
  final String? profilePhoto;
  final bool? readReceipts;
  final List<dynamic> blockedUsers;
  final bool? appLock;
  final bool? cameraEffects;

  factory Privacy.fromJson(Map<String, dynamic> json){
    return Privacy(
      lastSeen: json["lastSeen"],
      online: json["online"],
      profilePhoto: json["profilePhoto"],
      readReceipts: json["readReceipts"],
      blockedUsers: json["blockedUsers"] == null ? [] : List<dynamic>.from(json["blockedUsers"]!.map((x) => x)),
      appLock: json["appLock"],
      cameraEffects: json["cameraEffects"],
    );
  }

}
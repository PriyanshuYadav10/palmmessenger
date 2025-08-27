class PrivacyAndSecurityModel {
  final String? message;
  final bool? cameraEffects;
  final String? lastSeen;
  final String? online;
  final String? profilePhoto;
  final bool? readReceipts;
  final List<dynamic>? blockedUsers;
  final bool? appLock;

  PrivacyAndSecurityModel({
    this.message,
    this.cameraEffects,
    this.lastSeen,
    this.online,
    this.profilePhoto,
    this.readReceipts,
    this.blockedUsers,
    this.appLock,
  });

  factory PrivacyAndSecurityModel.fromJson(Map<String, dynamic> json) {
    return PrivacyAndSecurityModel(
      message: json['message'],
      cameraEffects: json['data']?['cameraEffects'],
      lastSeen: json['data']?['lastSeen'],
      online: json['data']?['online'],
      profilePhoto: json['data']?['profilePhoto'],
      readReceipts: json['data']?['readReceipts'],
      blockedUsers: json['data']?['blockedUsers'] ?? [],
      appLock: json['data']?['appLock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': {
        'cameraEffects': cameraEffects,
        'lastSeen': lastSeen,
        'online': online,
        'profilePhoto': profilePhoto,
        'readReceipts': readReceipts,
        'blockedUsers': blockedUsers,
        'appLock': appLock,
      }
    };
  }
}
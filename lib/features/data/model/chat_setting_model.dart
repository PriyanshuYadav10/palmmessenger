class ChatSettingsModel {
  String? message;
  ChatSettingsData? data;

  ChatSettingsModel({this.message, this.data});

  ChatSettingsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? ChatSettingsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class ChatSettingsData {
  String? theme;
  bool? enterIsSend;
  bool? autoPlayAnimatedImages;
  bool? mediaVisibility;
  String? fontSize;
  bool? voiceMessagesTranscript;
  bool? archiveChats;
  bool? backupVideos;
  bool? backupImages;

  ChatSettingsData({
    this.theme,
    this.enterIsSend,
    this.autoPlayAnimatedImages,
    this.mediaVisibility,
    this.fontSize,
    this.voiceMessagesTranscript,
    this.archiveChats,
    this.backupVideos,
    this.backupImages,
  });

  ChatSettingsData.fromJson(Map<String, dynamic> json) {
    theme = json['theme'];
    enterIsSend = json['enterIsSend'];
    autoPlayAnimatedImages = json['autoPlayAnimatedImages'];
    mediaVisibility = json['mediaVisibility'];
    fontSize = json['fontSize'];
    voiceMessagesTranscript = json['voiceMessagesTranscript'];
    archiveChats = json['archiveChats'];
    backupVideos = json['backupVideos'];
    backupImages = json['backupImages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['theme'] = theme;
    map['enterIsSend'] = enterIsSend;
    map['autoPlayAnimatedImages'] = autoPlayAnimatedImages;
    map['mediaVisibility'] = mediaVisibility;
    map['fontSize'] = fontSize;
    map['voiceMessagesTranscript'] = voiceMessagesTranscript;
    map['archiveChats'] = archiveChats;
    map['backupVideos'] = backupVideos;
    map['backupImages'] = backupImages;
    return map;
  }
}
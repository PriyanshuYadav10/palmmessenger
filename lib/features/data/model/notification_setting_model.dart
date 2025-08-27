class NotificationSettingsModel {
  String? message;
  NotificationSettingsData? data;

  NotificationSettingsModel({this.message, this.data});

  NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null
        ? NotificationSettingsData.fromJson(json['data'])
        : null;
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

class NotificationSettingsData {
  NotificationType? messages;
  NotificationType? groups;
  bool? conversationTone;
  bool? reminder;
  bool? clearCount;

  NotificationSettingsData({
    this.messages,
    this.groups,
    this.conversationTone,
    this.reminder,
    this.clearCount,
  });

  NotificationSettingsData.fromJson(Map<String, dynamic> json) {
    messages = json['messages'] != null
        ? NotificationType.fromJson(json['messages'])
        : null;
    groups = json['groups'] != null
        ? NotificationType.fromJson(json['groups'])
        : null;
    conversationTone = json['conversationTone'];
    reminder = json['reminder'];
    clearCount = json['clearCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (messages != null) {
      map['messages'] = messages!.toJson();
    }
    if (groups != null) {
      map['groups'] = groups!.toJson();
    }
    map['conversationTone'] = conversationTone;
    map['reminder'] = reminder;
    map['clearCount'] = clearCount;
    return map;
  }
}

class NotificationType {
  bool? vibrate;
  bool? highPriorityNotification;
  bool? reactionNotification;

  NotificationType({
    this.vibrate,
    this.highPriorityNotification,
    this.reactionNotification,
  });

  NotificationType.fromJson(Map<String, dynamic> json) {
    vibrate = json['vibrate'];
    highPriorityNotification = json['highPriorityNotification'];
    reactionNotification = json['reactionNotification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['vibrate'] = vibrate;
    map['highPriorityNotification'] = highPriorityNotification;
    map['reactionNotification'] = reactionNotification;
    return map;
  }
}
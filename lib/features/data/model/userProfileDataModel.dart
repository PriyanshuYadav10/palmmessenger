class UserProfileDataModel {
  bool? success;
  Profile? profile;

  UserProfileDataModel({this.success, this.profile});

  UserProfileDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? sId;
  String? phoneNo;
  bool? isVerified;
  bool? isBlocked;
  bool? lastSeen;
  bool? readReceipts;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? bio;
  String? name;
  String? profilePicture;

  Profile(
      {this.sId,
        this.phoneNo,
        this.isVerified,
        this.isBlocked,
        this.lastSeen,
        this.readReceipts,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.bio,
        this.name,
        this.profilePicture});

  Profile.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phoneNo = json['phoneNo'];
    isVerified = json['isVerified'];
    isBlocked = json['isBlocked'];
    lastSeen = json['lastSeen'];
    readReceipts = json['readReceipts'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    bio = json['bio'];
    name = json['name'];
    profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['phoneNo'] = this.phoneNo;
    data['isVerified'] = this.isVerified;
    data['isBlocked'] = this.isBlocked;
    data['lastSeen'] = this.lastSeen;
    data['readReceipts'] = this.readReceipts;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['bio'] = this.bio;
    data['name'] = this.name;
    data['profilePicture'] = this.profilePicture;
    return data;
  }
}

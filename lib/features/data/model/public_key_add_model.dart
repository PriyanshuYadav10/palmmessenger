class publicKeyAddModel {
  String? message;
  User? user;

  publicKeyAddModel({this.message, this.user});

  publicKeyAddModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
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
  String? publicKey;

  User(
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
        this.profilePicture,
        this.publicKey});

  User.fromJson(Map<String, dynamic> json) {
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
    publicKey = json['publicKey'];
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
    data['publicKey'] = this.publicKey;
    return data;
  }
}

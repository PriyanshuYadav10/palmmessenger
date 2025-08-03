class ContactsUserModel {
  List<Users>? users;

  ContactsUserModel({this.users});

  ContactsUserModel.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String? sId;
  String? phoneNo;
  bool? lastSeen;
  String? bio;
  String? name;
  String? profilePicture;
  String? publicKey;

  Users(
      {this.sId,
        this.phoneNo,
        this.lastSeen,
        this.bio,
        this.name,
        this.profilePicture,
        this.publicKey});

  Users.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phoneNo = json['phoneNo'];
    lastSeen = json['lastSeen'];
    bio = json['bio'];
    name = json['name'];
    profilePicture = json['profilePicture'];
    publicKey = json['publicKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['phoneNo'] = this.phoneNo;
    data['lastSeen'] = this.lastSeen;
    data['bio'] = this.bio;
    data['name'] = this.name;
    data['profilePicture'] = this.profilePicture;
    data['publicKey'] = this.publicKey;
    return data;
  }
}

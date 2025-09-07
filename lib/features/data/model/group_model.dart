class GroupModel {
  String? sId;
  String? name;
  CreatedBy? createdBy;
  String? publicKey;
  String? privateKey;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isAdmin;

  GroupModel(
      {this.sId,
        this.name,
        this.createdBy,
        this.publicKey,
        this.privateKey,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.isAdmin});

  GroupModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
        : null;
    publicKey = json['publicKey'];
    privateKey = json['privateKey'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy!.toJson();
    }
    data['publicKey'] = this.publicKey;
    data['privateKey'] = this.privateKey;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['isAdmin'] = this.isAdmin;
    return data;
  }
}

class CreatedBy {
  String? sId;
  String? name;
  String? publicKey;

  CreatedBy({this.sId, this.name, this.publicKey});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    publicKey = json['publicKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['publicKey'] = this.publicKey;
    return data;
  }
}

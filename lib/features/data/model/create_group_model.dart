class CreateGroupModel {
  String? name;
  String? createdBy;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? sV;

  CreateGroupModel(
      {this.name,
        this.createdBy,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.sV});

  CreateGroupModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    createdBy = json['createdBy'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['createdBy'] = this.createdBy;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.sV;
    return data;
  }
}

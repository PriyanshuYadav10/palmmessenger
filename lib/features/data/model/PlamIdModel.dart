class PalmIdModel {
  String? message;
  String? palmId;
  String? accessToken;

  PalmIdModel({this.message, this.palmId, this.accessToken});

  PalmIdModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    palmId = json['palmId'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['palmId'] = this.palmId;
    data['accessToken'] = this.accessToken;
    return data;
  }
}

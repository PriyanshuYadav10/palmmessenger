class verifyOtpModel {
  String? accessToken;
  bool? isVerified;
  String? status;
  String? message;

  verifyOtpModel({this.accessToken, this.isVerified,this.status,this.message});

  verifyOtpModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    isVerified = json['isVerified'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['isVerified'] = this.isVerified;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }

  fromJson(data) {}
}

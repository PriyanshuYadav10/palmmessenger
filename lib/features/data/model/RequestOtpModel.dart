class RequestOtpModel {
  String? otp;
  String? otpExpiry;
  String? status;
  String? message;
  bool? isRegistered;

  RequestOtpModel({this.otp, this.otpExpiry,this.status,this.message,this.isRegistered});

  RequestOtpModel.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    otpExpiry = json['otpExpiry'];
    status = json['status'];
    message = json['message'];
    isRegistered = json['isRegistered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['otpExpiry'] = this.otpExpiry;
    data['message'] = this.message;
    data['status'] = this.status;
    data['isRegistered'] = this.isRegistered;
    return data;
  }
}
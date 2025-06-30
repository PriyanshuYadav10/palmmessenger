class CreateOrderModel {
  String? orderId;
  var amount;
  var status;
  var sId;
  var createdAt;
  var updatedAt;
  var sV;
  var message;

  CreateOrderModel({this.orderId, this.amount,
    this.status,
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.sV,this.message});

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['razorpayOrderId'];
    amount = json['amount'];
    status = json['status'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sV = json['__v'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['razorpayOrderId'] = this.orderId;
    data['message'] = this.message;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.sV;
    return data;
  }
}
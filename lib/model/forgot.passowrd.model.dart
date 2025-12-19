class ForgotpasswordModel {
  int? statusCode;
  List<String>? data;
  String? message;
  bool? success;

  ForgotpasswordModel({this.statusCode, this.data, this.message, this.success});

  ForgotpasswordModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'].cast<String>();
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['data'] = this.data;
    data['message'] = this.message;
    data['success'] = this.success;
    return data;
  }
}

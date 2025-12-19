class CheckInModel {
  int? statusCode;
  String? message;
  Attendance? attendance;

  CheckInModel({this.statusCode, this.message, this.attendance});

  CheckInModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    attendance = json['attendance'] != null
        ? new Attendance.fromJson(json['attendance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.toJson();
    }
    return data;
  }
}

class Attendance {
  String? user;
  String? status;
  String? note;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? ruleType;

  Attendance(
      {this.user,
      this.status,
      this.note,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.ruleType});

  Attendance.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    status = json['status'];
    note = json['note'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    ruleType = json['ruleType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['status'] = this.status;
    data['note'] = this.note;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['ruleType'] = this.ruleType;
    return data;
  }
}

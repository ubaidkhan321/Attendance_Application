class GetAttendance {
  int? statusCode;
  String? message;
  List<Attendance>? attendance;

  GetAttendance({this.statusCode, this.message, this.attendance});

  GetAttendance.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['attendance'] != null) {
      attendance = <Attendance>[];
      json['attendance'].forEach((v) {
        attendance!.add(new Attendance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attendance {
  String? sId;
  String? user;
  String? status;
  String? note;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Attendance(
      {this.sId,
      this.user,
      this.status,
      this.note,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Attendance.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    status = json['status'];
    note = json['note'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['status'] = this.status;
    data['note'] = this.note;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

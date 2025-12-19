class DeleteOldAttendance {
  int? statusCode;
  String? message;
  PreviousMonthKept? previousMonthKept;
  String? currentMonthStart;
  int? deletedCount;

  DeleteOldAttendance(
      {this.statusCode,
      this.message,
      this.previousMonthKept,
      this.currentMonthStart,
      this.deletedCount});

  DeleteOldAttendance.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    previousMonthKept = json['previousMonthKept'] != null
        ? new PreviousMonthKept.fromJson(json['previousMonthKept'])
        : null;
    currentMonthStart = json['currentMonthStart'];
    deletedCount = json['deletedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.previousMonthKept != null) {
      data['previousMonthKept'] = this.previousMonthKept!.toJson();
    }
    data['currentMonthStart'] = this.currentMonthStart;
    data['deletedCount'] = this.deletedCount;
    return data;
  }
}

class PreviousMonthKept {
  String? from;
  String? to;

  PreviousMonthKept({this.from, this.to});

  PreviousMonthKept.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}

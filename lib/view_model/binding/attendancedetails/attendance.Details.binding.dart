import 'package:attendance_system_app/view_model/controller/attendancedetails/attendance.details.controller.dart';
import 'package:get/get.dart';

class AttendanceDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AttendanceDetailsController());
  }
}

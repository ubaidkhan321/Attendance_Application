import 'package:attendance_system_app/view_model/controller/deleteattendance/delete.old.attendance.controller.dart';
import 'package:get/get.dart';

class DeleteAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DeleteAttendanceController());
  }
}

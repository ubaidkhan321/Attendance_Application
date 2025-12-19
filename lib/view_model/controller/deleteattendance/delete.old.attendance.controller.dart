import 'package:attendance_system_app/repository/deleteattendance/detete.old.attendance.repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteAttendanceController extends GetxController {
  DeleteAttendanceController();
  Future oldAttendanceDelete() async {
    try {
      final result = await DeleteOldAttendaceRepository.deletedAttendanceRepo();
      if (result.statusCode == 200) {
        Get.snackbar("Message", result.message.toString(),
            backgroundColor: Colors.orange);
      }
    } catch (e) {
      print(e.toString());
      String jsonPart = e
          .toString()
          .replaceAll(RegExp(r'Message: |Prefix: Parse Error: |\{|\}|"'), '')
          .trim();
      Get.snackbar("message", jsonPart, backgroundColor: Colors.orange);
    }
  }
}

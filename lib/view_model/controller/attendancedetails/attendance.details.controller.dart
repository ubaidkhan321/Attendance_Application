// import 'package:attendance_system_app/model/get.attendance.model.dart';
// import 'package:attendance_system_app/repository/getattendance/get.attendance.repo.dart';
// import 'package:attendance_system_app/view_model/controller/session/session.controller.dart';
// import 'package:get/get.dart';

// class AttendanceDetailsController extends GetxController {
//   Rx<String> userId = "".obs;

//   RxList<Attendance> allAttendance = <Attendance>[].obs;

//   RxList<Attendance> filteredAttendance = <Attendance>[].obs;

//   RxString selectedNote = "all".obs;

//   @override
//   void onInit() async {
//     super.onInit();
//     userId.value = SessionController.instance.userSession.data?.sId ?? "";
//     //await getAttendance();
//   }

//   Future<void> getAttendance({
//     required String? start,
//     required String? end,
//   }) async {
//     final result = await GetAttendanceRepository.getAttendanceRepo(
//         userId: userId.value, startDate: start, endDate: end);

//     if (result.statusCode == 200) {
//       allAttendance.value = result.attendance ?? [];

//       filteredAttendance.value = allAttendance;
//     }
//   }

//   void filterByNote(String note) {
//     selectedNote.value = note;

//     filteredAttendance.value = allAttendance.where((e) {
//       return (e.note ?? "").trim().toLowerCase() == note.trim().toLowerCase();
//     }).toList();
//   }

//   String countByNote(String note) {
//     return allAttendance
//         .where((e) {
//           final serverNote = (e.note ?? "").trim().toLowerCase();
//           final buttonNote = note.trim().toLowerCase();
//           return serverNote == buttonNote;
//         })
//         .length
//         .toString();
//   }
// }

import 'package:attendance_system_app/model/get.attendance.model.dart';
import 'package:attendance_system_app/repository/getattendance/get.attendance.repo.dart';
import 'package:attendance_system_app/view_model/controller/session/session.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceDetailsController extends GetxController {
  Rx<String> userId = "".obs;

  RxList<Attendance> allAttendance = <Attendance>[].obs;
  RxList<Attendance> filteredAttendance = <Attendance>[].obs;

  RxString selectedNote = "all".obs;

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    userId.value = SessionController.instance.userSession.data?.sId ?? "";
  }

  Future<void> pickDate(
    BuildContext context,
    Rx<DateTime?> targetDate,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: targetDate.value ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      targetDate.value = picked;

      if (startDate.value != null && endDate.value != null) {
        if (startDate.value!.isAfter(endDate.value!)) {
          Get.snackbar(
            "Invalid Date",
            "startDate cannot be greater than endDate",
          );
          return;
        }
        getAttendance();
      }
    }
  }

  Future<void> getAttendance() async {
    isLoading.value = true;

    try {
      final result = await GetAttendanceRepository.getAttendanceRepo(
        userId: userId.value,
        startDate: DateFormat('yyyy-MM-dd').format(startDate.value!),
        endDate: DateFormat('yyyy-MM-dd').format(endDate.value!),
      );

      if (result.statusCode == 200) {
        allAttendance.value = result.attendance ?? [];
        filteredAttendance.value = allAttendance;
      }
    } finally {
      isLoading.value = false;
    }
  }

  DateTime parseAttendanceDate(String date) {
    try {
      return DateTime.parse(date).toLocal();
    } catch (_) {
      return DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true).toLocal();
    }
  }

  void filterByNote(String note) {
    selectedNote.value = note;

    if (note == "all") {
      filteredAttendance.value = allAttendance;
      return;
    }

    filteredAttendance.value = allAttendance.where((e) {
      return (e.note ?? "").trim().toLowerCase() == note.trim().toLowerCase();
    }).toList();
  }

  String countByNote(String note) {
    if (note == "all") {
      return allAttendance.length.toString();
    }

    return allAttendance
        .where((e) {
          final serverNote = (e.note ?? "").trim().toLowerCase();
          final buttonNote = note.trim().toLowerCase();
          return serverNote == buttonNote;
        })
        .length
        .toString();
  }

  Future<void> refreshAttendance() async {
    if (startDate.value == null || endDate.value == null) {
      Get.snackbar("Info", "Please select start and end date first");
      return;
    }
    selectedNote.value = "";
    await getAttendance();
  }
}

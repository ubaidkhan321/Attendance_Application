import 'package:attendance_system_app/view/attendancedetails/attendance.details.dart';
import 'package:attendance_system_app/view/dashboard/dashboard.screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBarController extends GetxController {
  NavBarController();
  var selectedIndex = 0.obs;

  final List<IconData> icondata = [
    Icons.check_circle_outlined,
    Icons.calendar_month,
  ];

  final List<String> labels = [" Mark Attendance", "Attendance Records"];

  final List pages = [
    DashBoardPage(),
    AttendanceDetailsPage(),
  ];

  void updateIndex(int index) {
    selectedIndex.value = index;
  }
}

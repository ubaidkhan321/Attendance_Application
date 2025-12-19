// ignore_for_file: constant_identifier_names

part of 'constant.dart';

class AppList {
  static const DASHBOARDLIST = [AppStrings.CHECKIN, AppStrings.CHECKOUT];
  static const ATTENDANCEList = [
    AppStrings.ONTIME,
    AppStrings.LATE,
    AppStrings.HALFDAY,
    AppStrings.LATE_SITTING,
    AppStrings.ABSENT,
    AppStrings.EARLY_GOING
  ];
  static const AttendanceListIcon = [
    Icons.access_time_filled,
    Icons.schedule,
    Icons.timelapse,
    Icons.nightlight_round,
    Icons.cancel,
    Icons.calendar_month_rounded
  ];

  static const ATTENDANCE_NOTE_KEY = [
    "On Time",
    "Late",
    "Half Day",
    "Late Sitting",
    "Absent",
    "Early going",
  ];
}

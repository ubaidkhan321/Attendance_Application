import 'package:attendance_system_app/resource/routes/route.name.dart';
import 'package:attendance_system_app/view/attendancedetails/attendance.details.dart';
import 'package:attendance_system_app/view/dashboard/dashboard.screen.dart';
import 'package:attendance_system_app/view/deleteoldattendance/delete.old.attendance.dart';
import 'package:attendance_system_app/view/login/login.screen.dart';
import 'package:attendance_system_app/view/navbar.screen.dart/navbar.screen.dart';
import 'package:attendance_system_app/view/splash/splash.screen.dart';
import 'package:attendance_system_app/view_model/binding/attendancedetails/attendance.Details.binding.dart';
import 'package:attendance_system_app/view_model/binding/dashboard/dashboard.binding.dart';
import 'package:attendance_system_app/view_model/binding/deleteoldattendance/delete.old.attendance.dart';
import 'package:attendance_system_app/view_model/binding/login/login.binding.dart';
import 'package:attendance_system_app/view_model/binding/navbar/navbar.binding.dart';
import 'package:attendance_system_app/view_model/binding/splash/splash.binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/default_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class Pages {
  static Transition get _routeTransition => Transition.rightToLeft;
  static Route<dynamic>? onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case Routes.SPLASH_VIEW:
        return GetPageRoute(
            settings: setting,
            page: () => const SplashPage(),
            binding: SplashBinding(),
            transition: _routeTransition);
      case Routes.LOGIN:
        return GetPageRoute(
            settings: setting,
            page: () => LoginPage(),
            binding: LoginBinding(),
            transition: _routeTransition);
      case Routes.DASHBOARD:
        return GetPageRoute(
            settings: setting,
            page: () => DashBoardPage(),
            binding: DashBoardBinding(),
            transition: _routeTransition);
      case Routes.ADDTEACHER:
      case Routes.ATTENDANCE_DETAILS:
        return GetPageRoute(
            settings: setting,
            page: () => AttendanceDetailsPage(),
            binding: AttendanceDetailsBinding(),
            transition: _routeTransition);
      case Routes.NAVBARSCREEN:
        return GetPageRoute(
            settings: setting,
            page: () => const NavBarScreen(),
            binding: NavBarBinding(),
            transition: _routeTransition);
      case Routes.DELETEDOLD_ATTENDANCE:
        return GetPageRoute(
            settings: setting,
            page: () => const DeleteAttendancePage(),
            binding: DeleteAttendanceBinding(),
            transition: _routeTransition);
      default:
        return null;
    }
  }
}

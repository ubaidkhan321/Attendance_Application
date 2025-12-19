import 'package:attendance_system_app/view_model/controller/forgot.password.controller.dart/forgot.password.controller.dart';
import 'package:attendance_system_app/view_model/controller/login/login.controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => FORGOTPASSWORDController());
  }
}

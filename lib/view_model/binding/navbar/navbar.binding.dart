import 'package:attendance_system_app/view_model/controller/navbar/navbar.controller.dart';
import 'package:get/get.dart';

class NavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavBarController());
  }
}

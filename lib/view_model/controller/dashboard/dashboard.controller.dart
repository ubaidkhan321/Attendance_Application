import 'package:attendance_system_app/model/checkin.attendance.dart';
import 'package:attendance_system_app/repository/checkin/checkin.user.dart';
import 'package:attendance_system_app/repository/checkout/checkout.dart';
import 'package:attendance_system_app/resource/constant/assets.dart';
import 'package:attendance_system_app/view_model/controller/session/session.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  DashboardController();
  RxList<Attendance> attendanceData = <Attendance>[].obs;
  Rx<String> userId = "".obs;
  Rx<bool> isloading = false.obs;
  @override
  void onInit() {
    super.onInit();
    userId.value = SessionController.instance.userSession.data?.sId ?? "";
  }

  Future checkIn(String title) async {
    try {
      isloading.value = true;
      final results = await CheckInRepo.checkinRepo(userId: userId.value);
      if (results.statusCode == 200) {
        attendanceData.add(
          results.attendance ??
              Attendance(
                sId: '',
                user: '',
                status: '',
                note: '',
                ruleType: '',
                createdAt: '',
              ),
        );

        _showSuccessDialog(results.attendance!, title);
        isloading.value = false;
        print("list ${attendanceData}");
        ;
      } else {
        isloading.value = false;
        throw results.message!;
      }
    } catch (e) {
      isloading.value = false;
      String jsonPart = e
          .toString()
          .replaceAll(RegExp(r'Message: |Prefix: Parse Error: |\{|\}|"'), '')
          .trim();

      Get.snackbar("Error", jsonPart, backgroundColor: Colors.orange);
      print("Masla ${jsonPart}");
    }
  }

  void _showSuccessDialog(attendance, String title) {
    final user = SessionController.instance.userSession.data;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              attendance.note == "On Time"
                  ? Image.asset(
                      Assets.ONTIME,
                      height: 150,
                    )
                  : Image.asset(
                      Assets.LATE,
                      height: 150,
                    ),
              const SizedBox(height: 16),
              Text(
                user?.name ?? "User",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${title} Time: ${attendance.createdAt ?? ""}",
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 12),
              Text(
                "${title} Successful",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future checkOut(String title) async {
    try {
      isloading.value = true;
      final result = await CheckOutRepo.checkOutRepo(userId: userId.value);
      if (result.statusCode == 200) {
        isloading.value = false;
        _showSuccessDialog(result.attendance!, title);
      }
    } catch (e) {
      isloading.value = false;
      String jsonPart = e
          .toString()
          .replaceAll(RegExp(r'Message: |Prefix: Parse Error: |\{|\}|"'), '')
          .trim();

      Get.snackbar("Error", jsonPart, backgroundColor: Colors.orange);
      print(e.toString());
    }
  }
}

import 'dart:ui';

import 'package:attendance_system_app/resource/constant/assets.dart';
import 'package:attendance_system_app/resource/constant/constant.dart';
import 'package:attendance_system_app/view_model/controller/dashboard/dashboard.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  var controller = Get.put(DashboardController());
  final LocalAuthentication auth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(2, (index) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: InkWell(
                  onTap: () {
                    if (index == 0) {
                      showAttendanceDialog(context, "Check In", () {
                        handleBiometricAuth(
                            () => controller.checkIn("Check-In"));
                      });
                    } else {
                      showAttendanceDialog(context, "Check Out", () {
                        handleBiometricAuth(
                            () => controller.checkOut("Check-Out"));
                      });
                    }
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      height: 120,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF1E88E5),
                            Color.fromARGB(255, 159, 201, 236)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppList.DASHBOARDLIST[index],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void showAttendanceDialog(
      BuildContext context, String title, VoidCallback ontap) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(
          0.2), // Background ko halka dark rakha hai taaki blue uth kar dikhe
      pageBuilder: (context, anim1, anim2) => Container(),
      transitionBuilder: (context, anim1, anim2, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 10 * anim1.value, sigmaY: 10 * anim1.value),
          child: ScaleTransition(
            scale: anim1,
            child: Obx(
              () => AlertDialog(
                backgroundColor: const Color(0xFF1E88E5).withOpacity(0.3),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: Colors.blue.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                content: GestureDetector(
                  onTap: ontap,
                  child: controller.isloading.value
                      ? const SizedBox(
                          height: 150,
                          child: Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              Assets.FINGURE,
                              height: 100,
                              fit: BoxFit.contain,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .white, // Text white rakha hai taaki blue background par saaf dikhe
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Tap image to scan fingerprint",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70, // Semi-transparent white
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> handleBiometricAuth(VoidCallback onSuccess) async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      if (canCheckBiometrics && isDeviceSupported) {
        bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Mark Attendace',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );

        if (didAuthenticate) {
          onSuccess();
          if (Get.isDialogOpen!) Get.back();
        }
      } else {
        Get.snackbar("Error", "Device biometric support nahi karta");
      }
    } catch (e) {
      Get.snackbar("Error", "Authentication fail: $e");
    }
  }
}

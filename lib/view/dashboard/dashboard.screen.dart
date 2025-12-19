import 'package:attendance_system_app/resource/constant/assets.dart';
import 'package:attendance_system_app/resource/constant/constant.dart';
import 'package:attendance_system_app/view_model/controller/dashboard/dashboard.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  var controller = Get.put(DashboardController());
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAttendanceDialog(context, "Check In", () {
        controller.checkIn();
      });
    });
  }

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
                        controller.checkIn();
                      });
                    } else {
                      showAttendanceDialog(context, "Check Out", () {
                        controller.checkOut();
                      });
                    }
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadowColor: Colors.black.withOpacity(0.3),
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
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
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
    showDialog(
      context: context,
      builder: (context) {
        return Obx(
          () => GestureDetector(
            onTap: ontap,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: controller.isloading.value
                  ? const SizedBox(
                      height: 120,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          Assets.FINGURE,
                          height: 130,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:attendance_system_app/resource/constant/assets.dart';
import 'package:attendance_system_app/resource/routes/route.name.dart';
import 'package:attendance_system_app/utils/custom.register.dart';
import 'package:attendance_system_app/view_model/controller/deleteattendance/delete.old.attendance.controller.dart';
import 'package:attendance_system_app/view_model/controller/login/login.controller.dart';
import 'package:attendance_system_app/view_model/controller/session/session.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionController.instance;
    var deleteAttendancecontroller = Get.put(DeleteAttendanceController());
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: ClipPath(
        clipper: TopRightCurveClipper(),
        child: Drawer(
          width: MediaQuery.of(context).size.width / 1.6,
          backgroundColor: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 60.0),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Image.asset(Assets.APP_LOGO),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session.userSession.data?.name ?? "",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.blue,
                                      height: 1.1,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    session.userSession.data?.type ?? "",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Divider(
                          color: Colors.grey.shade500,
                          height: 10,
                          thickness: 1,
                        ),
                      ),
                      ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildDrawerItem(Icons.home, "Home", context, () {
                            Navigator.pop(context);
                          }),
                          SessionController.instance.userSession.data?.type ==
                                  "admin"
                              ? _buildDrawerItem(
                                  Icons.person_3_outlined, "Register", context,
                                  () {
                                  userRegister(context);
                                })
                              : SizedBox(),
                          SessionController.instance.userSession.data?.type ==
                                  "admin"
                              ? _buildDrawerItem(Icons.delete_outline_outlined,
                                  "Delete Attendance", context, () {
                                  showDialogBox(context, () async {
                                    await deleteAttendancecontroller
                                        .oldAttendanceDelete();
                                  });
                                })
                              : SizedBox(),
                          _buildDrawerItem(Icons.logout, "Logout", context,
                              () async {
                            await session.clearSession();

                            Get.offAllNamed(Routes.LOGIN);
                            Get.delete<LoginController>(force: true);
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Divider(
                  height: 2,
                  thickness: 1,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      IconData icon, String label, BuildContext context, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            const SizedBox(width: 7.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopRightCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width - 60, 0);

    path.quadraticBezierTo(
      size.width,
      size.height * 0.08,
      size.width,
      size.height * 0.2,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

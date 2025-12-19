import 'package:attendance_system_app/resource/constant/constant.dart';
import 'package:attendance_system_app/utils/custom_attendance_button.dart';
import 'package:attendance_system_app/view_model/controller/attendancedetails/attendance.details.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceDetailsPage extends StatelessWidget {
  AttendanceDetailsPage({super.key});

  final AttendanceDetailsController controller =
      Get.put(AttendanceDetailsController());

  @override
  Widget build(BuildContext context) {
    final int rowCount = (AppList.ATTENDANCEList.length / 2).ceil();
    final double buttonWidth = (MediaQuery.of(context).size.width - 34) / 2;
    final double buttonHeight = 140;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            await controller.refreshAttendance();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomAttendanceButton(
                        count: "",
                        title: controller.startDate.value == null
                            ? "Start Date"
                            : DateFormat('yyyy-MM-dd')
                                .format(controller.startDate.value!),
                        icon: Icons.calendar_month,
                        color: Colors.white,
                        gradient: const [
                          Color(0xFF1E88E5),
                          Color.fromARGB(255, 159, 201, 236),
                        ],
                        onTap: () {
                          controller.pickDate(
                            context,
                            controller.startDate,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomAttendanceButton(
                        title: controller.endDate.value == null
                            ? "End Date"
                            : DateFormat('yyyy-MM-dd')
                                .format(controller.endDate.value!),
                        icon: Icons.calendar_month,
                        color: Colors.white,
                        gradient: const [
                          Color(0xFF1E88E5),
                          Color.fromARGB(255, 159, 201, 236),
                        ],
                        count: "",
                        onTap: () {
                          controller.pickDate(
                            context,
                            controller.endDate,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (controller.isLoading.value)
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (controller.filteredAttendance.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                      child: Text(
                        "No Attendance found",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                else ...[
                  // 3️⃣ Attendance Grid Buttons
                  for (int rowIndex = 0; rowIndex < rowCount; rowIndex++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          _attendanceButton(
                            context,
                            index: rowIndex * 2,
                            width: buttonWidth,
                            height: buttonHeight,
                          ),
                          const SizedBox(width: 10),
                          if ((rowIndex * 2 + 1) <
                              AppList.ATTENDANCEList.length)
                            _attendanceButton(
                              context,
                              index: rowIndex * 2 + 1,
                              width: buttonWidth,
                              height: buttonHeight,
                            )
                          else
                            SizedBox(width: buttonWidth, height: buttonHeight),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),

                  // 4️⃣ Attendance History
                  const Text(
                    "Attendance History",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.filteredAttendance.length,
                    itemBuilder: (context, index) {
                      final data = controller.filteredAttendance[index];
                      final createdAt =
                          controller.parseAttendanceDate(data.createdAt!);

                      final date =
                          "${createdAt.day.toString().padLeft(2, '0')} "
                          "${_monthName(createdAt.month)}";
                      final time = DateFormat("hh:mm a").format(createdAt);
                      final bool isCheckIn = data.status == "checkin";

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    date,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 10,
                                        color: isCheckIn
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        isCheckIn ? "IN" : "OUT",
                                        style: TextStyle(
                                          color: isCheckIn
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    data.note ?? "NA",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    time,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    isCheckIn ? "Check In" : "Check Out",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================== EXISTING _attendanceButton & helpers ==================
  Widget _attendanceButton(
    BuildContext context, {
    required int index,
    required double width,
    required double height,
  }) {
    final controller = Get.find<AttendanceDetailsController>();
    final isSelected =
        controller.selectedNote.value == AppList.ATTENDANCE_NOTE_KEY[index];

    return SizedBox(
      width: width,
      height: height,
      child: CustomAttendanceButton(
        title: AppList.ATTENDANCEList[index],
        icon: AppList.AttendanceListIcon[index],
        gradient: isSelected
            ? const [
                Color.fromARGB(255, 247, 123, 7),
                Color.fromARGB(255, 252, 237, 222),
              ]
            : const [
                Color(0xFF1E88E5),
                Color.fromARGB(255, 159, 201, 236),
              ],
        onTap: () {
          controller.filterByNote(
            AppList.ATTENDANCE_NOTE_KEY[index],
          );
        },
        color: Colors.white,
        count: controller.countByNote(
          AppList.ATTENDANCE_NOTE_KEY[index],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return names[month - 1];
  }
}

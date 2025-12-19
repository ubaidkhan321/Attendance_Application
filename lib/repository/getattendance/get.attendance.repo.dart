import 'package:attendance_system_app/data/network/base.api.services.dart';
import 'package:attendance_system_app/data/network/network.api.services.dart';
import 'package:attendance_system_app/model/get.attendance.model.dart';
import 'package:attendance_system_app/resource/constant/globals.url.dart';

class GetAttendanceRepository {
  static BaseNetworkApi networkApi = NetworkApiClass();
  static String getAttendanceUrl = Global.GET_ATTENDANCE;
  static Future<GetAttendance> getAttendanceRepo(
      {required String? userId,
      required String? startDate,
      required String? endDate}) async {
    try {
      final response = await networkApi.postApi(getAttendanceUrl,
          {"user_Id": userId, "startDate": startDate, "endDate": endDate});
      return GetAttendance.fromJson(response);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
